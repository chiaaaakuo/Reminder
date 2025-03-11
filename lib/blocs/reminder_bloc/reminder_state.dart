part of 'reminder_bloc.dart';

final class ReminderState {
  final List<Reminder> reminders;
  final int completedReminders;
  final SortType sortType;

  ReminderState({
    this.reminders = const <Reminder>[],
    this.completedReminders = 0,
    this.sortType = SortType.asc,
  });

  ReminderState copywith({
    List<Reminder>? reminders,
    int? completedReminders,
    SortType? sortType,
  }) {
    return ReminderState(
      reminders: reminders ?? this.reminders,
      completedReminders: completedReminders ?? this.completedReminders,
      sortType: sortType ?? this.sortType,
    );
  }
}
