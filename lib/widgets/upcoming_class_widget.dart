import 'package:flutter/material.dart';

class UpcomingClassWidget extends StatelessWidget {
  const UpcomingClassWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buidlClassCard() {
      return Card(
        elevation: 5,
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "GEOMETRÍA Y TRIGONOMETRÍA",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "DAE-0702",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  Text(
                    "En 30 min",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "Aula LI-001  2:30PM-4:00PM",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
            child: Text(
              'Proxima Clase',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          buidlClassCard(),
        ],
      ),
    );
  }
}
