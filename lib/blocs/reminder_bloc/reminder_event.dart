part of 'reminder_bloc.dart';

@immutable
sealed class ReminderEvent {}

final class LoadReminders extends ReminderEvent {}

final class AddReminder extends ReminderEvent {
  final String title;

  AddReminder({required this.title});
}

final class DeleteReminder extends ReminderEvent {
  final String id;

  DeleteReminder({required this.id});
}

final class ToggleReminderStatus extends ReminderEvent {
  final Reminder reminder;
  final bool isDone;

  ToggleReminderStatus({
    required this.reminder,
    this.isDone = false,
  });
}

final class ToggleRemindersSort extends ReminderEvent {
  final SortType sortType;

  ToggleRemindersSort({this.sortType = SortType.createTimeAsc});
}
