import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:usap_mobile/providers/historial_pago_provider.dart';
import 'package:usap_mobile/screens/pagos_screen/widgets/dropdown_buttons_periodo_and_year.dart';
import 'package:usap_mobile/utils/helper_functions.dart';

class HistorialPagosFilters extends ConsumerStatefulWidget {
  const HistorialPagosFilters({super.key});

  @override
  ConsumerState<HistorialPagosFilters> createState() =>
      _HistorialPagosFiltersState();
}

class _HistorialPagosFiltersState extends ConsumerState<HistorialPagosFilters> {
  final _form = GlobalKey<FormState>();
  int? selectedPeriodo;
  int? selectedAno;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        children: [
          DropdownButtonsPeriodoAndYear(
            selectedPeriodo: selectedPeriodo,
            selectedAno: selectedAno,
            onPeriodoChanged: (value) {
              setState(() {
                selectedPeriodo = value ?? 0;
              });
            },
            onYearChanged: (value) {
              setState(() {
                selectedAno = value ?? 0;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Historial Pagos",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () async {
                    if (!_form.currentState!.validate()) {
                      return;
                    }

                    final fechas = getSemesterDateRange(
                      selectedPeriodo ?? 0,
                      selectedAno ?? 0,
                    );
                    await ref
                        .read(historialPagosProvider.notifier)
                        .refetchByDates(
                          fechas["fechaInicio"]!,
                          fechas["fechaFinal"]!,
                        );
                  },
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
