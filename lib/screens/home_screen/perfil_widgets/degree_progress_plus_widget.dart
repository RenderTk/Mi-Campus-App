import 'package:flutter/material.dart';
import 'package:usap_mobile/models/student.dart';

class DegreeProgressPlusWidget extends StatelessWidget {
  const DegreeProgressPlusWidget({super.key, required this.student});
  final Student student;

  @override
  Widget build(BuildContext context) {
    Widget buildClassesProgressCards(
      BuildContext context, {
      required int completed,
      required int total,
    }) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Card(
            color: Colors.green.withValues(alpha: 0.1),
            child: SizedBox(
              width: 150,
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.green),
                    const SizedBox(height: 2),
                    Text(
                      completed.toString(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Clases Completadas",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            color: Theme.of(
              context,
            ).colorScheme.tertiary.withValues(alpha: 0.1),
            child: SizedBox(
              width: 150,
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.pending_actions,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      (total - completed).toString(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Clases Restantes",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    Widget buildProgressBar(
      BuildContext context, {
      required int completed,
      required int total,
    }) {
      double progress = completed / total;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Completado"),
              Text("$completed/$total clases"),
            ],
          ),
          const SizedBox(height: 8),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: const Color(0xFFE9ECEF),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          const SizedBox(height: 8),
          buildClassesProgressCards(
            context,
            completed: completed,
            total: total,
          ),
        ],
      );
    }

    return Card(
      color: Theme.of(
        context,
      ).colorScheme.secondaryFixed.withValues(alpha: 0.1),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Progreso de la carrera",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                const Icon(
                  Icons.trending_up,
                  color: Color.fromARGB(255, 26, 210, 32),
                ),
              ],
            ),
            const SizedBox(height: 15),
            buildProgressBar(
              context,
              completed: student.carrera.totalClasesCompletadas,
              total: student.carrera.totalClases,
            ),
          ],
        ),
      ),
    );
  }
}
