import 'package:uuid/uuid.dart';

class Reminder {
  final String id;
  final String title;
  final DateTime dateTime;
  final bool done;

  Reminder._({
    required this.title,
    required this.dateTime,
    String? id,
    this.done = false,
  }) : id = id ?? const Uuid().v4();

  Reminder.temp({
    required this.title,
    this.done = false,
  })  : id = const Uuid().v4(),
        dateTime = DateTime.now();

  Reminder copyWith({
    String? title,
    DateTime? dateTime,
    bool? done,
  }) {
    return Reminder._(
      id: id,
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      done: done ?? this.done,
    );
  }

  Reminder.fromJson(Map<dynamic, dynamic> map)
      : id = map['id'],
        title = map['title'],
        dateTime = DateTime.parse(map['dateTime']),
        done = map['done'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'dateTime': dateTime.toString(),
        'done': done,
      };
}
