part of 'reminder_bloc.dart';

final class ReminderState {
  final List<Reminder> reminders;
  final int completedReminders;

  ReminderState({
    this.reminders = const <Reminder>[],
    this.completedReminders = 0,
  });

  ReminderState copywith({
    List<Reminder>? reminders,
    int? completedReminders,
  }) {
    return ReminderState(
      reminders: reminders ?? this.reminders,
      completedReminders: completedReminders ?? this.completedReminders,
    );
  }
}
