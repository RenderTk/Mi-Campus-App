import 'package:flutter/material.dart';
import 'package:mi_campus_app/models/historial_pago.dart';
import 'package:mi_campus_app/utils/helper_functions.dart';

class DetalleHistorialPago extends StatelessWidget {
  const DetalleHistorialPago({super.key, required this.historialPago});
  final HistorialPago historialPago;

  @override
  Widget build(BuildContext context) {
    final esTipoPagoDeMatricula = historialPago.descripcionDtl == "MATRICULA";
    double montoBeca = historialPago.montoBecCredito ?? 0;
    double montoMora = historialPago.montoMora ?? 0;

    if (esTipoPagoDeMatricula) {
      final descuentoBecaEnDetalles = (historialPago.detalles.isNotEmpty)
          ? historialPago.detalles
                .map((d) => d.descuentoBeca ?? 0)
                .reduce((a, b) => a + b)
          : 0;

      final moraEnDetalles = (historialPago.detalles.isNotEmpty)
          ? historialPago.detalles
                .map((d) => d.mora ?? 0)
                .reduce((a, b) => a + b)
          : 0;
      montoBeca = montoBeca + descuentoBecaEnDetalles;
      montoMora = montoMora + moraEnDetalles;
    }
    var montoBase = historialPago.montoTotal;
    if (!esTipoPagoDeMatricula && montoBase != null) {
      montoBase += (historialPago.montoBecCredito ?? 0);
    }

    final hasDescuentoBeca = montoBeca > 0;
    final hasMora = montoMora > 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text("Monto base", style: Theme.of(context).textTheme.bodyMedium),
              const Spacer(),
              Text(
                "L ${formatNumber(montoBase ?? 0)}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),

          if (esTipoPagoDeMatricula) ...[
            for (final detalle in historialPago.detalles) ...[
              if (detalle.montoTotal != null && detalle.montoTotal! > 0)
                Row(
                  children: [
                    SizedBox(
                      width: 225,
                      child: Text(
                        customCapitalize(detalle.descripcion),
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "L ${formatNumber(detalle.montoTotal ?? 0)}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
            ],
          ],

          if (hasMora) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  "Mora:",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.red),
                ),
                const Spacer(),
                Text(
                  "L +${formatNumber(montoMora)}",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
          if (hasDescuentoBeca) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  "Descuento beca:",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.green.shade700,
                  ),
                ),
                const Spacer(),
                Text(
                  "L -${formatNumber(montoBeca)}",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
          Divider(height: 16, thickness: 1, color: Colors.grey.shade900),
          Row(
            children: [
              Text(
                "Total",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                "L ${formatNumber(historialPago.monto ?? 0)}",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
