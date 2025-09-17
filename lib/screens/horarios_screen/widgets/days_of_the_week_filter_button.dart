import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mi_campus_app/providers/selected_day_of_the_week_provider.dart';

class DaysOfTheWeekFilterButton extends ConsumerWidget {
  const DaysOfTheWeekFilterButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<DayOfTheWeek>(
      onSelected: (day) {
        ref.read(selectedDayOfTheWeekProvider.notifier).selectDay(day);
      },
      icon: const Icon(FontAwesomeIcons.filter),
      borderRadius: BorderRadius.circular(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.grey, width: 0.5),
      ),
      color: Theme.of(context).scaffoldBackgroundColor,
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: DayOfTheWeek.todos,
            child: Text("Todos los dias"),
          ),
          const PopupMenuItem(value: DayOfTheWeek.lunes, child: Text("Lunes")),
          const PopupMenuItem(
            value: DayOfTheWeek.martes,
            child: Text("Martes"),
          ),
          const PopupMenuItem(
            value: DayOfTheWeek.miercoles,
            child: Text("Miercoles"),
          ),
          const PopupMenuItem(
            value: DayOfTheWeek.jueves,
            child: Text("Jueves"),
          ),
          const PopupMenuItem(
            value: DayOfTheWeek.viernes,
            child: Text("Viernes"),
          ),
          const PopupMenuItem(
            value: DayOfTheWeek.sabado,
            child: Text("Sabado"),
          ),
          const PopupMenuItem(
            value: DayOfTheWeek.domingo,
            child: Text("Domingo"),
          ),
        ];
      },
    );
  }
}
