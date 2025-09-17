import 'package:mi_campus_app/services/db_service.dart';
import 'package:mi_campus_app/services/secure_credential_storage_service.dart';
import 'package:mi_campus_app/services/student_data_service.dart';
import 'package:mi_campus_app/utils/ics_parser.dart';

class CalendarSyncService {
  final _dbService = DbService();
  final _studentDataService = StudentDataService();
  final _icsParser = IcsParser();

  Future<void> syncCalendar(String codigoAlumno) async {
    final calendarUrl = await SecureCredentialStorageService.getCalendarUrl(
      codigoAlumno,
    );
    if (calendarUrl == null) {
      return;
    }

    final rawIcsContent = await _studentDataService.descargarCalendarioAlumno(
      calendarUrl,
      codigoAlumno,
    );
    if (rawIcsContent == null) {
      return;
    }

    final newEvents = _icsParser.parseRawIcsDataToCalendarEvents(
      rawIcsContent,
      codigoAlumno,
    );

    if (newEvents.isNotEmpty) {
      // if there are duplicates, they will be ignored
      await _dbService.addEvents(newEvents);
    }
  }
}
