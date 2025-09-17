import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:mi_campus_app/models/calendar_event.dart';

class IcsParser {
  static final IcsParser _instance = IcsParser._internal();
  static bool _isRegistered = false;

  factory IcsParser() => _instance;

  IcsParser._internal();

  void _register() {
    // Only register if not already registered
    if (_isRegistered) return;

    // Registrar campos no soportados por defecto
    ICalendar.registerField(field: 'ID');
    ICalendar.registerField(field: 'CLASS_TYPE');
    ICalendar.registerField(
      field: 'CREATED_AT',
      function: (value, params, event, lastEvent) {
        // Intentar convertir a DateTime
        lastEvent['created_at'] = DateTime.tryParse(value);
        return lastEvent;
      },
    );

    // Mark as registered
    _isRegistered = true;
  }

  static DateTime? _tryParseDt(Map<String, dynamic> data) {
    String dt = data["dt"] as String;
    final datetime = DateTime.tryParse(dt);
    return datetime;
  }

  static DateTime _parseDt(Map<String, dynamic> data) {
    String dt = data["dt"] as String;
    final datetime = DateTime.parse(dt);
    return datetime;
  }

  List<CalendarEvent> _mapEventsFromIcsData(dynamic data, String codigoAlumno) {
    List<CalendarEvent> events = [];
    for (var item in data) {
      final calendarEvent = CalendarEvent(
        uid: item['uid'] as String,
        summary: item['summary'] as String,
        description: item['description'] as String?,
        dtstamp: _tryParseDt(item['dtstamp']),
        dtstart: _parseDt(item['dtstart']),
        dtend: _parseDt(item['dtend']),
        categories: item['categories'][0] as String?,
        classType: item['class_type'] as String?,
        lastModified: _tryParseDt(item['lastModified']),
        codigoAlumno: codigoAlumno,
      );
      events.add(calendarEvent);
    }
    return events;
  }

  /// Parsea un archivo ICS desde su contenido bruto y devuelve un Map
  List<CalendarEvent> parseRawIcsDataToCalendarEvents(
    String rawContent,
    String codigoAlumno,
  ) {
    _register();
    try {
      final ical = ICalendar.fromString(rawContent);
      final icsData = ical.toJson();
      List<dynamic> data = icsData["data"];

      return _mapEventsFromIcsData(data, codigoAlumno);
    } catch (e) {
      return [];
    }
  }
}
