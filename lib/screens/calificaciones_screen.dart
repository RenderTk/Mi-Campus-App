import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/exceptions/token_refresh_failed_exception.dart';
import 'package:usap_mobile/models/calificacion_curso.dart';
import 'package:usap_mobile/models/student.dart';
import 'package:usap_mobile/providers/auth_provider.dart';
import 'package:usap_mobile/providers/student_provider.dart';
import 'package:usap_mobile/screens/calificaciones_detail_screen.dart';
import 'package:usap_mobile/utils/app_providers.dart';
import 'package:usap_mobile/widgets/error_state_widget.dart';
import 'package:usap_mobile/widgets/loading_state_widget.dart';
import 'package:usap_mobile/widgets/session_expired_widget.dart';

class CalificacionesScreen extends ConsumerStatefulWidget {
  const CalificacionesScreen({super.key});

  @override
  ConsumerState<CalificacionesScreen> createState() =>
      _CalificacionesScreenState();
}

class _CalificacionesScreenState extends ConsumerState<CalificacionesScreen> {
  Widget _buildLeadingIconForTile(BuildContext context, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: const Color.fromARGB(255, 16, 97, 162),
        size: 24,
      ),
    );
  }

  Widget _buildPeriodoListTile(List<CalificacionCurso> calificaciones) {
    if (calificaciones.isEmpty) {
      return const SizedBox.shrink();
    }
    String periodo = calificaciones.first.periodo;

    return ListTile(
      leading: _buildLeadingIconForTile(context, Icons.date_range),
      title: Text(
        "Periodo: $periodo",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: Text(
        calificaciones.length == 1
            ? "1 calificación"
            : "${calificaciones.length} calificaciones",
        style: Theme.of(context).textTheme.bodySmall,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CalificacionesDetailScreen(calificaciones: calificaciones),
          ),
        );
      },
    );
  }

  Widget _buildCalifcacionesCardsInExpansionTile(
    List<CalificacionCurso> calificaciones,
  ) {
    CalificacionCurso.orderCalificaciones(calificaciones);
    final groupsByPeriodo = CalificacionCurso.groupByPeriodo(calificaciones);

    return ExpansionTileCard(
      leading: _buildLeadingIconForTile(context, Icons.school_outlined),
      title: Text(
        calificaciones.first.anio,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        groupsByPeriodo.length == 1
            ? "1 periodo"
            : "${groupsByPeriodo.length} periodos",
        style: Theme.of(context).textTheme.bodySmall,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: groupsByPeriodo.length,
            itemBuilder: (BuildContext context, int index) {
              final calificaciones = groupsByPeriodo[index];
              return _buildPeriodoListTile(calificaciones);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessState(Student student) {
    final groupsByAnio = CalificacionCurso.groupByAnio(student.calificaciones);

    return Scaffold(
      appBar: AppBar(title: const Text("Mis Calificaciones")),
      body: groupsByAnio.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: ListView.builder(
                itemCount: groupsByAnio.length,
                itemBuilder: (context, index) {
                  final califaciones = groupsByAnio[index];
                  return _buildCalifcacionesCardsInExpansionTile(califaciones);
                },
              ),
            )
          : Center(
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
            ),
      bottomSheet: SafeArea(
        child: Container(
          height: 50,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          alignment: Alignment.topCenter,
          child: Text(
            "Promedio: ${CalificacionCurso.getPromedio(student.calificaciones).toStringAsFixed(0)}",
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
              AppProviders.invalidateAllProviders(ref);
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
