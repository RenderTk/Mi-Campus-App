import 'package:flutter/material.dart';
import 'package:usap_mobile/models/seccion_curso.dart';
import 'package:usap_mobile/models/student.dart';

class UpcomingClassWidget extends StatelessWidget {
  const UpcomingClassWidget({super.key, required this.student});
  final Student student;

  @override
  Widget build(BuildContext context) {
    Widget buidlClassCard(Student student) {
      final proximaClaseInfo = SeccionCurso.obtenerInfoProximaClase(
        student.secciones,
      );
      final seccion = proximaClaseInfo?["seccion"] as SeccionCurso;
      final tiempoRestante = proximaClaseInfo?["tiempoRestante"] as String;

      return Card(
        color: Theme.of(
          context,
        ).colorScheme.secondaryFixed.withValues(alpha: 0.1),
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Text(
                seccion.descripcionCurso ??
                    "No se pudo cargar el nombre del curso.",
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    seccion.codigoCurso ??
                        "No se pudo cargar el codigo del curso.",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    " - ${seccion.grupo}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  Text(
                    tiempoRestante,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "Aula ${seccion.aulaNormalizada} - ${seccion.dia?.trim()} - ${seccion.inicio} a ${seccion.fin}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
            child: Text(
              'Proxima Clase',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          buidlClassCard(student),
        ],
      ),
    );
  }
}
