import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:usap_mobile/models/seccion_curso.dart';
import 'package:usap_mobile/utils/helper_functions.dart';
import 'package:usap_mobile/widgets/labeled_badge.dart';

class HorarioCard extends StatelessWidget {
  const HorarioCard({
    super.key,
    required this.seccion,
    required this.diasQueAplica,
  });
  final SeccionCurso seccion;
  final List<String> diasQueAplica;

  @override
  Widget build(BuildContext context) {
    Widget buildClassNameText(SeccionCurso seccion) {
      return Row(
        children: [
          SizedBox(
            width: 260,
            child: Text(
              customCapitalize(seccion.descripcionCurso ?? ""),

              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const Spacer(),
          LabeledBadge(
            msg: seccion.estado?.trim() ?? "",
            backgroundColor: Colors.green,
            foregroundColor: Colors.green,
          ),
        ],
      );
    }

    Widget buildDaysText(
      SeccionCurso seccion,
      List<String> dias,
      String tiempoRestante,
    ) {
      return Row(
        children: [
          const Icon(Icons.calendar_month, size: 20),
          const SizedBox(width: 10),
          LabeledBadge(
            msg: dias[0],
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.deepPurple,
          ), //buildTextOnContainer(dias[0], Colors.deepPurple, Colors.deepPurple),
          if (dias.length > 1) ...[
            const SizedBox(width: 5),
            LabeledBadge(
              msg: dias[1],
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.deepPurple,
            ), //buildTextOnContainer(dias[1], Colors.deepPurple, Colors.deepPurple),
          ],
          const Spacer(),
          LabeledBadge(
            msg: tiempoRestante,
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.deepPurple,
          ),
        ],
      );
    }

    Widget buildClassCodeAndClassTime(SeccionCurso seccion) {
      return Row(
        children: [
          const Icon(Icons.location_on, size: 20),
          const SizedBox(width: 10),
          Text(
            "Aula ${seccion.aula?.trim()}",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Spacer(),
          const Icon(Icons.timer, size: 20),
          const SizedBox(width: 10),
          Text(
            "${seccion.inicio} - ${seccion.fin}",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      );
    }

    Widget buildClassModeAndClassLink(SeccionCurso seccion) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LabeledBadge(
            msg: seccion.grupo?.trim() ?? "",
            backgroundColor: Colors.red,
            foregroundColor: Colors.red,
          ),
          const Spacer(),
          InkWell(
            onTap: () async {
              await launchUrl(
                Uri.parse(seccion.url ?? ""),
                mode:
                    LaunchMode.externalApplication, // Opens in external browser
              );
            },
            child: const LabeledBadge(
              msg: "Enlace del curso",
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.blueAccent,
              icon: Icons.link,
            ),
          ),
        ],
      );
    }

    final tiempoRestante = SeccionCurso.calcularTiempoRestante(seccion);
    return Card(
      color: Theme.of(
        context,
      ).colorScheme.secondaryFixed.withValues(alpha: 0.1),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildClassNameText(seccion),
            const SizedBox(height: 5),
            Text(
              "${seccion.codigoCurso} - Seccion ${seccion.numeroSeccion}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            buildDaysText(seccion, diasQueAplica, tiempoRestante),
            const SizedBox(height: 10),
            buildClassCodeAndClassTime(seccion),
            const SizedBox(height: 12),
            buildClassModeAndClassLink(seccion),
          ],
        ),
      ),
    );
  }
}
