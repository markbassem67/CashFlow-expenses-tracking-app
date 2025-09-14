import 'package:expenses_tracking_app/data/models/transaction_model.dart';
import 'package:hive/hive.dart';

abstract class ITransactionRepository {
  Future<void> addTransaction(Transaction transaction);

  Future<List<Transaction>> getAllTransactions();

  Future<void> updateTransaction(Transaction transaction);

  Future<void> deleteTransaction(String id);

  Future<List<Transaction>> getTransactionsByType(TransactionType type);

  Future<List<Transaction>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  );
}

class TransactionRepository implements ITransactionRepository {
  static const String _boxName = 'transactions';

  Future<Box<Transaction>> _openBox() async {
    return await Hive.openBox<Transaction>(_boxName);
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    final box = await _openBox();
    await box.put(transaction.id, transaction);
  }

  @override
  Future<List<Transaction>> getAllTransactions() async {
    final box = await _openBox();
    return box.values.toList();
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    final box = await _openBox();
    await box.put(transaction.id, transaction);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  @override
  Future<List<Transaction>> getTransactionsByType(TransactionType type) async {
    final box = await _openBox();
    return box.values.where((t) => t.type == type).toList();
  }

  @override
  Future<List<Transaction>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final box = await _openBox();
    return box.values
        .where((t) => t.date.isAfter(start) && t.date.isBefore(end))
        .toList();
  }
}
