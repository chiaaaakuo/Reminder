import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:reminder/core/repository_service.dart';
import 'package:reminder/models/reminder.dart';

part 'reminder_event.dart';

part 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final RepositoryService repository;

  ReminderBloc({
    required this.repository,
  }) : super(ReminderState()) {
    on<LoadReminders>((event, emit) async => await _loadReminders(emit));
    on<CreateReminder>((event, emit) async => await _createReminder(event, emit));
    on<DeleteReminder>((event, emit) async => await _deleteReminder(event, emit));
  }

  Future<void> _loadReminders(Emitter<ReminderState> emit) async {}

  Future<void> _createReminder(CreateReminder event, Emitter<ReminderState> emit) async {}

  Future<void> _deleteReminder(DeleteReminder event, Emitter<ReminderState> emit) async {}
}
