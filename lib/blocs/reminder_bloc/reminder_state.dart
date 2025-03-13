part of 'reminder_bloc.dart';

enum RemindersStatus { idle, loading, success, failure }

enum RemindersAction { load, update, add, delete }

final class ReminderState {
  final List<Reminder> reminders;
  final int completedReminders;
  final SortType sortType;
  final RemindersStatus? status;
  final RemindersAction? action;
  final int? scrollToIndex;
  final String? errorMessage;

  ReminderState({
    this.reminders = const <Reminder>[],
    this.completedReminders = 0,
    this.sortType = SortType.createTimeAsc,
    this.status = RemindersStatus.idle,
    this.action,
    this.scrollToIndex,
    this.errorMessage,
  });

  ReminderState copyWith({
    RemindersAction? action,
    RemindersStatus? status,
    String? errorMessage,
    List<Reminder>? reminders,
    int? completedReminders,
    SortType? sortType,
    int? scrollToIndex,
  }) {
    return ReminderState(
      action: action,
      status: status,
      errorMessage: errorMessage,
      reminders: reminders ?? this.reminders,
      completedReminders: completedReminders ?? this.completedReminders,
      sortType: sortType ?? this.sortType,
      scrollToIndex: scrollToIndex ?? this.scrollToIndex,
    );
  }
}
