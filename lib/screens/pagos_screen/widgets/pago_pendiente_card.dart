import 'package:flutter/material.dart';
import 'package:mi_campus_app/models/pago_pendiente.dart';
import 'package:mi_campus_app/screens/pagos_screen/widgets/detalle_pago_pendiente.dart';
import 'package:mi_campus_app/widgets/labeled_badge.dart';

String getMsgEstatusPago(PagoPendiente pagoPendiente) {
  if (pagoPendiente.venceHoy) {
    return "Vence hoy";
  }
  if (pagoPendiente.estaVencido) {
    return "Vencido hace ${pagoPendiente.diasRestantes * -1} días";
  }

  if (pagoPendiente.venceEnProximosDias(1)) {
    return "Vence mañana";
  }

  return "Vence en ${pagoPendiente.diasRestantes} días";
}

Color getColorEstatusPago(PagoPendiente pagoPendiente) {
  if (pagoPendiente.estaVencido) {
    return Colors.red;
  }
  if (pagoPendiente.venceHoy) {
    return Colors.yellow;
  }

  if (pagoPendiente.venceEnProximosDias(1)) {
    return Colors.orange;
  }

  return Colors.blueAccent;
}

class PagoPendienteCard extends StatelessWidget {
  const PagoPendienteCard({super.key, required this.pagoPendiente});
  final PagoPendiente pagoPendiente;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(
        context,
      ).colorScheme.secondaryFixed.withValues(alpha: 0.1),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.secondaryFixed.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(
              color: getColorEstatusPago(pagoPendiente),
              width: 4, // border thickness
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with invoice and status
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.primary,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  "#${pagoPendiente.idFactura}",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Spacer(),
                LabeledBadge(
                  msg: getMsgEstatusPago(pagoPendiente),
                  backgroundColor: getColorEstatusPago(pagoPendiente),
                  foregroundColor: getColorEstatusPago(pagoPendiente),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.school,
                  color: Theme.of(context).colorScheme.primary,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    pagoPendiente.descripcionNormalizada ?? "Sin descripción",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            DetallePagoPendiente(pagoPendiente: pagoPendiente),
          ],
        ),
      ),
    );
  }
}
