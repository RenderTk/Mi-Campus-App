import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mi_campus_app/models/student.dart';

class DegreeProgressWidget extends StatelessWidget {
  const DegreeProgressWidget({super.key, required this.student});
  final Student student;

  @override
  Widget build(BuildContext context) {
    Widget buildDegreeProgressChart(int completionPercentage) {
      return SizedBox(
        width: 100,
        height: 80,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Donut Chart
            PieChart(
              PieChartData(
                startDegreeOffset: -90, // Empezar desde arriba
                sectionsSpace: 0,
                centerSpaceRadius: 45, // Esto crea el hueco en el centro
                sections: [
                  // Sección completada (azul)
                  PieChartSectionData(
                    value: completionPercentage.toDouble(),
                    color: const Color(0xFF4285F4), // Azul similar a la imagen
                    title: '',
                    radius: 20, // Grosor del anillo
                    showTitle: false,
                  ),
                  // Sección restante (gris)
                  PieChartSectionData(
                    value: (100 - completionPercentage).toDouble(),
                    color: const Color(0xFFE0E0E0), // Gris claro
                    title: '',
                    radius: 20, // Grosor del anillo
                    showTitle: false,
                  ),
                ],
              ),
            ),
            // Texto del porcentaje en el centro
            Text(
              '$completionPercentage%',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF4285F4),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 200,
      child: Card(
        color: Theme.of(
          context,
        ).colorScheme.secondaryFixed.withValues(alpha: 0.1),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Progreso de la carrera",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 30),
              Center(
                child: buildDegreeProgressChart(
                  student.carrera.progresoCarrera,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
