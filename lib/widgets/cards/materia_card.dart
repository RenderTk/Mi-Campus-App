import 'package:flutter/material.dart';
import 'package:usap_mobile/models/matricula.dart';
import 'package:usap_mobile/widgets/labeled_badge.dart';

class MateriaCard extends StatefulWidget {
  const MateriaCard({
    super.key,
    required this.matricula,
    required this.isSelected,
    required this.onTap,
  });
  final Matricula matricula;
  final bool isSelected;
  final Future<void> Function() onTap;

  @override
  State<MateriaCard> createState() => _MateriaCardState();
}

class _MateriaCardState extends State<MateriaCard> {
  bool isLoading = false;

  Widget _buildButtonAgregarOQuitarClase(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        width: 25,
        height: 25,
        child: CircularProgressIndicator(),
      );
    }
    return IconButton(
      padding: EdgeInsets.zero,
      alignment: Alignment.topRight,
      visualDensity: VisualDensity.compact,
      // removes internal padding
      constraints: const BoxConstraints(
        maxHeight: 35,
        maxWidth: 35,
      ), // removes min size (48x48)
      onPressed: () async {
        try {
          setState(() {
            isLoading = true;
          });
          await widget.onTap();
        } finally {
          setState(() {
            isLoading = false;
          });
        }
      },
      icon: Icon(
        widget.isSelected ? Icons.check_box : Icons.check_box_outline_blank,
        size: 35,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildClassTitle(BuildContext context, Matricula matricula) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Fixed width so alignment of other Row children is stable
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              matricula.descripcionCurso ?? "",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "${matricula.codigoCurso} - Sección ${matricula.numeroSeccion.toString()}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const Spacer(),
        if (widget.isSelected && matricula.esHibrida) ...[
          Icon(
            matricula.presencialSeleccionada ? Icons.group : Icons.videocam,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 5),
        ],

        _buildButtonAgregarOQuitarClase(context),
      ],
    );
  }

  Widget _buildUVandDays(BuildContext context, Matricula matricula) {
    return Row(
      children: [
        const Icon(Icons.school, size: 15),
        const SizedBox(width: 5),
        Text(
          "UV: ${matricula.creditos.toString()}",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const Spacer(),
        const Icon(Icons.location_on, size: 15),
        const SizedBox(width: 5),
        Text(
          matricula.aula ?? "",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildTimeAndAula(BuildContext context, Matricula matricula) {
    return Row(
      children: [
        const Icon(Icons.access_time, size: 15),
        const SizedBox(width: 5),
        Text(
          matricula.horarioCompleto ?? "",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const Spacer(),
        const Icon(Icons.calendar_today, size: 15),
        const SizedBox(width: 5),
        Text(
          matricula.diasDeLaSemana.join(", "),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildProfesorName(BuildContext context, Matricula matricula) {
    return Row(
      children: [
        const Icon(Icons.person, size: 15),
        const SizedBox(width: 5),
        Text(
          matricula.profesorNormalizado ?? "",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildCuponesWidgetWhenHibrida(Matricula matricula) {
    final Color cuponColor = matricula.cupos == 0
        ? Colors.red
        : matricula.cupos! <= 5
        ? Colors.orange
        : Colors.green;
    final Color cuponPresencialColor = matricula.cuposModalidad == 0
        ? Colors.red
        : matricula.cuposModalidad! <= 5
        ? Colors.orange
        : Colors.green;

    return Row(
      children: [
        LabeledBadge(
          msg: matricula.cuposModalidad.toString(),
          foregroundColor: cuponPresencialColor,
          backgroundColor: cuponPresencialColor,
          icon: Icons.group,
          iconSize: 15,
        ),
        const SizedBox(width: 5),
        LabeledBadge(
          msg: matricula.cupos.toString(),
          foregroundColor: cuponColor,
          backgroundColor: cuponColor,
          icon: Icons.videocam,
          iconSize: 15,
        ),
      ],
    );
  }

  Widget _buildModalidadAndCupos(Matricula matricula) {
    late Icon modalidadIcon;
    late Color modalidadColor;
    if (matricula.modalidad?.toLowerCase() == "presencial") {
      modalidadIcon = const Icon(Icons.people, size: 15);
      modalidadColor = Colors.green;
    }
    if (matricula.modalidad?.toLowerCase() == "por videoconferencia" ||
        matricula.modalidad?.toLowerCase() == "virtual") {
      modalidadIcon = const Icon(Icons.videocam, size: 15);
      modalidadColor = Colors.purple;
    }
    if (matricula.modalidad?.toLowerCase() == "hibrida") {
      modalidadIcon = const Icon(Icons.swap_horiz, size: 15);
      modalidadColor = Colors.blue;
    }

    final Color cuponColor = matricula.cupos == 0
        ? Colors.red
        : matricula.cupos! <= 5
        ? Colors.orange
        : Colors.green;

    return Row(
      children: [
        LabeledBadge(
          msg: matricula.modalidad ?? "",
          foregroundColor: modalidadColor,
          backgroundColor: modalidadColor,
          icon: modalidadIcon.icon,
          iconSize: 15,
        ),
        const Spacer(),
        if (matricula.esHibrida)
          _buildCuponesWidgetWhenHibrida(matricula)
        else
          LabeledBadge(
            msg: "Cupos: ${matricula.cupos.toString()}",
            foregroundColor: cuponColor,
            backgroundColor: cuponColor,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(
        context,
      ).colorScheme.secondaryFixed.withValues(alpha: 0.1),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: widget.isSelected
              ? Border.all(
                  color: const Color.fromARGB(255, 40, 132, 231),
                  width: 4.0,
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildClassTitle(context, widget.matricula),
            const SizedBox(height: 5),
            _buildUVandDays(context, widget.matricula),
            const SizedBox(height: 10),
            _buildTimeAndAula(context, widget.matricula),
            const SizedBox(height: 10),
            _buildProfesorName(context, widget.matricula),
            const SizedBox(height: 2),
            Divider(
              thickness: 1,
              color: Theme.of(
                context,
              ).colorScheme.tertiary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 2),
            _buildModalidadAndCupos(widget.matricula),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
