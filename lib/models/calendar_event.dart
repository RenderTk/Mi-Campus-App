import 'package:copy_with_extension/copy_with_extension.dart';

part 'calendar_event.g.dart';

@CopyWith()
class CalendarEvent {
  final int? id;

  final String uid;

  final String summary;

  final String? description;

  final DateTime? dtstamp;

  final DateTime? dtstart;

  final DateTime? dtend;

  final String? categories;

  final String? classType;

  final DateTime? lastModified;

  final DateTime? createdAt;

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
  });

  static DateTime? parseDt(Map<String, dynamic> data) {
    String dt = data["dt"] as String;
    final datetime = DateTime.tryParse(dt);
    return datetime;
  }

  static List<CalendarEvent> mapEventsFromIcsData(dynamic data) {
    List<CalendarEvent> events = [];
    for (var item in data) {
      final calendarEvent = CalendarEvent(
        uid: item['uid'] as String,
        summary: item['summary'] as String,
        description: item['description'] as String?,
        dtstamp: parseDt(item['dtstamp']),
        dtstart: parseDt(item['dtstart']),
        dtend: parseDt(item['dtend']),
        categories: item['categories'][0] as String?,
        classType: item['class_type'] as String?,
        lastModified: parseDt(item['lastModified']),
      );
      events.add(calendarEvent);
    }
    return events;
  }
}
