import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0) // Unique ID for this model
enum TransactionType {
  @HiveField(0)
  income,

  @HiveField(1)
  expense,
}

@HiveType(typeId: 1) // Unique ID for this class
class Transaction extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final TransactionType type;

  @HiveField(3)
  final String name;

  @HiveField(4)
  final DateTime date;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.name,
    required this.date,
  });
}
