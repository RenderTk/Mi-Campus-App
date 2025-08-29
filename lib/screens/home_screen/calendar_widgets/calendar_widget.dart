import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:usap_mobile/exceptions/token_refresh_failed_exception.dart';
import 'package:usap_mobile/models/calendar_event.dart';
import 'package:usap_mobile/providers/calendar_events_provider.dart';
import 'package:usap_mobile/providers/calendar_navigation_provider.dart';
import 'package:usap_mobile/providers/user_provider.dart';
import 'package:usap_mobile/screens/home_screen/calendar_widgets/event_card.dart';
import 'package:usap_mobile/widgets/error_state_widget.dart';
import 'package:usap_mobile/widgets/loading_state_widget.dart';
import 'package:usap_mobile/widgets/session_expired_widget.dart';

class CalendarWidget extends ConsumerStatefulWidget {
  const CalendarWidget({super.key});

  @override
  ConsumerState<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends ConsumerState<CalendarWidget> {
  DateTime _focusedDay = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime threeMonthsBeforeOldest(DateTime oldestEvent) {
    final dt = oldestEvent;
    return DateTime(
      dt.year,
      dt.month - 3,
      dt.day,
      dt.hour,
      dt.minute,
      dt.second,
    );
  }

  DateTime threeMonthsAfterNewest(DateTime newestEvent) {
    final dt = newestEvent;
    return DateTime(
      dt.year,
      dt.month + 3,
      dt.day,
      dt.hour,
      dt.minute,
      dt.second,
    );
  }

  @override
  Widget build(BuildContext context) {
    final calendarEvents = ref.watch(calendarEventsProvider);

    Widget buildEmptyState() {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon container with subtle background
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                ),
                child: Icon(
                  Icons.event_available_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(height: 24),

              // Main title
              Text(
                "Tu calendario está vacío",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Subtitle/instruction
              Text(
                "Agrega la URL de Moodle para sincronizar\ntus eventos y actividades académicas.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Optional action button
              FilledButton.tonal(
                onPressed: () {
                  ref
                      .read(calendarNavigationProvider.notifier)
                      .showMoodleUrlInput();
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.settings, size: 18),
                    SizedBox(width: 8),
                    Text("Configurar Moodle"),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget buildSuccessState(List<CalendarEvent> calendarEvents) {
      final oldestEvent = CalendarEvent.getOldestEvent(calendarEvents);
      final newestEvent = CalendarEvent.getNewestEvent(calendarEvents);

      // Get events for selected day
      List<CalendarEvent> selectedDayEvents = _selectedDay != null
          ? calendarEvents
                .where((event) => isSameDay(event.dtend, _selectedDay!))
                .toList()
          : [];

      return calendarEvents.isNotEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TableCalendar<CalendarEvent>(
                  locale: "es_ES",
                  firstDay: threeMonthsBeforeOldest(oldestEvent!.dtend),
                  lastDay: threeMonthsAfterNewest(newestEvent!.dtend),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  eventLoader: (day) {
                    return calendarEvents
                        .where((event) => isSameDay(event.dtend, day))
                        .toList();
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarFormat: _calendarFormat,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Mes',
                    CalendarFormat.twoWeeks: '2 Semanas',
                    CalendarFormat.week: 'Semana',
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },

                  // Add calendar style to customize event markers
                  calendarStyle: CalendarStyle(
                    // Customize the event markers (dots)
                    markerDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    // You can also customize other marker properties
                    markerSize: 6.0, // Size of the markers
                    markerMargin: const EdgeInsets.symmetric(horizontal: 1),
                  ),
                ),

                // Show events for selected day
                if (selectedDayEvents.isNotEmpty) ...[
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: selectedDayEvents.length,
                      itemBuilder: (context, index) {
                        final event = selectedDayEvents[index];
                        return EventCard(event: event);
                      },
                    ),
                  ),
                ],
              ],
            )
          : buildEmptyState();
    }

    return calendarEvents.when(
      data: (calendarEvents) => buildSuccessState(calendarEvents),
      error: (error, stackTrace) {
        // si se intento refrescar el token y no se pudo, se cierra la sesion
        // y se redirige al login
        if (error is TokenRefreshFailedException) {
          return SessionExpiredWidget(
            onLogin: () async {
              await ref.read(userProvider.notifier).logOut();
            },
          );
        }

        return ErrorStateWidget(
          errorMessage:
              "Ocurrio un error al cargar los eventos de su calendario. Intente mas tarde.",
          onRetry: () async => ref.invalidate(calendarEventsProvider),
          showExitButton: true,
        );
      },
      loading: () => const LoadingStateWidget(),
    );
  }
}
