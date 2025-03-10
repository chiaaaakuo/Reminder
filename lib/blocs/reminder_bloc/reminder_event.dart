part of 'reminder_bloc.dart';

@immutable
sealed class ReminderEvent {}

final class LoadReminders extends ReminderEvent {}

final class CreateReminder extends ReminderEvent {
  final Reminder reminder;
  CreateReminder({required this.reminder});
}

final class DeleteReminder extends ReminderEvent {
  final String id;
  DeleteReminder({required this.id});
}
