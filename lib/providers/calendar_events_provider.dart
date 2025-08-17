import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/models/calendar_event.dart';
import 'package:usap_mobile/services/db_service.dart';

class CalendarEventsNotfier extends AsyncNotifier<List<CalendarEvent>> {
  final _dbService = DbService();

  @override
  Future<List<CalendarEvent>> build() async {
    final events = await _dbService.getAllEvents();
    return events;
  }

  List<CalendarEvent> _makeDeepCopyOfState() {
    return state.value!.map((event) => event.copyWith()).toList();
  }

  List<CalendarEvent> removeDuplicateEvents(List<CalendarEvent> newEvents) {
    final events = _makeDeepCopyOfState();
    final existingUids = events.map((e) => e.uid).toSet();
    return newEvents
        .where((event) => !existingUids.contains(event.uid))
        .toList();
  }

  int countNewEventToBeAdded(List<CalendarEvent> newEvents) {
    final currentEvents = _makeDeepCopyOfState();
    final existingUids = currentEvents.map((e) => e.uid).toSet();

    return newEvents.where((event) => !existingUids.contains(event.uid)).length;
  }

  Future<void> addEvents(List<CalendarEvent> newEvents) async {
    // Early return if no events to add
    if (newEvents.isEmpty) {
      return;
    }

    // Get current state
    final currentEvents = _makeDeepCopyOfState();

    // Create a Set of existing UIDs for O(1) lookup
    final existingUids = currentEvents.map((e) => e.uid).toSet();

    // Filter out duplicates
    final notDuplicatedEvents = newEvents
        .where((event) => !existingUids.contains(event.uid))
        .toList();

    // Early return if all events are duplicates
    if (notDuplicatedEvents.isEmpty) {
      return;
    }

    // Update state
    state = await AsyncValue.guard(() async {
      // Add events to sqlite database first
      await _dbService.addEvents(notDuplicatedEvents);

      // Return updated list
      return [...currentEvents, ...notDuplicatedEvents];
    });
  }

  Future<void> deleteAllEvents() async {
    state = const AsyncValue.loading();
    await _dbService.clearDb();
    state = const AsyncValue.data([]);
  }
}

final calendarEventsProvider =
    AsyncNotifierProvider<CalendarEventsNotfier, List<CalendarEvent>>(
      () => CalendarEventsNotfier(),
    );
