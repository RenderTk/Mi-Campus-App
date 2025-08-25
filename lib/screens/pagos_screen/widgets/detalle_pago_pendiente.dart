import 'package:flutter/material.dart';
import 'package:usap_mobile/models/pago_pendiente.dart';
import 'package:usap_mobile/utils/helper_functions.dart';

class DetallePagoPendiente extends StatelessWidget {
  const DetallePagoPendiente({super.key, required this.pagoPendiente});
  final PagoPendiente pagoPendiente;

  @override
  Widget build(BuildContext context) {
    bool hasMora = (pagoPendiente.detallePago?.mora ?? 0) > 0;
    bool hasDescuentoBeca = (pagoPendiente.detallePago?.beca ?? 0) > 0;
    var base = pagoPendiente.monto ?? 0;
    // descuento mora y suma beca para obtener el monto base
    base -= (pagoPendiente.detallePago?.mora ?? 0);
    base += (pagoPendiente.detallePago?.beca ?? 0);
    final total = pagoPendiente.monto ?? 0;

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
                "L ${formatNumber(base)}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),

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
                  "L +${formatNumber(pagoPendiente.detallePago?.mora ?? 0)}",
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
                  "L -${formatNumber(pagoPendiente.detallePago?.beca ?? 0)}",
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
                "Total a pagar",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                "L ${formatNumber(total)}",
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
