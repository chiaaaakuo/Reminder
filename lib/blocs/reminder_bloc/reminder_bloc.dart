import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:reminder/core/exceptions.dart';
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
    emit(state.copywith(
      action: RemindersAction.load,
      status: RemindersStatus.loading,
    ));

    try {
      List<Reminder> reminders = _sortReminders(await _repository.getReminders(), state.sortType);

      emit(state.copywith(
        action: RemindersAction.load,
        status: RemindersStatus.success,
        reminders: reminders,
        completedReminders: reminders.where((reminder) => reminder.isDone).length,
      ));
    } on RepoException catch (e) {
      emit(state.copywith(
        action: RemindersAction.load,
        status: RemindersStatus.failure,
        errorMessage: e.message,
      ));
    }
  }

  Future<void> _addReminder(AddReminder event, Emitter<ReminderState> emit) async {
    emit(state.copywith(
      action: RemindersAction.add,
      status: RemindersStatus.loading,
    ));

    try {
      final reminder = Reminder.temp(title: event.title);
      await _repository.addReminder(reminder);
      final List<Reminder> reminders = _sortReminders([...state.reminders, reminder], state.sortType);
      final scrollToIndex = reminders.indexOf(reminder);

      emit(state.copywith(
        action: RemindersAction.add,
        status: RemindersStatus.success,
        scrollToIndex: scrollToIndex,
        reminders: reminders,
      ));
    } on RepoException catch (e) {
      emit(state.copywith(
        action: RemindersAction.add,
        status: RemindersStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copywith(
        action: RemindersAction.add,
        status: RemindersStatus.failure,
        errorMessage: "新增失敗 $e",
      ));
    }
  }

  Future<void> _deleteReminder(DeleteReminder event, Emitter<ReminderState> emit) async {
    emit(state.copywith(
      action: RemindersAction.delete,
      status: RemindersStatus.loading,
    ));
    try {
      await _repository.deleteReminder(event.id);
      List<Reminder> reminders = [...state.reminders]..removeWhere((reminder) => reminder.id == event.id);
      reminders = _sortReminders(reminders, state.sortType);

      emit(state.copywith(
        action: RemindersAction.delete,
        status: RemindersStatus.success,
        reminders: reminders,
        completedReminders: reminders.where((reminder) => reminder.isDone).length,
      ));
    } on RepoException catch (e) {
      emit(state.copywith(
        action: RemindersAction.delete,
        status: RemindersStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copywith(
        action: RemindersAction.delete,
        status: RemindersStatus.failure,
        errorMessage: "刪除失敗 $e",
      ));
    }
  }

  Future<void> _toggleReminderStatus(ToggleReminderStatus event, Emitter<ReminderState> emit) async {
    emit(state.copywith(
      action: RemindersAction.update,
      status: RemindersStatus.loading,
    ));
    try {
      final newReminder = event.reminder.copyWith(isDone: event.isDone);
      await _repository.updateReminder(newReminder);
      List<Reminder> reminders = [...state.reminders];

      int completeCount = 0;
      for (int i = 0; i < reminders.length; i++) {
        if (reminders[i].id == newReminder.id) {
          reminders[i] = newReminder;
        }
        if (reminders[i].isDone) {
          completeCount++;
        }
      }

      reminders = _sortReminders(reminders, state.sortType);

      emit(state.copywith(
        action: RemindersAction.update,
        status: RemindersStatus.success,
        reminders: reminders,
        completedReminders: completeCount,
      ));
    } on RepoException catch (e) {
      emit(state.copywith(
        action: RemindersAction.update,
        status: RemindersStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copywith(
        action: RemindersAction.update,
        status: RemindersStatus.failure,
        errorMessage: "${event.reminder.title} 狀態切換失敗",
      ));
    }
  }

  Future<void> _toggleRemindersSort(ToggleRemindersSort event, Emitter<ReminderState> emit) async {
    emit(state.copywith(
      sortType: event.sortType,
      reminders: _sortReminders(state.reminders, event.sortType),
    ));
  }

  List<Reminder> _sortReminders(List<Reminder> reminders, SortType sortType) {
    if (sortType == SortType.createTimeAsc) {
      return reminders.sorted((prev, post) => prev.createTime.compareTo(post.createTime));
    }
    if (sortType == SortType.incompleteFirst) {
      return reminders.sorted((prev, post) {
        if (prev.isDone == post.isDone) {
          return prev.createTime.compareTo(post.createTime);
        }
        return prev.isDone ? 1 : -1;
      });
    }
    return reminders;
  }
}
