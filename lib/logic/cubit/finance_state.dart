import 'package:expenses_tracking_app/data/models/transaction_model.dart';

abstract class FinanceState {}

class FinanceInitial extends FinanceState {
  final String username;
  FinanceInitial({this.username = "Guest"});
}

class FinanceLoading extends FinanceState {}

class FinanceLoaded extends FinanceState {
  final double balance;
  final double totalIncome;
  final double totalExpenses;
  final List<Transaction> transactions;
    final String username;


  FinanceLoaded({
    required this.balance,
    required this.totalIncome,
    required this.totalExpenses,
    required this.transactions,
    required this.username,
  });

  FinanceLoaded copyWith({
    double? balance,
    double? totalIncome,
    double? totalExpenses,
    List<Transaction>? transactions, 
    String? username,
  }) {
    return FinanceLoaded(
      balance: balance ?? this.balance,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      transactions: transactions ?? this.transactions,
      username: username ?? this.username,
    );
  }
}

class FinanceError extends FinanceState {
  final String message;
  FinanceError(this.message);
}
