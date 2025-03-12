import 'dart:convert';

import 'package:reminder/core/exceptions.dart';
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

  void _init() {
    getReminders();
  }

  @override
  Future<void> addReminder(Reminder reminder) async {
    try {
      final List<Reminder> reminders = await getReminders();
      final int index = reminders.indexWhere((item) => item.id == reminder.id);
      if (index == -1) {
        reminders.add(reminder);
      }
      await sharedPreference.setString(_todosCollectionKey, json.encode(reminders));
    } on ArgumentError catch (e) {
      throw RepoException(e.message);
    } on RepoException {
      rethrow;
    } catch (e) {
      throw RepoException("An unexpected error occurred.\n $e");
    }
  }

  @override
  Future<void> deleteReminder(String id) async {
    try {
      final List<Reminder> reminders = await getReminders();
      reminders.removeWhere((reminder) => reminder.id == id);
      await sharedPreference.setString(_todosCollectionKey, json.encode(reminders));
    } on ArgumentError catch (e) {
      throw RepoException("Argument Error: ${e.message}");
    } on RepoException {
      rethrow;
    } catch (e) {
      throw RepoException("An unexpected error occurred.\n $e");
    }
  }

  @override
  Future<List<Reminder>> getReminders() async {
    try {
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
    } on ArgumentError catch (e) {
      throw RepoException("Argument Error: ${e.message}");
    } catch (e) {
      throw RepoException("An unexpected error occurred.\n $e");
    }
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    try {
      final List<Reminder> reminders = await getReminders();
      final int index = reminders.indexWhere((item) => item.id == reminder.id);
      if (index == -1) {
        return;
      }
      reminders[index] = reminder;
      await sharedPreference.setString(_todosCollectionKey, json.encode(reminders));
    } on ArgumentError catch (e) {
      throw RepoException("Argument Error: ${e.message}");
    } on RepoException {
      rethrow;
    } catch (e) {
      throw RepoException(e.toString());
    }
  }
}
