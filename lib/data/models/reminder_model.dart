import 'package:hive/hive.dart';
part 'reminder_model.g.dart';

@HiveType(typeId: 2) // give a unique typeId
class Reminder extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
final  double amount;

  @HiveField(3)
  final DateTime dateTime;

  @HiveField(4)
  final bool isCompleted;


  Reminder({
    required this.id,
    required this.title,
    required this.amount,
    required this.dateTime,
    this.isCompleted = false,
  });
}
