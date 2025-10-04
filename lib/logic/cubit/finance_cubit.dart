import 'package:expenses_tracking_app/data/models/reminder_model.dart';
import 'package:expenses_tracking_app/data/models/transaction_model.dart';
import 'package:expenses_tracking_app/data/repositories/reminders_repo.dart';
import 'package:expenses_tracking_app/data/repositories/user_repo.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/transaction_repo.dart';
import 'finance_state.dart';

class FinanceCubit extends Cubit<FinanceState> {
  final ITransactionRepository transactionRepository;
  final UserRepository userRepo;
  final IReminderRepository reminderRepository = RemindersRepository();

  FinanceCubit(this.transactionRepository, this.userRepo)
    : super(FinanceInitial()) {}

  Future<void> loadUsername() async {
    final username = await userRepo.getUsername() ?? 'Guest';
    emit(
      FinanceLoaded(
        username: username,
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
      ),
    );
  }

  void setUsername(String username) async {
    await userRepo.saveUsername(username);

    if (state is FinanceLoaded) {
      final current = state as FinanceLoaded;
      emit(current.copyWith(username: username));
    } else {
      emit(FinanceInitial(username: username));
    }
  }

  // --------------- Reminder Methods ---------------------

  Future<void> loadReminders() async {
    final reminders = await reminderRepository.getAllReminders();
    if (state is FinanceLoaded) {
      final current = state as FinanceLoaded;
      emit(current.copyWith(reminders: reminders));
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
        balance: balance,
        totalIncome: totalIncome,
        totalExpenses: totalExpenses,
        transactions: transactions,
        username: state is FinanceLoaded
            ? (state as FinanceLoaded).username
            : "Guest",
        reminders: state is FinanceLoaded
            ? (state as FinanceLoaded).reminders
            : [ ]
      ),
    );
  }
}
