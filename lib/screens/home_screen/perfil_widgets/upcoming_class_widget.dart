import 'package:flutter/material.dart';
import 'package:mi_campus_app/models/seccion_curso.dart';
import 'package:mi_campus_app/models/student.dart';
import 'package:mi_campus_app/utils/helper_functions.dart';
import 'package:mi_campus_app/widgets/labeled_badge.dart';
import 'package:url_launcher/url_launcher.dart';

class UpcomingClassWidget extends StatelessWidget {
  const UpcomingClassWidget({super.key, required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    final proximaClaseInfo = SeccionCurso.obtenerInfoProximaClase(
      student.secciones,
    );

    if (proximaClaseInfo == null) {
      return const SizedBox.shrink();
    }

    final seccion = proximaClaseInfo["seccion"] as SeccionCurso;
    final tiempoRestante = proximaClaseInfo["tiempoRestante"] as String;

    return Card(
      color: Theme.of(
        context,
      ).colorScheme.secondaryFixed.withValues(alpha: 0.1),
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: Theme.of(context).colorScheme.primary,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  'Próxima Clase',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Spacer(),
                // Badge más prominente para tiempo restante con colores de éxito/advertencia
                LabeledBadge(
                  msg: tiempoRestante,
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                // Texto simple para el nombre del curso, más legible
                SizedBox(
                  width: 220,
                  child: Text(
                    customCapitalize(seccion.descripcionCurso ?? ""),
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                Text(
                  "Aula ${seccion.aula}",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "${seccion.dia?.trim()} ${seccion.inicio} - ${seccion.fin}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                LabeledBadge(
                  msg: seccion.grupo?.trim() ?? "",
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Botón más prominente para el enlace
            InkWell(
              onTap: () async {
                await launchUrl(
                  Uri.parse(seccion.url ?? ""),
                  mode: LaunchMode.externalApplication,
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.launch,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Ir al curso",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
