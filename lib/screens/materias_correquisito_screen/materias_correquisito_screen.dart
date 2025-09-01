import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/exceptions/token_refresh_failed_exception.dart';
import 'package:usap_mobile/models/matricula.dart';
import 'package:usap_mobile/providers/matricula_correquisito_provider.dart';
import 'package:usap_mobile/providers/user_provider.dart';
import 'package:usap_mobile/screens/materias_screen/widgets/materia_card.dart';
import 'package:usap_mobile/utils/helper_functions.dart';
import 'package:usap_mobile/widgets/error_state_widget.dart';
import 'package:usap_mobile/widgets/loading_state_widget.dart';
import 'package:usap_mobile/widgets/session_expired_widget.dart';

class MateriasCorrequisitoScreen extends ConsumerWidget {
  const MateriasCorrequisitoScreen({
    super.key,
    required this.matricula,
    required this.codigoAlumno,
  });
  final Matricula matricula;
  final String codigoAlumno;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = (codigoAlumno: codigoAlumno, matricula: matricula);
    final materiasCorrequisito = ref.watch(
      matriculaCorrequisitoProvider(params),
    );

    return materiasCorrequisito.when(
      data: (materiasCorrequisito) {
        return Scaffold(
          appBar: AppBar(
            title: Text(customCapitalize(matricula.descripcionCurso)),
          ),
          body: ListView.builder(
            itemCount: materiasCorrequisito.length,
            itemBuilder: (context, index) {
              final materiaCorrequisito = materiasCorrequisito[index];

              return MateriaCard(
                matricula: materiaCorrequisito,
                isSelected: matricula.estaSeleccionada ?? false,
                readOnlyMode: false,
                esDeCorrequisito: true,
                estaPagada: materiaCorrequisito.estaPagada,
                onTap: (Matricula materia) async {
                  Navigator.pop(context, materia);
                },
              );
            },
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
              "Ocurrio un error al cargar las materias de correquisito de ${customCapitalize(matricula.descripcionCurso)}. Intente mas tarde.",
          onRetry: () => ref.invalidate(matriculaCorrequisitoProvider),
          showExitButton: true,
        );
      },
      loading: () => const LoadingStateWidget(),
    );
  }
}
