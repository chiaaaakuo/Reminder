import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder, BlocListener, BlocSelector, MultiBlocListener, ReadContext;
import 'package:reminder/blocs/reminder_bloc/reminder_bloc.dart';
import 'package:reminder/extensions/widget_extensions.dart';
import 'package:reminder/models/sort_type.dart';
import 'package:reminder/models/reminder.dart';
import 'package:reminder/values/strings.dart';
import 'package:reminder/widgets/gradient_background.dart';
import 'package:reminder/widgets/progress_tracker.dart';
import 'package:reminder/widgets/scrollbar_list_view.dart';
import 'package:reminder/widgets/left_stripe_box.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

class ReminderListPage extends StatefulWidget {
  const ReminderListPage({super.key});

  @override
  State<ReminderListPage> createState() => _ReminderListPageState();
}

class _ReminderListPageState extends State<ReminderListPage> {
  final ListObserverController _listObserverController = ListObserverController(controller: ScrollController());

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ReminderBloc, ReminderState>(
          listenWhen: (ReminderState prev, ReminderState cur) => cur.status == RemindersStatus.failure && cur.errorMessage != null,
          listener: (BuildContext context, ReminderState state) => _showErrorDialog(state.errorMessage!),
        ),
        BlocListener<ReminderBloc, ReminderState>(
          listenWhen: (ReminderState prev, ReminderState cur) =>
              cur.action == RemindersAction.add && cur.status == RemindersStatus.success && cur.scrollToIndex != null,
          listener: (BuildContext context, ReminderState state) => _scrollToIndex(state.reminders, state.scrollToIndex!),
        ),
      ],
      child: Scaffold(
        body: GradientBackground(
          child: SafeArea(
            child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _Header(),
                        const Divider(indent: 24, endIndent: 24),
                        BlocBuilder<ReminderBloc, ReminderState>(
                          builder: (BuildContext context, ReminderState state) {
                            final double progress = state.reminders.isNotEmpty ? state.completedReminders / state.reminders.length : 0;
                            return ProgressTracker(progress: progress);
                          },
                        ),
                        _ReminderList(
                          height: constraint.maxHeight * 0.4,
                          listObserverController: _listObserverController,
                        ),
                        const Divider(indent: 24, endIndent: 24),
                        const _RemindersSorter(),
                        Flexible(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: _ReminderCreator(
                              onSubmit: (String title) => context.read<ReminderBloc>().add(AddReminder(title: title)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  void _scrollToIndex(List<Reminder> reminders, int index) {
    if (index == -1) {
      return;
    }
    _listObserverController.animateTo(index: index, duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text(Strings.errorTitle),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(Strings.ok),
          )
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.appName,
            style: context.theme.textTheme.titleLarge,
          ),
          Text(
            Strings.appNote,
            style: context.theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _EmptyReminderList extends StatelessWidget {
  const _EmptyReminderList();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        Strings.emptyReminders,
        style: context.theme.textTheme.labelMedium,
      ),
    );
  }
}

class _ReminderList extends StatelessWidget {
  const _ReminderList({
    required this.listObserverController,
    this.height,
  });

  final double? height;
  final ListObserverController listObserverController;

  @override
  Widget build(BuildContext context) {
    final BlocSelector<ReminderBloc, ReminderState, List<Reminder>> body = BlocSelector<ReminderBloc, ReminderState, List<Reminder>>(
        selector: (ReminderState state) => state.reminders,
        builder: (BuildContext context, List<Reminder> reminders) {
          if (reminders.isEmpty) {
            return const _EmptyReminderList();
          }
          return ListViewObserver(
              controller: listObserverController,
              child: ScrollbarListView(
                scrollbarIndicatorVisibility: true,
                controller: listObserverController.controller,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: reminders.length,
                itemBuilder: (BuildContext context, int index) => _itemBuilder(context, reminders.elementAt(index)),
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 8),
              ));
        });

    if (height != null) {
      return SizedBox(height: height, child: body);
    }
    return body;
  }

  Widget _itemBuilder(BuildContext context, Reminder reminder) => _ReminderItem(
        reminder: reminder,
        onDelete: () => context.read<ReminderBloc>().add(DeleteReminder(id: reminder.id)),
        onToggleDone: (bool isDone) => context.read<ReminderBloc>().add(
              ToggleReminderStatus(
                reminder: reminder,
                isDone: isDone,
              ),
            ),
      );
}

class _ReminderItem extends StatelessWidget {
  const _ReminderItem({
    required this.reminder,
    required this.onToggleDone,
    required this.onDelete,
  });

  final Reminder reminder;
  final ValueChanged<bool> onToggleDone;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return LeftStripeBox(
      child: CheckboxListTile(
        value: reminder.isDone,
        title: Text(
          reminder.title,
          style: context.theme.textTheme.titleSmall?.copyWith(
            decoration: reminder.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        secondary: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: onDelete,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (bool? value) {
          if (value == null) {
            return;
          }
          onToggleDone(value);
        },
      ),
    );
  }
}

class _RemindersSorter extends StatelessWidget {
  const _RemindersSorter();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ReminderBloc, ReminderState, SortType>(
      selector: (ReminderState state) => state.sortType,
      builder: (BuildContext context, SortType sortType) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(Strings.orderTitle, style: context.theme.textTheme.titleSmall),
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: sortType == SortType.incompleteFirst,
                  onChanged: (bool isActive) => context.read<ReminderBloc>().add(
                        ToggleRemindersSort(sortType: isActive ? SortType.incompleteFirst : SortType.createTimeAsc),
                      ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ReminderCreator extends StatefulWidget {
  const _ReminderCreator({
    required this.onSubmit,
  });

  final Function(String title) onSubmit;

  @override
  State<_ReminderCreator> createState() => _ReminderCreatorState();
}

class _ReminderCreatorState extends State<_ReminderCreator> {
  late TextEditingController _controller;
  String title = "";

  @override
  initState() {
    super.initState();
    _controller = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(Strings.addTitle, style: context.theme.textTheme.titleSmall),
          IntrinsicHeight(
            child: Row(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(isDense: true),
                    onChanged: (String value) => setState(() => title = value),
                    onSubmitted: title.isNotEmpty ? (String value) => _onSubmit() : null,
                  ),
                ),
                AspectRatio(
                  aspectRatio: 1.2,
                  child: IconButton.filled(
                    color: context.theme.colorScheme.primary,
                    style: FilledButton.styleFrom(
                      iconColor: context.theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    icon: const Icon(Icons.add_rounded, size: 32),
                    onPressed: title.isNotEmpty ? _onSubmit : null,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onSubmit() {
    widget.onSubmit(title);
    _controller.clear();
    setState(() => title = "");
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
