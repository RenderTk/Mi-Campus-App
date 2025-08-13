import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/providers/calendar_events_provider.dart';

class CalendarWidget extends ConsumerWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Calendario", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () =>
                ref.read(calendarEventsProvider.notifier).deleteAllEvents(),
            child: const Text("Borrar eventos en el calendario"),
          ),
        ],
      ),
    );
  }
}
