import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DayOfTheWeek {
  todos,
  lunes,
  martes,
  miercoles,
  jueves,
  viernes,
  sabado,
  domingo,
}

class SelectedDayOfTheWeekNotifier extends Notifier<DayOfTheWeek> {
  @override
  DayOfTheWeek build() => DayOfTheWeek.todos;

  void selectDay(DayOfTheWeek day) => state = day;
}

final selectedDayOfTheWeekProvider =
    NotifierProvider<SelectedDayOfTheWeekNotifier, DayOfTheWeek>(
      SelectedDayOfTheWeekNotifier.new,
    );
