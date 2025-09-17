import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_campus_app/exceptions/token_refresh_failed_exception.dart';
import 'package:mi_campus_app/models/matricula.dart';
import 'package:mi_campus_app/providers/matricula_provider.dart';
import 'package:mi_campus_app/providers/user_provider.dart';
import 'package:mi_campus_app/screens/materias_screen/materias_detail_screen.dart';
import 'package:mi_campus_app/widgets/error_state_widget.dart';
import 'package:mi_campus_app/widgets/labeled_badge.dart';
import 'package:mi_campus_app/widgets/loading_state_widget.dart';
import 'package:mi_campus_app/widgets/session_expired_widget.dart';

class MateriasScreen extends ConsumerWidget {
  const MateriasScreen({super.key, required this.readOnlyMode});
  final bool readOnlyMode;

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

  Widget _buildClassesGroup(
    BuildContext context,
    List<Matricula> matriculasGroupedByClass,
  ) {
    final hasSelectedItems = matriculasGroupedByClass.any(
      (matricula) => matricula.estaSeleccionada == true,
    );

    return ListTile(
      leading: _buildLeadingIconForTile(context, Icons.menu_book),
      title: Text(
        matriculasGroupedByClass[0].descripcionCurso.toString(),
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subtitle: Text(
        matriculasGroupedByClass.length == 1
            ? "1 clase disponible"
            : "${matriculasGroupedByClass.length} clases disponibles",
      ),
      trailing: hasSelectedItems
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            )
          : null,
      onTap: matriculasGroupedByClass.isEmpty
          ? null
          : () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MateriasDetailScreen(
                  matriculas: matriculasGroupedByClass,
                  readOnlyMode: readOnlyMode,
                ),
              ),
            ),
    );
  }

  Widget _buildPeriodoGroups(
    BuildContext context,
    List<Matricula> matriculasByPeriodo,
  ) {
    //
    final groupsByClass = Matricula.agruparPorClase(matriculasByPeriodo);
    final nombreClasesCount = matriculasByPeriodo
        .map((matricula) => matricula.descripcionCurso)
        .toSet()
        .toList()
        .length;
    final hasSelectedItems = groupsByClass.any(
      (group) => group.any((classItem) => classItem.estaSeleccionada == true),
    );
    final totalSelectedClasses = groupsByClass
        .expand((group) => group)
        .where((classItem) => classItem.estaSeleccionada == true)
        .length;

    return ExpansionTileCard(
      leading: _buildLeadingIconForTile(context, Icons.date_range),
      title: Row(
        children: [
          Expanded(
            child: Text(
              "Periodo: ${matriculasByPeriodo[0].periodo.toString()}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (hasSelectedItems)
            LabeledBadge(
              msg: "$totalSelectedClasses",
              foregroundColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              icon: Icons.done,
              iconSize: 15,
            ),
        ],
      ),
      subtitle: Text(
        nombreClasesCount == 1
            ? "1 sección disponible"
            : "$nombreClasesCount secciones disponibles",
        style: Theme.of(context).textTheme.bodySmall,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: groupsByClass.length,
            itemBuilder: (context, index) {
              final matriculasGroupedByClass = groupsByClass[index];

              return _buildClassesGroup(context, matriculasGroupedByClass);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matriculas = ref.watch(matriculaProvider);

    return matriculas.when(
      data: (matriculas) {
        final groupsByPeriodo = Matricula.agruparPorPeriodo(matriculas);

        return Scaffold(
          appBar: AppBar(
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Oferta de Matricula"),
                if (readOnlyMode)
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Modo Lectura",
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.lock, size: 16, color: Colors.grey),
                    ],
                  ),
              ],
            ),
          ),
          body: matriculas.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: ListView.builder(
                    itemCount: groupsByPeriodo.length,
                    itemBuilder: (BuildContext context, int index) {
                      final grupo = groupsByPeriodo[index];
                      return _buildPeriodoGroups(context, grupo);
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
                        "No hay materias disponibles",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
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
              "Ocurrio un error al cargar los datos de su oferta de matricula. Intente mas tarde.",
          onRetry: () => ref.invalidate(matriculaProvider),
          showExitButton: true,
        );
      },
      loading: () => const LoadingStateWidget(),
    );
  }
}
