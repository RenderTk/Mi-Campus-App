import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:usap_mobile/exceptions/token_refresh_failed_exception.dart';
import 'package:usap_mobile/models/seccion_curso.dart';
import 'package:usap_mobile/models/student.dart';
import 'package:usap_mobile/providers/auth_provider.dart';
import 'package:usap_mobile/providers/selected_day_of_the_week_provider.dart';
import 'package:usap_mobile/providers/student_provider.dart';
import 'package:usap_mobile/widgets/days_of_the_week_filter_button.dart';
import 'package:usap_mobile/widgets/loading_state_widget.dart';

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

    Widget buildTextOnContainer(
      String msg,
      Color foregroundColor,
      Color backgroundColor, {
      IconData? icon,
    }) {
      return Container(
        height: 25,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(25),
        ),
        child: icon == null
            ? Text(
                msg,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: foregroundColor),
              )
            : Row(
                children: [
                  Icon(icon, size: 25, color: foregroundColor),
                  const SizedBox(width: 8),
                  Text(
                    msg,
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: foregroundColor),
                  ),
                ],
              ),
      );
    }

    Widget buildErrorState() => const Scaffold(
      body: Center(
        child: Text(
          "Ocurrio un error al cargar los horarios. Intente mas tarde.",
        ),
      ),
    );

    Widget buildClassNameText(SeccionCurso seccion) {
      return Row(
        children: [
          Text(
            seccion.descripcionCurso ?? "",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          buildTextOnContainer(
            seccion.estado?.trim() ?? "",
            Colors.green,
            Colors.green,
          ),
        ],
      );
    }

    Widget buildDaysText(
      SeccionCurso seccion,
      List<String> dias,
      String tiempoRestante,
    ) {
      return Row(
        children: [
          const Icon(Icons.calendar_month, size: 20),
          const SizedBox(width: 10),
          buildTextOnContainer(dias[0], Colors.deepPurple, Colors.deepPurple),
          if (dias.length > 1) ...[
            const SizedBox(width: 5),
            buildTextOnContainer(dias[1], Colors.deepPurple, Colors.deepPurple),
          ],
          const Spacer(),
          buildTextOnContainer(
            tiempoRestante,
            Colors.deepPurple,
            Colors.deepPurple,
          ),
        ],
      );
    }

    Widget buildClassCodeAndClassTime(SeccionCurso seccion) {
      return Row(
        children: [
          const Icon(Icons.location_on, size: 20),
          const SizedBox(width: 10),
          Text(
            "Aula ${seccion.aula?.trim()}",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Spacer(),
          const Icon(Icons.timer, size: 20),
          const SizedBox(width: 10),
          Text(
            "${seccion.inicio} - ${seccion.fin}",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      );
    }

    Widget buildClassModeAndClassLink(SeccionCurso seccion) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildTextOnContainer(
            seccion.grupo?.trim() ?? "",
            Colors.red,
            Colors.red,
          ),
          const Spacer(),
          InkWell(
            onTap: () async {
              await launchUrl(
                Uri.parse(seccion.url ?? ""),
                mode:
                    LaunchMode.externalApplication, // Opens in external browser
              );
            },
            child: buildTextOnContainer(
              "Enlace del curso",
              Colors.blueAccent,
              Colors.blueAccent,
              icon: Icons.link,
            ),
          ),
        ],
      );
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

      final tiempoRestante = SeccionCurso.calcularTiempoRestante(seccion);

      return Card(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          margin: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildClassNameText(seccion),
              const SizedBox(height: 5),
              Text(
                "${seccion.codigoCurso} - Seccion ${seccion.numeroSeccion}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              buildDaysText(seccion, dias, tiempoRestante),
              const SizedBox(height: 10),
              buildClassCodeAndClassTime(seccion),
              const SizedBox(height: 12),
              buildClassModeAndClassLink(seccion),
            ],
          ),
        ),
      );
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: filteredSecciones.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.hourglass_empty,
                        size: 100,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "No hay cursos disponibles",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
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
        ),
        bottomSheet: SafeArea(
          child: Container(
            height: 50,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            alignment: Alignment.topCenter,
            child: Text(
              "Total de clases: ${filteredSecciones.length}",
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
          ref.read(isLoggedInProvider.notifier).setLoggedOut();
        }

        return buildErrorState();
      },
      loading: () => const LoadingStateWidget(),
    );
  }
}
