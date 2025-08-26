import 'package:flutter/material.dart';
import 'package:usap_mobile/screens/calificaciones_screen/calificaciones_screen.dart';
import 'package:usap_mobile/screens/horarios_screen/horarios_screen.dart';
import 'package:usap_mobile/screens/materias_screen/materias_screen.dart';
import 'package:usap_mobile/screens/pagos_screen/pagos_screen.dart';

class QuickAccessWidget extends StatelessWidget {
  const QuickAccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildQuickAccessCard(
      String title,
      IconData icon,
      Color iconColor,
      Function()? onTap,
    ) {
      return InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Card(
          color: Theme.of(
            context,
          ).colorScheme.secondaryFixed.withValues(alpha: 0.1),
          margin: const EdgeInsets.all(5),
          child: Container(
            height: 85,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 30, color: iconColor),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
          child: Text(
            'Accesos rápidos',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: buildQuickAccessCard(
                "Horarios",
                Icons.calendar_month_outlined,
                Colors.blue,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HorariosScreen(),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: buildQuickAccessCard(
                "Calificaciones",
                Icons.checklist_outlined,
                Colors.green,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CalificacionesScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: buildQuickAccessCard(
                "Materias",
                Icons.library_books_outlined,
                const Color.fromARGB(255, 206, 188, 26),
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MateriasScreen(),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: buildQuickAccessCard(
                "Pagos",
                Icons.payment_outlined,
                Colors.red,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PagosScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
