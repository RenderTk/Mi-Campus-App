import 'package:logger/web.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:usap_mobile/models/calendar_event.dart';

class DbService {
  static Database? _db;
  static final DbService _instance = DbService._internal();
  factory DbService() => _instance;
  DbService._internal();

  final String _eventsTableName = 'events';
  final String _eventsTableId = 'id';
  final String _eventsTableUid = 'uid';
  final String _eventsTableSummary = 'summary';
  final String _eventsTableDescription = 'description';
  final String _eventsTableDtstamp = 'dtstamp';
  final String _eventsTableDtstart = 'dtstart';
  final String _eventsTableDtend = 'dtend';
  final String _eventsTableCategories = 'categories';
  final String _eventsTableClassType = 'class_type';
  final String _eventsTableLastModified = 'last_modified';
  final String _eventsTableCreatedAt = 'created_at';
  final String _eventsTableCodigoAlumno = 'codigo_alumno';

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_eventsTableName (
        $_eventsTableId INTEGER PRIMARY KEY AUTOINCREMENT,
        $_eventsTableUid TEXT UNIQUE NOT NULL,
        $_eventsTableSummary TEXT NOT NULL,
        $_eventsTableDescription TEXT,
        $_eventsTableDtstamp TEXT,
        $_eventsTableDtstart TEXT NOT NULL,
        $_eventsTableDtend TEXT NOT NULL,
        $_eventsTableCategories TEXT,
        $_eventsTableClassType TEXT,
        $_eventsTableLastModified TEXT,
        $_eventsTableCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
        $_eventsTableCodigoAlumno TEXT NOT NULL
      )
    ''');
  }

  Map<String, dynamic> _eventToMap(CalendarEvent event) {
    return {
      _eventsTableUid: event.uid,
      _eventsTableSummary: event.summary,
      _eventsTableDescription: event.description,
      _eventsTableDtstamp: event.dtstamp?.toIso8601String(),
      _eventsTableDtstart: event.dtstart.toIso8601String(),
      _eventsTableDtend: event.dtend.toIso8601String(),
      _eventsTableCategories: event.categories,
      _eventsTableClassType: event.classType,
      _eventsTableLastModified: event.lastModified?.toIso8601String(),
      _eventsTableCodigoAlumno: event.codigoAlumno,
    };
  }

  Future<Database> _getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'database.db');
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: _createTables,
    );
    return database;
  }

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _getDatabase();
    return _db!;
  }

  Future<void> clearDb(String codigoAlumno) async {
    //delete all events
    final db = await database;
    await db.delete(
      _eventsTableName,
      where: '$_eventsTableCodigoAlumno = ?',
      whereArgs: [codigoAlumno],
    );
  }

  Future<List<CalendarEvent>> getAllEvents(String codigoAlumno) async {
    final db = await database;

    final data = await db.query(
      _eventsTableName,
      where: '$_eventsTableCodigoAlumno = ?',
      whereArgs: [codigoAlumno],
    );
    List<CalendarEvent> events = [];
    for (final item in data) {
      final value = item[_eventsTableDtstamp];
      Logger().i(value);
      final event = CalendarEvent(
        id: item[_eventsTableId] as int,
        uid: item[_eventsTableUid] as String,
        summary: item[_eventsTableSummary] as String,
        description: item[_eventsTableDescription] as String?,
        dtstamp: DateTime.tryParse(item[_eventsTableDtstamp] as String? ?? ''),
        dtstart: DateTime.parse(item[_eventsTableDtstart] as String),
        dtend: DateTime.parse(item[_eventsTableDtend] as String),
        categories: item[_eventsTableCategories] as String?,
        classType: item[_eventsTableClassType] as String?,
        lastModified: DateTime.tryParse(
          item[_eventsTableLastModified] as String? ?? '',
        ),
        createdAt: DateTime.tryParse(
          item[_eventsTableCreatedAt] as String? ?? '',
        ),
        codigoAlumno: item[_eventsTableCodigoAlumno] as String,
      );

      events.add(event);
    }
    return events;
  }

  Future<void> addEvent(CalendarEvent event) async {
    final db = await database;
    await db.insert(
      _eventsTableName,
      _eventToMap(event),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> addEvents(List<CalendarEvent> events) async {
    final db = await database;
    // Convert events to list of maps for batch insert
    final List<Map<String, dynamic>> eventMaps = events
        .map((event) => _eventToMap(event))
        .toList();
    // Use batch for better performance
    final batch = db.batch();
    for (final eventMap in eventMaps) {
      batch.insert(
        _eventsTableName,
        eventMap,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    await batch.commit(noResult: true);
  }
}
