import 'package:reminder/core/repository.dart';
import 'package:reminder/models/reminder.dart';

class RepositoryService {
  final Repository repository;

  const RepositoryService(this.repository);

  Future<List<Reminder>> getReminderList() async => await repository.getReminderList();

  Future<void> addReminder(Reminder reminder) async => await repository.addReminder(reminder);

  Future<void> updateReminder(Reminder reminder) async => await repository.updateReminder(reminder);

  Future<void> deleteReminder(String id) async => await repository.deleteReminder(id);
}