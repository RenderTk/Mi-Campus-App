import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/models/calificacion_curso.dart';
import 'package:usap_mobile/providers/student_provider.dart';
import 'package:usap_mobile/screens/home_screen/perfil_widgets/configuration_card.dart';
import 'package:usap_mobile/screens/home_screen/home_widgets/rendimiento_academico_card.dart';
import 'package:usap_mobile/screens/home_screen/perfil_widgets/student_card.dart';
import 'package:usap_mobile/screens/home_screen/perfil_widgets/degree_progress_plus_widget.dart';

class PerfilWidget extends ConsumerWidget {
  const PerfilWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.watch(studentProvider);
    return student.when(
      data: (student) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StudentCard(student: student),

              DegreeProgressPlusWidget(student: student),

              RendimientoAcademicoCard(
                puntosCoprogramaticos: student.puntosCoProgramaticos,
                promedioGeneral: CalificacionCurso.getPromedio(
                  student.calificaciones,
                ),
              ),
              const ConfigurationCard(),
            ],
          ),
        ),
      ),

      // handle by parent widget (HomeScreen)
      error: (error, stackTrace) => const SizedBox.shrink(),
      // handle by parent widget (HomeScreen)
      loading: () => const SizedBox.shrink(),
    );
  }
}
