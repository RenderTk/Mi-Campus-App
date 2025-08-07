import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/exceptions/token_refresh_failed_exception.dart';
import 'package:usap_mobile/models/calificacion_curso.dart';
import 'package:usap_mobile/models/student.dart';
import 'package:usap_mobile/providers/auth_provider.dart';
import 'package:usap_mobile/providers/student_provider.dart';
import 'package:usap_mobile/widgets/error_state_widget.dart';
import 'package:usap_mobile/widgets/labeled_badge.dart';
import 'package:usap_mobile/widgets/loading_state_widget.dart';
import 'package:usap_mobile/widgets/scrollable_segmented_buttons.dart';
import 'package:usap_mobile/widgets/session_expired_widget.dart';

class CalificacionesScreen extends ConsumerStatefulWidget {
  const CalificacionesScreen({super.key});

  @override
  ConsumerState<CalificacionesScreen> createState() =>
      _CalificacionesScreenState();
}

class _CalificacionesScreenState extends ConsumerState<CalificacionesScreen> {
  String selectedEstatus = "Todas";

  Color _getEstatusCalificacionColor(EstatusCalificacion estatus) {
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

  String _labelForEstatus(EstatusCalificacion estatus) {
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

  String _toTitleCase(String text) {
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

  List<List<CalificacionCurso>> _groupByAnios(
    List<CalificacionCurso> calificaciones,
  ) {
    final anios = calificaciones
        .map((calificacion) => calificacion.anio)
        .toSet()
        .toList();
    final grupos = <List<CalificacionCurso>>[];

    anios.sort((a, b) => b.compareTo(a));

    for (final anio in anios) {
      final calificacionesAnio = calificaciones
          .where((calificacion) => calificacion.anio == anio)
          .toList();
      grupos.add(calificacionesAnio);
    }

    return grupos;
  }

  void orderCalificaciones(List<CalificacionCurso> calificaciones) {
    calificaciones.sort((a, b) {
      final anioCompare = b.anio.compareTo(a.anio);
      if (anioCompare != 0) return anioCompare;

      final periodoCompare = int.parse(
        b.periodo,
      ).compareTo(int.parse(a.periodo));
      if (periodoCompare != 0) return periodoCompare;

      final aNota = a.nota;
      final bNota = b.nota;

      if (aNota == null && bNota == null) return 0;
      if (aNota == null) return 1; // nulls last
      if (bNota == null) return -1;

      return bNota.compareTo(aNota); // higher nota first
    });
  }

  Widget _buildClaseAnEstatus(CalificacionCurso calificacion) {
    return Row(
      children: [
        Text(
          calificacion.codigoCurso,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const Spacer(),
        if (calificacion.estatus == EstatusCalificacion.aprobada ||
            calificacion.estatus == EstatusCalificacion.reprobada)
          LabeledBadge(
            msg: calificacion.nota.toString(),
            foregroundColor: _getEstatusCalificacionColor(calificacion.estatus),
            backgroundColor: _getEstatusCalificacionColor(calificacion.estatus),
          ),
        const SizedBox(width: 5),
        LabeledBadge(
          msg: _toTitleCase(calificacion.estatus.name),
          backgroundColor: _getEstatusCalificacionColor(calificacion.estatus),
          foregroundColor: _getEstatusCalificacionColor(calificacion.estatus),
        ),
      ],
    );
  }

  Widget _buildCatedratico(CalificacionCurso calificacion) {
    return Row(
      children: [
        const Icon(Icons.person, size: 15),
        const SizedBox(width: 5),
        Text(
          calificacion.catedratico,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildFechaInfo(CalificacionCurso calificacion) {
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
        Text(calificacion.dias, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildCalificacionCard(CalificacionCurso calificacion) {
    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border(
            left: BorderSide(
              color: _getEstatusCalificacionColor(
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
            _buildClaseAnEstatus(calificacion),
            const SizedBox(height: 8),
            Text(
              calificacion.descripcionCurso,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            _buildFechaInfo(calificacion),
            const SizedBox(height: 8),
            _buildCatedratico(calificacion),
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

  Widget _buildCalifcacionesCardsInExpansionTile(
    List<CalificacionCurso> calificaciones,
  ) {
    orderCalificaciones(calificaciones);
    final calificacionesCards = calificaciones
        .map((calificacion) => _buildCalificacionCard(calificacion))
        .toList();

    return ExpansionTileCard(
      leading: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.school_outlined,
          color: Color.fromARGB(255, 16, 97, 162),
          size: 24,
        ),
      ),
      title: Text(
        calificaciones.first.anio,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        calificaciones.length == 1
            ? "1 calificación"
            : "${calificaciones.length} calificaciones",
        style: Theme.of(context).textTheme.bodySmall,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(children: calificacionesCards),
        ),
      ],
    );
  }

  Widget _buildCalificacionEstatusFilter() {
    return ScrollableSegmentedButtons(
      options: [
        "Todas",
        _labelForEstatus(EstatusCalificacion.aprobada),
        _labelForEstatus(EstatusCalificacion.reprobada),
        _labelForEstatus(EstatusCalificacion.cursando),
        _labelForEstatus(EstatusCalificacion.retiro),
      ],
      onSelected: (selectedEstatus) {
        setState(() {
          this.selectedEstatus = selectedEstatus;
        });
      },
      selected: selectedEstatus,
    );
  }

  Widget _buildSuccessState(Student student) {
    late List<CalificacionCurso> filteredCalificaciones =
        student.calificaciones;

    final validStatuses = _mapPluralStatusToEnum(selectedEstatus);

    if (selectedEstatus != "Todas") {
      filteredCalificaciones = student.calificaciones.where((calificacion) {
        return validStatuses.contains(calificacion.estatus);
      }).toList();
    }
    final grupos = _groupByAnios(filteredCalificaciones);

    return Scaffold(
      appBar: AppBar(title: const Text("Mis Calificaciones")),
      body: grupos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.school,
                    size: 100,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "No hay calificaciones disponibles",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                _buildCalificacionEstatusFilter(),
                Expanded(
                  child: ListView.builder(
                    itemCount: grupos.length,
                    itemBuilder: (context, index) {
                      final calificaciones = grupos[index];
                      return _buildCalifcacionesCardsInExpansionTile(
                        calificaciones,
                      );
                    },
                  ),
                ),
              ],
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

  @override
  Widget build(BuildContext context) {
    final student = ref.watch(studentProvider);

    return student.when(
      data: (student) => _buildSuccessState(student),
      error: (error, stackTrace) {
        // si se intento refrescar el token y no se pudo, se cierra la sesion
        // y se redirige al login
        if (error is TokenRefreshFailedException) {
          return SessionExpiredWidget(
            onLogin: () {
              ref.read(isLoggedInProvider.notifier).setLoggedOut();
            },
          );
        }

        return ErrorStateWidget(
          errorMessage:
              "Ocurrio un error al cargar las calificaciones. Intente mas tarde.",
          onRetry: () => ref.invalidate(studentProvider),
          showExitButton: true,
        );
      },
      loading: () => const LoadingStateWidget(),
    );
  }
}
