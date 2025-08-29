import 'package:flutter/material.dart';
import 'package:usap_mobile/models/calificacion_curso.dart';
import 'package:usap_mobile/widgets/labeled_badge.dart';

class CalificacionCard extends StatelessWidget {
  const CalificacionCard({super.key, required this.calificacion});
  final CalificacionCurso calificacion;

  @override
  Widget build(BuildContext context) {
    Color getEstatusCalificacionColor(EstatusCalificacion estatus) {
      switch (estatus) {
        case EstatusCalificacion.aprobada:
          return Colors.green;
        case EstatusCalificacion.reprobada:
          return Colors.red;
        case EstatusCalificacion.cursando:
          return Colors.blue;
        case EstatusCalificacion.retiro:
          return Colors.orange;
      }
    }

    String toTitleCase(String text) {
      if (text.isEmpty) return text;

      return text
          .toLowerCase()
          .split(' ')
          .map(
            (word) => word.isNotEmpty
                ? '${word[0].toUpperCase()}${word.substring(1)}'
                : '',
          )
          .join(' ');
    }

    Widget buildClaseAnEstatus(CalificacionCurso calificacion) {
      return Row(
        children: [
          Text(
            calificacion.codigoCurso,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Spacer(),
          if (calificacion.estatus == EstatusCalificacion.aprobada ||
              calificacion.estatus == EstatusCalificacion.reprobada ||
              calificacion.estatus == EstatusCalificacion.cursando)
            LabeledBadge(
              msg: calificacion.nota != null
                  ? calificacion.nota.toString()
                  : "Sin calificación",
              foregroundColor: getEstatusCalificacionColor(
                calificacion.estatus,
              ),
              backgroundColor: getEstatusCalificacionColor(
                calificacion.estatus,
              ),
            ),
          const SizedBox(width: 5),
          LabeledBadge(
            msg: toTitleCase(calificacion.estatus.name),
            backgroundColor: getEstatusCalificacionColor(calificacion.estatus),
            foregroundColor: getEstatusCalificacionColor(calificacion.estatus),
          ),
        ],
      );
    }

    Widget buildCatedratico(CalificacionCurso calificacion) {
      return Row(
        children: [
          const Icon(Icons.person, size: 15),
          const SizedBox(width: 5),
          Text(
            calificacion.catedratico ?? "Catedratico no disponible",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      );
    }

    Widget buildFechaInfo(CalificacionCurso calificacion) {
      final periodo = calificacion.periodo == "1"
          ? 'I'
          : calificacion.periodo == "2"
          ? 'II'
          : 'III';

      return Row(
        children: [
          const Icon(Icons.calendar_month, size: 15),
          const SizedBox(width: 5),
          Text(
            "${calificacion.anio} - Periodo: $periodo",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Spacer(),
          const Icon(Icons.sunny, size: 15),
          const SizedBox(width: 5),
          Text(
            calificacion.diasDeLaSemana?.join(", ") ?? "Dias no disponibles",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      );
    }

    return Card(
      color: Theme.of(
        context,
      ).colorScheme.secondaryFixed.withValues(alpha: 0.1),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border(
            left: BorderSide(
              color: getEstatusCalificacionColor(
                calificacion.estatus,
              ), // Color of the vertical line
              width: 3.0, // Thickness of the line
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildClaseAnEstatus(calificacion),
            const SizedBox(height: 8),
            Text(
              calificacion.descripcionCurso,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            buildFechaInfo(calificacion),
            const SizedBox(height: 8),
            buildCatedratico(calificacion),
            if (calificacion.etiqueta != null) ...[
              const SizedBox(height: 10),
              LabeledBadge(
                msg: calificacion.etiqueta!,
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
