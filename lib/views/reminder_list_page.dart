import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder, BlocSelector, ReadContext;
import 'package:reminder/blocs/reminder_bloc/reminder_bloc.dart';
import 'package:reminder/extensions/widget_extensions.dart';
import 'package:reminder/models/sort_type.dart';
import 'package:reminder/models/reminder.dart';
import 'package:reminder/styles/theme_extensions/list_tile_left_strip_theme.dart';
import 'package:reminder/styles/themes.dart';
import 'package:reminder/values/strings.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: context.theme.appGradientTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              const Header(),
              const Divider(indent: 24, endIndent: 24),
              BlocBuilder<ReminderBloc, ReminderState>(
                builder: (context, state) {
                  final double progress = state.reminders.isNotEmpty ? state.completedReminders / state.reminders.length : 0;
                  return ProgressTracker(progress: progress);
                },
              ),
              Flexible(
                flex: 4,
                child: BlocSelector<ReminderBloc, ReminderState, List<Reminder>>(
                  selector: (state) => state.reminders,
                  builder: (context, reminders) {
                    if (reminders.isEmpty) {
                      return Container();
                    }
                    return ReminderList(reminders: reminders);
                  },
                ),
              ),
              const Divider(indent: 24, endIndent: 24),
              BlocSelector<ReminderBloc, ReminderState, SortType>(
                selector: (state) => state.sortType,
                builder: (context, sortType) {
                  return RemindersSorter(
                    isActive: sortType == SortType.activePriority,
                    onChanged: (SortType sortType) => context.read<ReminderBloc>().add(ToggleRemindersSort(sortType: sortType)),
                  );
                },
              ),
              const Spacer(),
              ReminderCreator(
                onAddReminder: (String title) => context.read<ReminderBloc>().add(AddReminder(title: title)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

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

class ProgressTracker extends StatelessWidget {
  const ProgressTracker({
    Key? key,
    this.progress = 0,
    this.progressHeight = 14,
  }) : super(key: key);

  final double progress;
  final double progressHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
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

class ReminderList extends StatefulWidget {
  const ReminderList({
    Key? key,
    required this.reminders,
  }) : super(key: key);

  final List<Reminder> reminders;

  @override
  State<ReminderList> createState() => _ReminderListState();
}

class _ReminderListState extends State<ReminderList> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      thickness: 4,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: widget.reminders.length,
        itemBuilder: (BuildContext context, int index) {
          final reminder = widget.reminders.elementAt(index);
          return ReminderItem(
            reminder: reminder,
            onDelete: (String id) => context.read<ReminderBloc>().add(DeleteReminder(id: id)),
            onToggleDone: (bool isDone) => context.read<ReminderBloc>().add(
                  ToggleReminderStatus(
                    reminder: reminder,
                    isDone: isDone,
                  ),
                ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 8),
      ),
    );
  }
}

class ReminderItem extends StatelessWidget {
  const ReminderItem({
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
            value: reminder.done,
            title: Text(
              reminder.title,
              style: context.theme.textTheme.titleSmall?.copyWith(
                decoration: reminder.done ? TextDecoration.lineThrough : null,
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

class RemindersSorter extends StatelessWidget {
  const RemindersSorter({
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
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(Strings.orderTitle, style: context.theme.textTheme.titleSmall),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: isActive,
              onChanged: (bool isActive) => onChanged(isActive ? SortType.activePriority : SortType.asc),
            ),
          ),
        ],
      ),
    );
  }
}

class ReminderCreator extends StatefulWidget {
  const ReminderCreator({Key? key, required this.onAddReminder}) : super(key: key);
  final Function(String title) onAddReminder;

  @override
  State<ReminderCreator> createState() => _ReminderCreatorState();
}

class _ReminderCreatorState extends State<ReminderCreator> {
  String title = "";
  late TextEditingController _controller;

  @override
  initState() {
    super.initState();
    _controller = TextEditingController(text: title);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Strings.addTitle, style: context.theme.textTheme.titleMedium),
          Row(
            spacing: 4,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: (String value) => setState(() => title = value),
                ),
              ),
              IconButton.filled(
                color: context.theme.primaryColor,
                style: FilledButton.styleFrom(
                  iconColor: context.theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                onPressed: title.isNotEmpty ? () => widget.onAddReminder(title) : null,
                icon: const Icon(Icons.add),
              )
            ],
          ),
        ],
      ),
    );
  }

  void onPressedAddButton() {
    widget.onAddReminder(title);
    _controller.clear();
    setState(() => title = "");
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
