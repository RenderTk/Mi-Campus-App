import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/providers/student_provider.dart';
import 'package:usap_mobile/screens/home_screen/home_widgets/degree_progress_widget.dart';
import 'package:usap_mobile/screens/home_screen/perfil_widgets/upcoming_class_widget.dart';
import 'package:usap_mobile/screens/home_screen/perfil_widgets/configuration_card.dart';
import 'package:usap_mobile/screens/home_screen/perfil_widgets/student_card.dart';

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
              DegreeProgressWidget(student: student),
              UpcomingClassWidget(student: student),
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
