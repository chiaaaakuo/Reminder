import 'package:floor/floor.dart';

@entity
class Reminder {
  @primaryKey
  final String id;
  final String title;
  final DateTime dateTime;
  final bool done;

  Reminder(this.title, this.dateTime, this.id, this.done);
}