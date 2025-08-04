import 'package:flutter/material.dart';

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
          elevation: 5,
          margin: const EdgeInsets.all(8),
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
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: buildQuickAccessCard(
                "Horarios",
                Icons.calendar_month_outlined,
                Colors.blue,
                () {},
              ),
            ),
            Expanded(
              child: buildQuickAccessCard(
                "Calificaciones",
                Icons.checklist_outlined,
                Colors.green,
                () {},
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: buildQuickAccessCard(
                "Materias",
                Icons.library_books_outlined,
                const Color.fromARGB(255, 206, 188, 26),
                () {},
              ),
            ),
            Expanded(
              child: buildQuickAccessCard(
                "Pagos",
                Icons.payment_outlined,
                Colors.red,
                () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}
