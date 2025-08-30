import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/models/calendar_event.dart';
import 'package:usap_mobile/providers/calendar_sync_service.dart';
import 'package:usap_mobile/providers/user_provider.dart';
import 'package:usap_mobile/services/db_service.dart';

class CalendarEventsNotfier extends AsyncNotifier<List<CalendarEvent>> {
  final _dbService = DbService();
  final _calendarSyncService = CalendarSyncService();

  @override
  Future<List<CalendarEvent>> build() async {
    final user = await ref.watch(userProvider.future);
    if (user == null) {
      throw Exception('User not found');
    }

    // Sync the calendar if there are new events and the user has already imported a calendar URL
    await _calendarSyncService.syncCalendar(user.id);

    final events = await _dbService.getAllEvents(user.id);
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

    state = await AsyncValue.guard(() async {
      final user = await ref.read(userProvider.future);

      if (user == null) {
        throw Exception('User not found');
      }

      await _dbService.clearDb(user.id);
      return [];
    });
  }
}

final calendarEventsProvider =
    AsyncNotifierProvider<CalendarEventsNotfier, List<CalendarEvent>>(
      () => CalendarEventsNotfier(),
    );
