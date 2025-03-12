import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder, BlocListener, BlocSelector, MultiBlocListener, ReadContext;
import 'package:reminder/blocs/reminder_bloc/reminder_bloc.dart';
import 'package:reminder/extensions/widget_extensions.dart';
import 'package:reminder/models/sort_type.dart';
import 'package:reminder/models/reminder.dart';
import 'package:reminder/styles/theme_extensions/list_tile_left_strip_theme.dart';
import 'package:reminder/styles/themes.dart';
import 'package:reminder/values/strings.dart';
import 'package:reminder/widgets/gradient_background.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  final ListObserverController _listObserverController = ListObserverController(controller: ScrollController());

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ReminderBloc, ReminderState>(
          listenWhen: (prev, cur) => cur.status == RemindersStatus.failure && cur.errorMessage != null,
          listener: (context, state) => _showErrorDialog(state.errorMessage!),
        ),
        BlocListener<ReminderBloc, ReminderState>(
          listenWhen: (prev, cur) =>
              cur.action == RemindersAction.add && cur.status == RemindersStatus.success && cur.scrollToIndex != null,
          listener: (context, state) => _scrollToIndex(state.reminders, state.scrollToIndex!),
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GradientBackground(
          gradient: context.theme.appGradientTheme.backgroundGradient,
          child: SafeArea(
            child: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const _Header(),
                const Divider(indent: 24, endIndent: 24),
                BlocBuilder<ReminderBloc, ReminderState>(
                  builder: (context, state) {
                    final double progress = state.reminders.isNotEmpty ? state.completedReminders / state.reminders.length : 0;
                    return _ProgressTracker(progress: progress);
                  },
                ),
                Flexible(
                  flex: 4,
                  child: BlocSelector<ReminderBloc, ReminderState, List<Reminder>>(
                    selector: (state) => state.reminders,
                    builder: (context, reminders) {
                      if (reminders.isEmpty) {
                        return const _EmptyReminderList();
                      }
                      return ListViewObserver(
                        controller: _listObserverController,
                        child: _ReminderList(
                          reminders: reminders,
                          controller: _listObserverController.controller!,
                        ),
                      );
                    },
                  ),
                ),
                const Divider(indent: 24, endIndent: 24),
                BlocSelector<ReminderBloc, ReminderState, SortType>(
                  selector: (state) => state.sortType,
                  builder: (context, sortType) {
                    return _RemindersSorter(
                      isActive: sortType == SortType.incompleteFirst,
                      onChanged: (SortType sortType) => context.read<ReminderBloc>().add(ToggleRemindersSort(sortType: sortType)),
                    );
                  },
                ),
                const Spacer(),
                _ReminderCreator(
                  onSubmit: (String title) => context.read<ReminderBloc>().add(AddReminder(title: title)),
                ),
              ],
            ),
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
      builder: (context) => AlertDialog.adaptive(title: Text(errorMessage), actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(Strings.ok),
        )
      ]),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
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

class _ProgressTracker extends StatelessWidget {
  const _ProgressTracker({
    Key? key,
    this.progress = 0,
    this.progressHeight = 14,
  }) : super(key: key);

  final double progress;
  final double progressHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        spacing: 10,
        children: [
          Text("${(progress * 100).round()}%", style: context.theme.textTheme.titleMedium),
          Expanded(
            child: LinearProgressIndicator(
              value: progress,
              minHeight: progressHeight,
              borderRadius: BorderRadius.circular(progressHeight / 2),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyReminderList extends StatelessWidget {
  const _EmptyReminderList({Key? key}) : super(key: key);

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
    Key? key,
    required this.reminders,
    required this.controller,
  }) : super(key: key);

  final List<Reminder> reminders;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      controller: controller,
      thickness: 10,
      radius: const Radius.circular(10),
      thumbVisibility: true,
      thumbColor: context.theme.colorScheme.tertiary,
      child: ListView.separated(
        controller: controller,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: reminders.length,
        itemBuilder: _itemBuilder,
        separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 8),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final reminder = reminders.elementAt(index);
    return _ReminderItem(
      reminder: reminder,
      onDelete: (String id) => context.read<ReminderBloc>().add(DeleteReminder(id: id)),
      onToggleDone: (bool isDone) => context.read<ReminderBloc>().add(
            ToggleReminderStatus(
              reminder: reminder,
              isDone: isDone,
            ),
          ),
    );
  }
}

class _ReminderItem extends StatelessWidget {
  const _ReminderItem({
    Key? key,
    required this.reminder,
    required this.onToggleDone,
    required this.onDelete,
  }) : super(key: key);

  final Reminder reminder;
  final ValueChanged<bool> onToggleDone;
  final Function(String id) onDelete;

  @override
  Widget build(BuildContext context) {
    final ListTileLeftStripeTheme leftStripTheme = context.theme.listTileLeftStripTheme;
    return ClipRRect(
      borderRadius: leftStripTheme.borderRadius,
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              children: [
                Container(width: leftStripTheme.stripWidth, color: leftStripTheme.stripColor),
                Expanded(child: Container(color: leftStripTheme.background)),
              ],
            ),
          ),
          CheckboxListTile(
            value: reminder.isDone,
            title: Text(
              reminder.title,
              style: context.theme.textTheme.titleSmall?.copyWith(
                decoration: reminder.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
            secondary: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => onDelete(reminder.id),
            ),
            contentPadding: leftStripTheme.padding,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (bool? value) {
              if (value == null) {
                return;
              }
              onToggleDone(value);
            },
          ),
        ],
      ),
    );
  }
}

class _RemindersSorter extends StatelessWidget {
  const _RemindersSorter({
    Key? key,
    this.isActive = false,
    required this.onChanged,
  }) : super(key: key);

  final bool isActive;
  final ValueChanged<SortType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(Strings.orderTitle, style: context.theme.textTheme.titleSmall),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: isActive,
              onChanged: (bool isActive) => onChanged(isActive ? SortType.incompleteFirst : SortType.createTimeAsc),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderCreator extends StatefulWidget {
  const _ReminderCreator({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  final Function(String title) onSubmit;

  @override
  State<_ReminderCreator> createState() => _ReminderCreatorState();
}

class _ReminderCreatorState extends State<_ReminderCreator> {
  late TextEditingController _controller;

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
                    onSubmitted: (String value) => _onSubmit(),
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
                    onPressed: _onSubmit,
                    icon: const Icon(Icons.add_rounded, size: 32),
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
    widget.onSubmit(_controller.text);
    _controller.clear();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
