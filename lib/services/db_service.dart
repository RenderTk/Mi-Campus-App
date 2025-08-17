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
        $_eventsTableCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
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
    };
  }

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<void> deleteFirstFiveEvents() async {
    final dbPath = join(await getDatabasesPath(), 'database.db');
    final db = await openDatabase(dbPath);

    // Delete the first 5 records ordered by ID (oldest first)
    await db.delete(
      _eventsTableName,
      where:
          '$_eventsTableId IN (SELECT $_eventsTableId FROM $_eventsTableName ORDER BY $_eventsTableId ASC LIMIT 5)',
    );

    await db.close();
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'database.db');
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: _createTables,
    );
    return database;
  }

  Future<int> countExistingEvents(List<CalendarEvent> events) async {
    final db = await database;

    if (events.isEmpty) return 0;

    final uids = events.map((event) => event.uid).toSet().toList();

    final placeholders = List.filled(uids.length, '?').join(',');

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $_eventsTableName WHERE $_eventsTableUid IN ($placeholders)',
      uids,
    );

    return result.first['count'] as int;
  }

  Future<int> countNewEvents(List<CalendarEvent> events) async {
    final db = await database;

    if (events.isEmpty) return 0;

    final uids = events.map((event) => event.uid).toSet().toList();
    final placeholders = List.filled(uids.length, '?').join(',');

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $_eventsTableName WHERE $_eventsTableUid IN ($placeholders)',
      uids,
    );

    final existingCount = result.first['count'] as int;

    // Return how many will be newly inserted
    return uids.length - existingCount;
  }

  Future<void> clearDb() async {
    //delete all events
    final db = await database;
    await db.delete(_eventsTableName);
  }

  Future<List<CalendarEvent>> getAllEvents() async {
    final db = await database;

    final data = await db.query(_eventsTableName);
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
