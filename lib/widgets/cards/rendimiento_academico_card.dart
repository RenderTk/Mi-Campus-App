import 'package:flutter/material.dart';

class RendimientoAcademicoCard extends StatelessWidget {
  const RendimientoAcademicoCard({
    super.key,
    required this.puntosCoprogramaticos,
    required this.promedioGeneral,
  });
  final int puntosCoprogramaticos;
  final double promedioGeneral;

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
            color: Colors.green.withValues(alpha: 0.1),
            child: SizedBox(
              width: 150,
              height: 120,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const Icon(Icons.workspace_premium, color: Colors.green),
                    const SizedBox(height: 2),
                    Text(
                      puntosCoprogramaticos.toString(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Puntos",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Coprogramaticos",
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
              height: 120,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const SizedBox(height: 2),
                    Text(
                      promedioGeneral.toStringAsFixed(0),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Promedio",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "General",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    buildStarRow(promedioGeneral.toInt()),
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
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Rendimiento Academico",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                const Icon(Icons.leaderboard, color: Colors.blue),
              ],
            ),
            const SizedBox(height: 15),
            buildClassesProgressCards(context),
          ],
        ),
      ),
    );
  }
}
