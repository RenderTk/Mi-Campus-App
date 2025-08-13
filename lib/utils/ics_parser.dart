import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:usap_mobile/models/calendar_event.dart';

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

  /// Parsea un archivo ICS desde su contenido bruto y devuelve un Map
  List<CalendarEvent> parseRawIcsDataToCalendarEvents(String rawContent) {
    _register();
    try {
      final ical = ICalendar.fromString(rawContent);
      final icsData = ical.toJson();
      List<dynamic> data = icsData["data"];

      return CalendarEvent.mapEventsFromIcsData(data);
    } catch (e) {
      return [];
    }
  }
}
