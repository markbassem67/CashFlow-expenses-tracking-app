import 'package:expenses_tracking_app/data/models/reminder_model.dart';
import 'package:hive/hive.dart';

abstract class IReminderRepository {
  Future<void> addReminder(Reminder reminder);
  Future<List<Reminder>> getAllReminders();
  Future<void> updateReminder(Reminder reminder);
  Future<void> deleteReminder(String id);
  Future<List<Reminder>> getRemindersByDateRange(DateTime start, DateTime end);
}

class RemindersRepository implements IReminderRepository {
  static const String _boxName = 'reminders';

  Future<Box<Reminder>> _openBox() async {
    return await Hive.openBox<Reminder>(_boxName);
  }

  @override
  Future<void> addReminder(Reminder reminder) async {
    final box = await _openBox();
    await box.put(reminder.id, reminder);
  }

  @override
  Future<List<Reminder>> getAllReminders() async {
    final box = await _openBox();
    return box.values.toList();
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    final box = await _openBox();
    await box.put(reminder.id, reminder);
  }

  @override
  Future<void> deleteReminder(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  @override
  Future<List<Reminder>> getRemindersByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final box = await _openBox();
    return box.values
        .where((t) => t.dateTime.isAfter(start) && t.dateTime.isBefore(end))
        .toList();
  }
}
