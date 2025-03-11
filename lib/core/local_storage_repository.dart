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
    getReminderList();
  }

  @override
  Future<void> addReminder(Reminder reminder) async {
    final List<Reminder> reminderList = await getReminderList();
    final int index = reminderList.indexWhere((item) => item.id == reminder.id);
    if (index == -1) {
      reminderList.add(reminder);
    }
    sharedPreference.setString(_todosCollectionKey, json.encode(reminderList));
  }

  @override
  Future<void> deleteReminder(String id) async{
    final List<Reminder> reminderList = await getReminderList();
    reminderList.removeWhere((reminder) => reminder.id == id);
    sharedPreference.setString(_todosCollectionKey, json.encode(reminderList));
  }

  @override
  Future<List<Reminder>> getReminderList() async {
    final String? value = sharedPreference.getString(_todosCollectionKey);
    if (value == null) {
      return [];
    }
    final reminderJson = json.decode(value);
    if (reminderJson! is List) {
      return [];
    }
    final reminderList = List<Map<dynamic, dynamic>>.from(reminderJson).map((item) => Reminder.fromJson(item)).toList();
    return reminderList;
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    final List<Reminder> reminderList = await getReminderList();
    final int index = reminderList.indexWhere((item) => item.id == reminder.id);
    if (index == -1) {
      return;
    }
    reminderList[index] = reminder;
    sharedPreference.setString(_todosCollectionKey, json.encode(reminderList));
  }
}
