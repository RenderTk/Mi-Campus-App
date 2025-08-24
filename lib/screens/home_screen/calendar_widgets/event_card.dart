import 'package:flutter/material.dart';
import 'package:usap_mobile/models/calendar_event.dart';
import 'package:usap_mobile/screens/home_screen/calendar_widgets/event_detail_bottom_sheet.dart';
import 'package:usap_mobile/widgets/labeled_badge.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event});

  final CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    String formatTime(DateTime dateTime) {
      // Convert to local time if it's in UTC, then add 1 hour
      DateTime localTime = dateTime.isUtc ? dateTime.toLocal() : dateTime;

      int hour24 = localTime.hour;
      int minute = localTime.minute;

      // Determine AM/PM
      String period = hour24 < 12 ? 'AM' : 'PM';

      // Convert to 12-hour format
      int hour12 = hour24;
      if (hour24 == 0) {
        hour12 = 12; // Midnight becomes 12 AM
      } else if (hour24 > 12) {
        hour12 = hour24 - 12; // 13-23 becomes 1-11 PM
      }
      // Hours 1-11 stay the same

      // Format minute with leading zero if needed
      String formattedMinute = minute.toString().padLeft(2, '0');

      return '$hour12:$formattedMinute $period';
    }

    IconData getEventIcon() {
      final summary = event.summary.toLowerCase();

      if (summary.contains('videoconferencia')) {
        return Icons.videocam_rounded;
      } else if (summary.contains('tarea')) {
        return Icons.assignment_rounded;
      } else if (summary.contains('ensayo') || summary.contains('informe')) {
        return Icons.description_rounded;
      } else if (summary.contains('examen') ||
          summary.contains('test') ||
          summary.contains('prueba')) {
        return Icons.quiz_rounded;
      } else {
        return Icons.event_rounded;
      }
    }

    void showEventDetails() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) =>
              EventDetailBottomSheet(event: event),
        ),
      );
    }

    return InkWell(
      onTap: () => showEventDetails(),
      child: Card(
        color: Theme.of(
          context,
        ).colorScheme.primaryContainer.withValues(alpha: 0.1),
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon container
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.2),
                ),
                child: Icon(
                  getEventIcon(),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),

              // Content area
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category
                    Text(
                      event.categories
                              ?.replaceAll(RegExp(r'Seccion.*'), '')
                              .trim() ??
                          "Sin categoría",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Event title/summary
                    Text(
                      event.summary,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Date section
              LabeledBadge(
                msg: formatTime(event.dtend),
                foregroundColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
