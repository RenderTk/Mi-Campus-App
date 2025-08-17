import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/exceptions/token_refresh_failed_exception.dart';
import 'package:usap_mobile/models/seccion_curso.dart';
import 'package:usap_mobile/models/student.dart';
import 'package:usap_mobile/providers/selected_day_of_the_week_provider.dart';
import 'package:usap_mobile/providers/student_provider.dart';
import 'package:usap_mobile/providers/user_provider.dart';
import 'package:usap_mobile/widgets/cards/horario_card.dart';
import 'package:usap_mobile/widgets/days_of_the_week_filter_button.dart';
import 'package:usap_mobile/widgets/error_state_widget.dart';
import 'package:usap_mobile/widgets/loading_state_widget.dart';
import 'package:usap_mobile/widgets/session_expired_widget.dart';

class HorariosScreen extends ConsumerWidget {
  const HorariosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.watch(studentProvider);

    List<SeccionCurso> filtrarSeccionesPorDia(
      List<SeccionCurso> secciones,
      DayOfTheWeek day,
    ) {
      // Si es "todos", devolver todas las secciones
      if (day == DayOfTheWeek.todos) {
        return secciones;
      }

      // Obtener códigos de cursos del día seleccionado
      Set<String> codigosCursosDelDia = secciones
          .where(
            (seccion) =>
                seccion.dia?.trim().toLowerCase() ==
                day.name.trim().toLowerCase(),
          )
          .map((seccion) => seccion.codigoCurso)
          .where((codigo) => codigo != null)
          .cast<String>()
          .toSet();

      // Filtrar todas las secciones que coincidan con esos códigos
      return secciones
          .where((seccion) => codigosCursosDelDia.contains(seccion.codigoCurso))
          .toList();
    }

    Widget buildClassCard(
      SeccionCurso seccion,
      List<SeccionCurso> secciones,
      Set<SeccionCurso> seccionesProcesadas,
    ) {
      final sameClassOnOtherDay = secciones
          .where(
            (s) =>
                s.codigoCurso == seccion.codigoCurso && // MISMO código
                s.dia?.trim() != seccion.dia?.trim(), // DIFERENTE día
          )
          .firstOrNull;

      final dias = [seccion.dia?.trim() ?? ''];
      if (sameClassOnOtherDay != null) {
        dias.add(sameClassOnOtherDay.dia?.trim() ?? '');
        seccionesProcesadas.add(sameClassOnOtherDay);
        seccionesProcesadas.add(seccion);
      }
      return HorarioCard(seccion: seccion, diasQueAplica: dias);
    }

    Widget buildSuccessState(Student student, DayOfTheWeek day) {
      final secciones = student.secciones;
      final Set<SeccionCurso> seccionesProcesadas = {};
      List<SeccionCurso> filteredSecciones = secciones;
      if (day != DayOfTheWeek.todos) {
        filteredSecciones = filtrarSeccionesPorDia(secciones, day);
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Mi Horario",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: const [DaysOfTheWeekFilterButton()],
        ),
        body: filteredSecciones.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(bottom: 25, left: 10, right: 10),
                child: ListView.builder(
                  itemCount: filteredSecciones.length,
                  itemBuilder: (context, index) {
                    final seccion = filteredSecciones[index];
                    if (seccionesProcesadas.contains(seccion)) {
                      return const SizedBox.shrink();
                    }

                    return buildClassCard(
                      seccion,
                      filteredSecciones,
                      seccionesProcesadas,
                    );
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
                      "No hay clases disponibles",
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
              "Total de clases: ${filteredSecciones.map((s) => s.descripcionCurso).toSet().length}",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      );
    }

    final selectedDayOfTheWeekFilter = ref.watch(selectedDayOfTheWeekProvider);
    return student.when(
      data: (student) => buildSuccessState(student, selectedDayOfTheWeekFilter),
      error: (error, stackTrace) {
        // si se intento refrescar el token y no se pudo, se cierra la sesion
        // y se redirige al login
        if (error is TokenRefreshFailedException) {
          return SessionExpiredWidget(
            onLogin: () async {
              await ref.watch(userProvider.notifier).logOut();
            },
          );
        }

        return ErrorStateWidget(
          errorMessage:
              "Ocurrio un error al cargar los horarios. Intente mas tarde.",
          onRetry: () => ref.invalidate(userProvider),
          showExitButton: true,
        );
      },
      loading: () => const LoadingStateWidget(),
    );
  }
}
