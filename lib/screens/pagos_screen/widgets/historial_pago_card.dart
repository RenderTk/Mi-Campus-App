import 'package:flutter/material.dart';
import 'package:mi_campus_app/models/historial_pago.dart';
import 'package:mi_campus_app/screens/pagos_screen/widgets/detalle_historial_pago.dart';
import 'package:mi_campus_app/utils/helper_functions.dart';
import 'package:mi_campus_app/widgets/labeled_badge.dart';

class HistorialPagoCard extends StatelessWidget {
  const HistorialPagoCard({super.key, required this.historialPago});
  final HistorialPago historialPago;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(
        context,
      ).colorScheme.secondaryFixed.withValues(alpha: 0.1),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(
                context,
              ).colorScheme.secondaryFixed.withValues(alpha: 0.1),
              Theme.of(
                context,
              ).colorScheme.secondaryFixed.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with invoice and status
            Row(
              children: [
                Icon(
                  Icons.receipt_long,
                  color: Theme.of(context).colorScheme.primary,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  "Factura #${historialPago.idFactura}",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w900),
                ),
                const Spacer(),
                const LabeledBadge(
                  msg: "Pagado",
                  foregroundColor: Colors.green,
                  backgroundColor: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Description
            SizedBox(
              width: double.infinity,
              child: Text(
                customCapitalize(historialPago.descripcion ?? ""),
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 16),
            // Amount details
            DetalleHistorialPago(historialPago: historialPago),

            const SizedBox(height: 16),
            // Footer with dates and reference
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 6),
                Text(
                  "Procesado: ${historialPago.fechaAmigable}",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const Spacer(),
                Text(
                  "# REF: ${historialPago.referencia1}",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
