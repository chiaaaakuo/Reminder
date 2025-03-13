import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocListener;
import 'package:reminder/blocs/reminder_bloc/reminder_bloc.dart';
import 'package:scrollview_observer/scrollview_observer.dart' show ListObserverController, ListViewObserver;

class ScrollToNewReminderListener extends StatelessWidget {
  ScrollToNewReminderListener({
    super.key,
    required this.child,
  });

  final Widget child;
  final ListObserverController listObserverController = ListObserverController(controller: ScrollController());


  @override
  Widget build(BuildContext context) {
    return BlocListener<ReminderBloc, ReminderState>(
      listenWhen: (previous, current) => previous.reminders.length < current.reminders.length,
      listener: (context, state) {

      },
      child: ListViewObserver(
        controller: listObserverController,
        child: child,
      ),
    );
  }
}
