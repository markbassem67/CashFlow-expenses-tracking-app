import 'package:expenses_tracking_app/data/models/transaction_model.dart';
import 'package:expenses_tracking_app/data/repositories/user_repo.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/transaction_repo.dart';
import 'finance_state.dart';

class FinanceCubit extends Cubit<FinanceState> {
  final ITransactionRepository transactionRepository;
  final UserRepository userRepo;

  FinanceCubit(this.transactionRepository, this.userRepo)
    : super(FinanceInitial()) {
   // _init();
  }

 /*  Future<void> _init() async {
    await loadUsername();
    await loadTransactions();
  } */

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
        : <Transaction>[]; // Use <Transaction>[] for empty list

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
      ),
    );
  }
}
