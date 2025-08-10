import 'package:flutter/material.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Calendario", style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
