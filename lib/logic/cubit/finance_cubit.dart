import 'package:expenses_tracking_app/data/models/reminder_model.dart';
import 'package:expenses_tracking_app/data/models/transaction_model.dart';
import 'package:expenses_tracking_app/data/repositories/local_auth_repo.dart';
import 'package:expenses_tracking_app/data/repositories/reminders_repo.dart';
import 'package:expenses_tracking_app/data/repositories/user_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/transaction_repo.dart';
import 'finance_state.dart';

class FinanceCubit extends Cubit<FinanceState> {
  final ITransactionRepository transactionRepository;
  final UserRepository userRepo;
  final IReminderRepository reminderRepository = RemindersRepository();
  final LocalAuthRepository localAuthRepo;

  FinanceCubit(this.transactionRepository, this.userRepo, this.localAuthRepo)
    : super(FinanceInitial()) {}

  Future<bool> isFirstLaunch() async {
    return await userRepo.isFirstLaunch();
  }

  Future<void> setFirstLaunchFalse() async {
    await userRepo.setFirstLaunchFalse();
  }

  Future<void> unlockApp() async {
    try {
      final unlocked = await localAuthRepo.authenticateIfEnabled();

      if (!unlocked) {
        emit(FinanceLocked());
        return;
      }

      await loadAllData();
    } catch (e) {
      emit(FinanceError('Authentication failed: $e'));
    }
  }

  Future<void> loadAllData() async {
    emit(FinanceLoading());

    try {
      final transactions = await transactionRepository.getAllTransactions();
      final reminders = await reminderRepository.getAllReminders();
      final username = await userRepo.getUsername() ?? 'Guest';
      final biometricsEnabled = await userRepo.getBiometricsEnabled();
      final currency = await userRepo.getUserCurrency();

      // Calculate stats
      final totalIncome = transactions
          .where((t) => t.type == TransactionType.income)
          .fold(0.0, (sum, t) => sum + t.amount);

      final totalExpenses = transactions
          .where((t) => t.type == TransactionType.expense)
          .fold(0.0, (sum, t) => sum + t.amount);

      emit(
        FinanceLoaded(
          transactions: transactions,
          reminders: reminders,
          balance: totalIncome - totalExpenses,
          totalIncome: totalIncome,
          totalExpenses: totalExpenses,
          username: username,
          biometricsOn: biometricsEnabled,
          currency: currency,
        ),
      );
    } catch (e) {
      emit(FinanceError('Failed to load data: $e'));
    }
  }

  Future<void> setUserCurrency(String currency) async {
    await userRepo.setUserCurrency(currency);

    if (state is FinanceLoaded) {
      final current = state as FinanceLoaded;
      emit(
        current.copyWith(
          username: current.username,
          biometricsOn: current.biometricsOn,
          currency: currency,
        ),
      );
    }
  }

  // --------------- Biometrics Methods ---------------------

  Future<void> toggleBiometrics(bool value) async {
    if (state is! FinanceLoaded) return;
    final currentState = state as FinanceLoaded;
    await userRepo.setBiometricsEnabled(value);
    emit(
      currentState.copyWith(
        biometricsOn: value,
        currency: currentState.currency,
      ),
    );
  }

  Future<bool> loadBiometricsSetting() async {
    final isEnabled = await userRepo.getBiometricsEnabled();

    if (isEnabled) {
      emit(FinanceLocked());
    } else if (state is FinanceLoaded) {
      final currentState = state as FinanceLoaded;
      emit(
        currentState.copyWith(
          biometricsOn: false,
          currency: currentState.currency,
        ),
      );
    }
    return isEnabled;
  }

  // --------------- Username Methods ---------------------

  Future<void> loadUsername() async {
    final username = await userRepo.getUsername() ?? 'Guest';
    emit(
      FinanceLoaded(
        username: username,
        biometricsOn: state is FinanceLoaded
            ? (state as FinanceLoaded).biometricsOn
            : false,
        balance: state is FinanceLoaded ? (state as FinanceLoaded).balance : 0,
        totalIncome: state is FinanceLoaded
            ? (state as FinanceLoaded).totalIncome
            : 0,
        totalExpenses: state is FinanceLoaded
            ? (state as FinanceLoaded).totalExpenses
            : 0,
        transactions: state is FinanceLoaded
            ? (state as FinanceLoaded).transactions
            : [],
        reminders: state is FinanceLoaded
            ? (state as FinanceLoaded).reminders
            : [],
        currency: state is FinanceLoaded
            ? (state as FinanceLoaded).currency
            : 'USD',
      ),
    );
  }

  void setUsername(String username) async {
    await userRepo.saveUsername(username);

    if (state is FinanceLoaded) {
      final current = state as FinanceLoaded;
      emit(
        current.copyWith(
          username: username,
          biometricsOn: current.biometricsOn,
          currency: current.currency,
        ),
      );
    } else {
      emit(FinanceInitial(username: username));
    }
  }

  // --------------- Reminder Methods ---------------------

  Future<void> loadReminders() async {
    final reminders = await reminderRepository.getAllReminders();
    if (state is FinanceLoaded) {
      final current = state as FinanceLoaded;
      emit(
        current.copyWith(
          reminders: reminders,
          biometricsOn: current.biometricsOn,
          currency: current.currency,
        ),
      );
    }
  }

  Future<void> addReminder(Reminder reminder) async {
    await reminderRepository.addReminder(reminder);
    await loadReminders();
  }

  Future<void> updateReminder(Reminder reminder) async {
    await reminderRepository.updateReminder(reminder);
    await loadReminders();
  }

  Future<void> deleteReminder(String id) async {
    await reminderRepository.deleteReminder(id);
    await loadReminders();
  }

  // --------------- Transaction Methods ---------------------

  Future<void> loadTransactions() async {
    emit(FinanceLoading());
    try {
      final transactions = await transactionRepository.getAllTransactions();
      _emitWithStats(transactions);
    } catch (e) {
      emit(FinanceError(e.toString()));
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    await transactionRepository.addTransaction(transaction);

    final currentTransactions = state is FinanceLoaded
        ? (state as FinanceLoaded).transactions
        : <Transaction>[];

    final updatedTransactions = List<Transaction>.from(currentTransactions)
      ..add(transaction);

    for (var t in updatedTransactions) {}

    // Recalculate totals safely
    final totalIncome = updatedTransactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) {
          return sum + t.amount;
        });

    final totalExpenses = updatedTransactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) {
          return sum + t.amount;
        });

    emit(
      FinanceLoaded(
        biometricsOn: state is FinanceLoaded
            ? (state as FinanceLoaded).biometricsOn
            : false,
        transactions: updatedTransactions,
        totalIncome: totalIncome,
        totalExpenses: totalExpenses,
        balance: totalIncome - totalExpenses,
        username: state is FinanceLoaded
            ? (state as FinanceLoaded).username
            : "Guest",
        reminders: state is FinanceLoaded
            ? (state as FinanceLoaded).reminders
            : [],
        currency: state is FinanceLoaded
            ? (state as FinanceLoaded).currency
            : 'USD',
      ),
    );
  }

  Future<void> deleteTransaction(String id) async {
    await transactionRepository.deleteTransaction(id);
    final transactions = await transactionRepository.getAllTransactions();
    _emitWithStats(transactions);
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await transactionRepository.updateTransaction(transaction);
    final transactions = await transactionRepository.getAllTransactions();
    _emitWithStats(transactions);
  }

  // Helper: recompute totals & balance
  void _emitWithStats(List<Transaction> transactions) {
    final totalIncome = transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalExpenses = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);

    final balance = totalIncome - totalExpenses;

    emit(
      FinanceLoaded(
        biometricsOn: state is FinanceLoaded
            ? (state as FinanceLoaded).biometricsOn
            : false,

        balance: balance,
        totalIncome: totalIncome,
        totalExpenses: totalExpenses,
        transactions: transactions,
        username: state is FinanceLoaded
            ? (state as FinanceLoaded).username
            : "Guest",
        reminders: state is FinanceLoaded
            ? (state as FinanceLoaded).reminders
            : [],
        currency: state is FinanceLoaded
            ? (state as FinanceLoaded).currency
            : 'USD',
      ),
    );
  }
}
