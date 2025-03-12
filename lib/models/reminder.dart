import 'package:uuid/uuid.dart';

class Reminder {
  final String id;
  final String title;
  final DateTime createTime;
  final bool isDone;

  Reminder._({
    required this.title,
    required this.createTime,
    String? id,
    this.isDone = false,
  }) : id = id ?? const Uuid().v4();

  Reminder.temp({
    required this.title,
    this.isDone = false,
  })  : id = const Uuid().v4(),
        createTime = DateTime.now();

  Reminder copyWith({
    String? title,
    DateTime? createTime,
    bool? isDone,
  }) {
    return Reminder._(
      id: id,
      title: title ?? this.title,
      createTime: createTime ?? this.createTime,
      isDone: isDone ?? this.isDone,
    );
  }

  Reminder.fromJson(Map<dynamic, dynamic> map)
      : id = map['id'],
        title = map['title'],
        createTime = DateTime.parse(map['createTime']),
        isDone = map['isDone'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createTime': createTime.toString(),
        'isDone': isDone,
      };
}
