import 'package:flutter/material.dart';
import 'package:usap_mobile/models/calificacion_curso.dart';
import 'package:usap_mobile/widgets/cards/calificacion_card.dart';
import 'package:usap_mobile/widgets/scrollable_segmented_buttons.dart';

class CalificacionesDetailScreen extends StatefulWidget {
  const CalificacionesDetailScreen({super.key, required this.calificaciones});
  final List<CalificacionCurso> calificaciones;

  @override
  State<CalificacionesDetailScreen> createState() =>
      _CalificacionesDetailScreenState();
}

class _CalificacionesDetailScreenState
    extends State<CalificacionesDetailScreen> {
  String selectedEstatus = "Todas";

  String labelForEstatus(EstatusCalificacion estatus) {
    switch (estatus) {
      case EstatusCalificacion.aprobada:
        return "Aprobadas";
      case EstatusCalificacion.reprobada:
        return "Reprobadas";
      case EstatusCalificacion.cursando:
        return "Cursando";
      case EstatusCalificacion.retiro:
        return "Retiradas";
    }
  }

  List<EstatusCalificacion> _mapPluralStatusToEnum(String selectedEstatus) {
    switch (selectedEstatus.toLowerCase()) {
      case 'aprobadas':
        return [EstatusCalificacion.aprobada];
      case 'reprobadas':
        return [EstatusCalificacion.reprobada];
      case 'retiradas':
        return [EstatusCalificacion.retiro];
      case 'cursando':
        return [EstatusCalificacion.cursando];
      case 'todas':
      default:
        return EstatusCalificacion.values;
    }
  }

  Widget buildCalificacionEstatusFilter() {
    return ScrollableSegmentedButtons(
      options: [
        "Todas",
        labelForEstatus(EstatusCalificacion.aprobada),
        labelForEstatus(EstatusCalificacion.reprobada),
        labelForEstatus(EstatusCalificacion.cursando),
        labelForEstatus(EstatusCalificacion.retiro),
      ],
      onSelected: (selectedEstatus) {
        setState(() {
          this.selectedEstatus = selectedEstatus;
        });
      },
      selected: selectedEstatus,
    );
  }

  @override
  Widget build(BuildContext context) {
    late List<CalificacionCurso> filteredCalificaciones = widget.calificaciones;
    final validStatuses = _mapPluralStatusToEnum(selectedEstatus);

    if (selectedEstatus != "Todas") {
      filteredCalificaciones = widget.calificaciones.where((calificacion) {
        return validStatuses.contains(calificacion.estatus);
      }).toList();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.calificaciones.first.anio} - Periodo ${widget.calificaciones.first.periodo}",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: filteredCalificaciones.isNotEmpty
            ? Column(
                children: [
                  buildCalificacionEstatusFilter(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredCalificaciones.length,
                      itemBuilder: (BuildContext context, int index) {
                        final calificacion = filteredCalificaciones[index];
                        return CalificacionCard(calificacion: calificacion);
                      },
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  buildCalificacionEstatusFilter(),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.school,
                            size: 100,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "No hay calificaciones disponibles",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),

      bottomSheet: SafeArea(
        child: Container(
          height: 50,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          alignment: Alignment.topCenter,
          child: Text(
            "Total de calificaciones: ${filteredCalificaciones.length}",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
