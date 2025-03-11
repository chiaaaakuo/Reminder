import 'dart:convert';

import 'package:reminder/core/repository.dart';
import 'package:reminder/models/reminder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageRepository extends Repository {
  final SharedPreferencesWithCache sharedPreference;

  static const String _todosCollectionKey = "todosCollectionKey";

  LocalStorageRepository({
    required this.sharedPreference,
  }) {
    _init();
  }

  _init() {
    getReminders();
  }

  @override
  Future<void> addReminder(Reminder reminder) async {
    final List<Reminder> reminders = await getReminders();
    final int index = reminders.indexWhere((item) => item.id == reminder.id);
    if (index == -1) {
      reminders.add(reminder);
    }
    await sharedPreference.setString(_todosCollectionKey, json.encode(reminders));
  }

  @override
  Future<void> deleteReminder(String id) async{
    final List<Reminder> reminders = await getReminders();
    reminders.removeWhere((reminder) => reminder.id == id);
    await sharedPreference.setString(_todosCollectionKey, json.encode(reminders));
  }

  @override
  Future<List<Reminder>> getReminders() async {
    final String? value = sharedPreference.getString(_todosCollectionKey);
    if (value == null) {
      return [];
    }
    final dynamic reminderJson = json.decode(value);
    if (reminderJson is! List) {
      return [];
    }
    final reminders = List<Map<dynamic, dynamic>>.from(reminderJson).map((item) => Reminder.fromJson(item)).toList();
    return reminders;
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    final List<Reminder> reminders = await getReminders();
    final int index = reminders.indexWhere((item) => item.id == reminder.id);
    if (index == -1) {
      return;
    }
    reminders[index] = reminder;
    await sharedPreference.setString(_todosCollectionKey, json.encode(reminders));
  }
}
