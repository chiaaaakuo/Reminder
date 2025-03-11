import 'package:reminder/models/reminder.dart';

abstract class Repository {
  const Repository();

  Future<List<Reminder>> getReminders();

  Future<void> addReminder(Reminder reminder);

  Future<void> deleteReminder(String id);

  Future<void> updateReminder(Reminder reminder);

}