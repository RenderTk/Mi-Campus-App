import 'package:flutter/material.dart';

class RendimientoAcademicoCard extends StatelessWidget {
  const RendimientoAcademicoCard({
    super.key,
    required this.promedioGraduacion,
    required this.promedioHistorico,
  });
  final double promedioGraduacion;
  final double promedioHistorico;

  @override
  Widget build(BuildContext context) {
    Widget buildStarRow(int score) {
      int filledStars;

      if (score >= 90) {
        filledStars = 5;
      } else if (score >= 70) {
        filledStars = 4;
      } else if (score >= 50) {
        filledStars = 3;
      } else if (score >= 30) {
        filledStars = 2;
      } else {
        filledStars = 1;
      }

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) {
          return Icon(
            index < filledStars ? Icons.star : Icons.star_border,
            color: const Color.fromARGB(255, 213, 238, 24),
            size: 20,
          );
        }),
      );
    }

    Widget buildClassesProgressCards(BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Card(
            color: Theme.of(
              context,
            ).colorScheme.tertiary.withValues(alpha: 0.1),
            child: SizedBox(
              width: 150,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const SizedBox(height: 2),
                    Text(
                      promedioGraduacion.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Promedio",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Graduación",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    buildStarRow(promedioGraduacion.toInt()),
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
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const SizedBox(height: 2),
                    Text(
                      promedioHistorico.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Promedio",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Histórico",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    buildStarRow(promedioHistorico.toInt()),
                  ],
                ),
              ),
            ),
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Rendimiento Academico",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                const Icon(Icons.leaderboard, color: Colors.blue),
              ],
            ),
            const SizedBox(height: 5),
            buildClassesProgressCards(context),
          ],
        ),
      ),
    );
  }
}
