import 'package:uuid/uuid.dart';

class Reminder {
  final String id;
  final String title;
  final DateTime? dateTime;
  final bool done;

  Reminder({
    required this.title,
    String? id,
    this.dateTime,
    this.done = false,
  }) : id = id ?? const Uuid().v4();

  Reminder copyWith({
    String? title,
    DateTime? dateTime,
    bool? done,
  }) {
    return Reminder(
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      done: done ?? this.done,
    );
  }

  Reminder.fromJson(Map<dynamic, dynamic> map)
      : id = map['id'],
        title = map['title'],
        dateTime = map['dateTime'],
        done = map['done'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'dateTime': dateTime,
        'done': done,
      };
}
