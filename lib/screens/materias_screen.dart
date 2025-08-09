import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/exceptions/token_refresh_failed_exception.dart';
import 'package:usap_mobile/models/matricula.dart';
import 'package:usap_mobile/providers/auth_provider.dart';
import 'package:usap_mobile/providers/matricula_provider.dart';
import 'package:usap_mobile/screens/materias_detail_screen.dart';
import 'package:usap_mobile/utils/app_providers.dart';
import 'package:usap_mobile/widgets/error_state_widget.dart';
import 'package:usap_mobile/widgets/loading_state_widget.dart';
import 'package:usap_mobile/widgets/session_expired_widget.dart';

class MateriasScreen extends ConsumerWidget {
  const MateriasScreen({super.key});

  Widget _buildLeadingIconForExpansionTile(
    BuildContext context,
    IconData icon,
  ) {
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
    return ListTile(
      leading: _buildLeadingIconForExpansionTile(context, Icons.menu_book),
      title: Text(
        matriculasGroupedByClass[0].descripcionCurso.toString(),
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subtitle: Text(
        matriculasGroupedByClass.length == 1
            ? "1 clase disponible"
            : "${matriculasGroupedByClass.length} clases disponibles",
      ),
      onTap: matriculasGroupedByClass.isEmpty
          ? null
          : () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MateriasDetailScreen(matriculas: matriculasGroupedByClass),
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

    return ExpansionTileCard(
      leading: _buildLeadingIconForExpansionTile(context, Icons.date_range),
      title: Text(
        "Periodo: ${matriculasByPeriodo[0].periodo.toString()}",
        style: Theme.of(context).textTheme.titleMedium,
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
        if (matriculas.isEmpty) {
          return const Center(child: Text("No tienes matriculas"));
        }

        final groupsByPeriodo = Matricula.agruparPorPeriodo(matriculas);

        return Scaffold(
          appBar: AppBar(title: const Text("Oferta de Matricula")),
          body: ListView.builder(
            itemCount: groupsByPeriodo.length,
            itemBuilder: (BuildContext context, int index) {
              final grupo = groupsByPeriodo[index];
              return _buildPeriodoGroups(context, grupo);
            },
          ),
        );
      },
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
              "Ocurrio un error al cargar los datos de su oferta de matricula. Intente mas tarde.",
          onRetry: () => ref.invalidate(matriculaProvider),
          showExitButton: true,
        );
      },
      loading: () => const LoadingStateWidget(),
    );
  }
}
