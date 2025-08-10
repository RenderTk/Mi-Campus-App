import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/providers/student_provider.dart';
import 'package:usap_mobile/widgets/cards/configuration_card.dart';
import 'package:usap_mobile/widgets/cards/student_card.dart';
import 'package:usap_mobile/widgets/degree_progress_plus_widget.dart';

class PerfilWidget extends ConsumerWidget {
  const PerfilWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.watch(studentProvider);
    return student.when(
      data: (student) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StudentCard(student: student),
            const SizedBox(height: 5),
            const Divider(),
            const SizedBox(height: 5),
            DegreeProgressPlusWidget(student: student),
            const Divider(),
            const SizedBox(height: 5),
            const ConfigurationCard(),
          ],
        ),
      ),

      // handle by parent widget (HomeScreen)
      error: (error, stackTrace) => const SizedBox.shrink(),
      // handle by parent widget (HomeScreen)
      loading: () => const SizedBox.shrink(),
    );
  }
}
