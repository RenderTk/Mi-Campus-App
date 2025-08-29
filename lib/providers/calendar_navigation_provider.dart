import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/providers/calendar_events_provider.dart';
import 'package:usap_mobile/providers/user_provider.dart';
import 'package:usap_mobile/services/db_service.dart';

class CalendarNavigationProvider extends AsyncNotifier<bool> {
  final dbService = DbService();

  @override
  Future<bool> build() async {
    //to reset when user logs out
    ref.watch(userProvider);

    final events = await ref.read(calendarEventsProvider.future);

    //if there is no events saved on lcoal db
    if (events.isEmpty) {
      return false;
    }

    //if there are events saved on local db
    return true;
  }

  void showOpposite() {
    final current = state.value ?? false;
    state = AsyncValue.data(!current);
  }

  void showCalendar() => state = const AsyncValue.data(true);
  void showMoodleUrlInput() => state = const AsyncValue.data(false);
}

final calendarNavigationProvider =
    AsyncNotifierProvider<CalendarNavigationProvider, bool>(
      () => CalendarNavigationProvider(),
    );
