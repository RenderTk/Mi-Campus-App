import 'package:flutter/material.dart';
import 'package:mi_campus_app/models/calendar_event.dart';

class EventDetailBottomSheet extends StatelessWidget {
  const EventDetailBottomSheet({super.key, required this.event});

  final CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    String formatTime(DateTime dateTime) {
      DateTime localTime = dateTime.isUtc ? dateTime.toLocal() : dateTime;

      int hour24 = localTime.hour;
      int minute = localTime.minute;
      String period = hour24 < 12 ? 'AM' : 'PM';

      int hour12 = hour24;
      if (hour24 == 0) {
        hour12 = 12;
      } else if (hour24 > 12) {
        hour12 = hour24 - 12;
      }

      String formattedMinute = minute.toString().padLeft(2, '0');
      return '$hour12:$formattedMinute $period';
    }

    String formatDate(DateTime dateTime) {
      DateTime localTime = dateTime.isUtc
          ? dateTime.toLocal().add(const Duration(hours: 1))
          : dateTime;

      List<String> months = [
        'Enero',
        'Febrero',
        'Marzo',
        'Abril',
        'Mayo',
        'Junio',
        'Julio',
        'Agosto',
        'Septiembre',
        'Octubre',
        'Noviembre',
        'Diciembre',
      ];

      List<String> weekdays = [
        'Lunes',
        'Martes',
        'Miércoles',
        'Jueves',
        'Viernes',
        'Sábado',
        'Domingo',
      ];

      return '${weekdays[localTime.weekday - 1]}, ${localTime.day} de ${months[localTime.month - 1]} ${localTime.year}';
    }

    String getFormattedCategory() {
      if (event.categories == null || event.categories!.isEmpty) {
        return "General";
      }
      return event.categories!
              .replaceAll(RegExp(r'Seccion.*'), '')
              .trim()
              .isNotEmpty
          ? event.categories!.replaceAll(RegExp(r'Seccion.*'), '').trim()
          : "General";
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

    String formatTimeRange() {
      String startTime = formatTime(event.dtstart);
      String endTime = formatTime(event.dtend);

      // Si las horas son iguales, solo mostrar la hora final
      if (startTime == endTime) {
        return endTime;
      }

      return '$startTime - $endTime';
    }

    String cleanDescription(String description) {
      return description
          .replaceAll(
            '\\n',
            '\n',
          ) // Convertir \n literales a saltos de línea reales
          .replaceAll(
            RegExp(r'\n+'),
            '\n',
          ) // Reemplazar múltiples \n consecutivos con uno solo
          .trim(); // Quitar espacios al inicio y final
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 20),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with icon and category
                  Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.15),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          getEventIcon(),
                          color: Theme.of(context).colorScheme.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer
                                    .withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                getFormattedCategory().toUpperCase(),
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      letterSpacing: 0.5,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Event title
                  Text(
                    event.summary,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Date and time section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Date
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Fecha',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    formatDate(event.dtstart),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        Divider(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withValues(alpha: 0.2),
                          height: 1,
                        ),
                        const SizedBox(height: 16),

                        // Time
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hora',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    formatTimeRange(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Description section (if available)
                  if (event.description != null &&
                      event.description!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Descripción',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        cleanDescription(event.description!),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],

                  // Event details section
                  const SizedBox(height: 24),
                  Text(
                    'Detalles del evento',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Event ID
                  _buildDetailRow(
                    context,
                    icon: Icons.tag_rounded,
                    label: 'ID del evento',
                    value: event.uid,
                  ),

                  // Last modified (if available)
                  if (event.lastModified != null)
                    _buildDetailRow(
                      context,
                      icon: Icons.update_rounded,
                      label: 'Última modificación',
                      value: formatDate(event.lastModified!),
                    ),

                  // Created at (if available)
                  if (event.dtstamp != null)
                    _buildDetailRow(
                      context,
                      icon: Icons.schedule_rounded,
                      label: 'Creado',
                      value: formatDate(event.dtstamp!),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
