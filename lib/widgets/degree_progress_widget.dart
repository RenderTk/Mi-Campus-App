import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:usap_mobile/models/user.dart';

class DegreeProgressWidget extends StatelessWidget {
  const DegreeProgressWidget({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    Widget buildDegreeProgressChart(int completionPercentage) {
      return SizedBox(
        width: 100,
        height: 70,
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
      height: 220,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.carrera, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 10),
              Text(
                "Progreso de la carrera",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 30),
              Center(child: buildDegreeProgressChart(user.progresoCarrera)),
            ],
          ),
        ),
      ),
    );
  }
}
