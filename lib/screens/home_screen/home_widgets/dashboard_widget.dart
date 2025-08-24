import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:usap_mobile/models/calificacion_curso.dart';
import 'package:usap_mobile/providers/student_provider.dart';
import 'package:usap_mobile/providers/user_provider.dart';
import 'package:usap_mobile/screens/home_screen/home_widgets/degree_progress_widget.dart';
import 'package:usap_mobile/screens/home_screen/home_widgets/quick_access_widget.dart';
import 'package:usap_mobile/screens/home_screen/home_widgets/rendimiento_academico_card.dart';

class DashboardWidget extends ConsumerWidget {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.watch(studentProvider);

    return student.when(
      data: (student) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 0,
                ),
                title: Text(
                  student.user.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  student.user.id,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: IconButton(
                  onPressed: () async {
                    await ref.read(userProvider.notifier).logOut();
                  },
                  icon: const Icon(FontAwesomeIcons.rightFromBracket),
                ),
              ),
              DegreeProgressWidget(student: student),
              RendimientoAcademicoCard(
                puntosCoprogramaticos: student.puntosCoProgramaticos,
                promedioGeneral: CalificacionCurso.getPromedio(
                  student.calificaciones,
                ),
              ),
              const QuickAccessWidget(),
              // UpcomingClassWidget(student: student),
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
