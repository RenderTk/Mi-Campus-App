import 'package:copy_with_extension/copy_with_extension.dart';

part 'calendar_event.g.dart';

@CopyWith()
class CalendarEvent {
  final int? id;

  final String uid;

  final String summary;

  final String? description;

  final DateTime? dtstamp;

  final DateTime dtstart;

  final DateTime dtend;

  final String? categories;

  final String? classType;

  final DateTime? lastModified;

  final DateTime? createdAt;

  final String codigoAlumno;

  CalendarEvent({
    this.id,
    required this.uid,
    required this.summary,
    required this.description,
    required this.dtstamp,
    required this.dtstart,
    required this.dtend,
    required this.categories,
    required this.classType,
    required this.lastModified,
    this.createdAt,
    required this.codigoAlumno,
  });

  static CalendarEvent? getNewestEvent(List<CalendarEvent> events) {
    if (events.isEmpty) return null;
    return events.reduce((a, b) => a.dtstamp!.isAfter(b.dtend) ? a : b);
  }

  static CalendarEvent? getOldestEvent(List<CalendarEvent> events) {
    if (events.isEmpty) return null;
    return events.reduce((a, b) => a.dtstamp!.isBefore(b.dtend) ? a : b);
  }
}
