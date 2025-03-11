import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:reminder/core/repository_service.dart';
import 'package:reminder/models/sort_type.dart';
import 'package:reminder/models/reminder.dart';

part 'reminder_event.dart';

part 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final RepositoryService _repository;

  ReminderBloc({
    required RepositoryService repository,
  })  : _repository = repository,
        super(ReminderState()) {
    on<LoadReminders>((event, emit) async => await _loadReminders(emit));
    on<AddReminder>((event, emit) async => await _addReminder(event, emit));
    on<DeleteReminder>((event, emit) async => await _deleteReminder(event, emit));
    on<ToggleReminderStatus>((event, emit) async => await _toggleReminderStatus(event, emit));
    on<ToggleRemindersSort>((event, emit) async => await _toggleRemindersSort(event, emit));
  }

  Future<void> _loadReminders(Emitter<ReminderState> emit) async {
    final List<Reminder> reminders = await _repository.getReminders();
    if (state.sortType == SortType.activePriority) {
      reminders.sort(_sortByComplete);
    }
    emit(state.copywith(
      reminders: reminders,
      completedReminders: reminders.where((reminder) => reminder.done).length,
    ));
  }

  int _sortByComplete(Reminder prev, Reminder post) {
    if (prev.done == post.done) {
      return prev.dateTime.compareTo(post.dateTime);
    }
    if (prev.done) {
      return 1;
    }
    return -1;
  }

  Future<void> _addReminder(AddReminder event, Emitter<ReminderState> emit) async {
    final reminder = Reminder.temp(title: event.title);
    await _repository.addReminder(reminder);

    await _loadReminders(emit);
  }

  Future<void> _deleteReminder(DeleteReminder event, Emitter<ReminderState> emit) async {
    await _repository.deleteReminder(event.id);

    await _loadReminders(emit);
  }

  Future<void> _toggleReminderStatus(ToggleReminderStatus event, Emitter<ReminderState> emit) async {
    final newReminder = event.reminder.copyWith(done: event.isDone);
    await _repository.updateReminder(newReminder);

    await _loadReminders(emit);
  }

  Future<void> _toggleRemindersSort(ToggleRemindersSort event, Emitter<ReminderState> emit) async {
    emit(state.copywith(
      sortType: event.sortType,
    ));

    await _loadReminders(emit);
  }
}
