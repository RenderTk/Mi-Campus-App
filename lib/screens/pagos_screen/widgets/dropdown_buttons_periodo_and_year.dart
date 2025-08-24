import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

final periodos = ["Todos", "Periodo 1", "Periodo 2", "Periodo 3"];

class DropdownButtonsPeriodoAndYear extends StatelessWidget {
  const DropdownButtonsPeriodoAndYear({
    super.key,
    required this.selectedPeriodo,
    required this.selectedAno,
    required this.onPeriodoChanged,
    required this.onYearChanged,
  });
  final int? selectedPeriodo;
  final int? selectedAno;
  final ValueChanged<int?>? onPeriodoChanged;
  final ValueChanged<int?>? onYearChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: DropdownButtonFormField2(
            value: selectedPeriodo,
            validator: (value) {
              if (value == null) {
                return "Selecciona un periodo";
              }
              return null;
            },
            onChanged: onPeriodoChanged,
            hint: Text(
              'Periodo',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            isDense: true,
            items: List.generate(
              periodos.length,
              (index) => DropdownMenuItem(
                value: index,
                child: Text(
                  periodos[index],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField2(
            value: selectedAno,
            onChanged: onYearChanged,
            hint: Text('Año', style: Theme.of(context).textTheme.bodyMedium),
            validator: (value) {
              if (value == null) {
                return "Selecciona un año";
              }
              return null;
            },
            dropdownStyleData: DropdownStyleData(
              maxHeight: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            items: [
              for (int i = 2025; i >= 2010; i--)
                DropdownMenuItem(
                  value: i,
                  child: Text(
                    'Año $i',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
