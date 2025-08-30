import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/models/matricula.dart';
import 'package:usap_mobile/providers/matricula_provider.dart';
import 'package:usap_mobile/providers/student_provider.dart';
import 'package:usap_mobile/services/matricula_data_service.dart';
import 'package:usap_mobile/utils/snackbar_helper.dart';
import 'package:usap_mobile/screens/materias_screen/widgets/materia_card.dart';
import 'package:usap_mobile/widgets/scrollable_segmented_buttons.dart';

class MateriasDetailScreen extends ConsumerStatefulWidget {
  const MateriasDetailScreen({
    super.key,
    required this.matriculas,
    required this.readOnlyMode,
  });
  final List<Matricula> matriculas;
  final bool readOnlyMode;

  @override
  ConsumerState<MateriasDetailScreen> createState() =>
      _MateriasDetailScreenState();
}

class _MateriasDetailScreenState extends ConsumerState<MateriasDetailScreen> {
  final MatriculaDataService _matriculaDataService = MatriculaDataService();
  Set<int> _selectedIndexes = {};
  String _selectedModalidad = 'Todas';

  @override
  void initState() {
    super.initState();
    _searchSelectedMaterias();
  }

  Future<TipoModalidad?> _showModalidadPicker(Matricula matricula) async {
    return await showDialog<TipoModalidad>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.school, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              const Expanded(child: Text('Seleccionar modalidad')),
              IconButton(
                onPressed: () => Navigator.pop(context, null),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Presencial
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Icon(Icons.groups, color: Colors.blue.shade700),
                  ),
                  title: const Text(
                    'Presencial',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${matricula.cuposModalidad} cupos disponibles',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Navigator.pop(context, TipoModalidad.presencial),
                ),
              ),
              const SizedBox(height: 12),
              // Videoconferencia
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.purple.shade100,
                    child: Icon(Icons.videocam, color: Colors.purple.shade700),
                  ),
                  title: const Text(
                    'Videoconferencia',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('${matricula.cupos} cupos disponibles'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () =>
                      Navigator.pop(context, TipoModalidad.videoconferencia),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _searchSelectedMaterias() {
    setState(() {
      _selectedIndexes = widget.matriculas
          .asMap()
          .entries
          .where((entry) => (entry.value.estaSeleccionada ?? 0) != 0)
          .map((entry) => entry.key)
          .toSet();
    });
  }

  Future<void> _onTap(
    Matricula matricula,
    int index,
    AccionClase accion,
  ) async {
    TipoModalidad? selectedModalidad;
    try {
      if (matricula.esHibrida && !_selectedIndexes.contains(index)) {
        selectedModalidad = await _showModalidadPicker(matricula);
        if (selectedModalidad == null) return;
      } else if (matricula.esHibrida) {
        // 1 = presencial
        // 0 = videoconferencia
        selectedModalidad = matricula.hibrida == 1
            ? TipoModalidad.presencial
            : TipoModalidad.videoconferencia;
      }

      if (!mounted) return; // widget was disposed, stop here

      // validate cupos before try to add
      if (accion == AccionClase.agregar &&
          !_validateCupos(context, matricula, selectedModalidad)) {
        return;
      }

      final student = await ref.read(studentProvider.future);

      //update on server
      final msg = await _matriculaDataService.addClaseOrRemoveClaseFromStudent(
        matricula,
        student.user.id,
        accion,
        selectedModalidad,
      );

      // if there is a message is because something went wrong
      if (msg != null) {
        if (!mounted) return; // widget was disposed, stop here
        SnackbarHelper.showCustomSnackbar(
          context: context,
          message: msg,
          type: SnackbarType.warning,
        );
        return;
      }

      //update state on provider
      await ref
          .read(matriculaProvider.notifier)
          .addOrRemoveClaseFromStudent(
            matricula,
            accion,
            selectedModalidad,
            matricula.esHibrida,
          );
    } catch (e) {
      if (!mounted) return; // widget was disposed, stop here
      SnackbarHelper.showCustomSnackbar(
        context: context,
        message: "Ocurrio un error al ${accion.name} la clase",
        type: SnackbarType.warning,
      );
      return;
    }

    //update the state if nothing went wrong
    setState(() {
      if (_selectedIndexes.contains(index)) {
        _selectedIndexes.remove(index);
      } else {
        _selectedIndexes.add(index);
      }

      SnackbarHelper.showCustomSnackbar(
        context: context,
        message:
            "${matricula.descripcionCurso} a sido ${accion == AccionClase.agregar ? "agregada" : "quitada"} con exito",
        type: SnackbarType.success,
      );
    });
  }

  bool _validateCupos(
    BuildContext context,
    Matricula matricula,
    TipoModalidad? modalidad,
  ) {
    if (!matricula.esHibrida && matricula.cupos == 0) {
      SnackbarHelper.showCustomSnackbar(
        context: context,
        message: "No hay cupos disponibles",
        type: SnackbarType.warning,
      );
      return false;
    }

    if (modalidad == TipoModalidad.presencial &&
        matricula.cuposModalidad == 0) {
      SnackbarHelper.showCustomSnackbar(
        context: context,
        message: "No hay cupos disponibles",
        type: SnackbarType.warning,
      );
      return false;
    }

    if (modalidad == TipoModalidad.videoconferencia && matricula.cupos == 0) {
      SnackbarHelper.showCustomSnackbar(
        context: context,
        message: "No hay cupos disponibles",
        type: SnackbarType.warning,
      );
      return false;
    }

    return true;
  }

  List<Matricula> _getFilteredMatriculas() {
    if (_selectedModalidad == "Todas") return widget.matriculas;

    if (_selectedModalidad == "Presencial") {
      return widget.matriculas
          .where((matricula) => matricula.modalidad == "PRESENCIAL")
          .toList();
    }

    if (_selectedModalidad == "Videoconferencia") {
      return widget.matriculas
          .where((matricula) => matricula.modalidad == "POR VIDEOCONFERENCIA")
          .toList();
    }

    if (_selectedModalidad == "Virtual") {
      return widget.matriculas
          .where((matricula) => matricula.modalidad == "VIRTUAL")
          .toList();
    }

    return widget.matriculas
        .where((matricula) => matricula.modalidad == "HIBRIDA")
        .toList();
  }

  Widget _buildModalidadesFilter() {
    return ScrollableSegmentedButtons(
      options: const [
        "Todas",
        "Hibrida",
        "Presencial",
        "Videoconferencia",
        "Virtual",
      ],
      onSelected: (selectedModalidad) {
        setState(() {
          _selectedModalidad = selectedModalidad;
        });
      },
      selected: _selectedModalidad,
    );
  }

  @override
  Widget build(BuildContext context) {
    final firstMatricula = widget.matriculas[0];
    final filteredMatriculas = _getFilteredMatriculas();
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              firstMatricula.descripcionCurso ?? "Matricula",
              overflow: TextOverflow.ellipsis,
            ),
            if (widget.readOnlyMode)
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Modo Lectura",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.lock, size: 16, color: Colors.grey),
                ],
              ),
          ],
        ),
      ),
      body: filteredMatriculas.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: Column(
                children: [
                  _buildModalidadesFilter(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredMatriculas.length,
                      itemBuilder: (BuildContext context, int index) {
                        final matricula = filteredMatriculas[index];
                        return MateriaCard(
                          matricula: matricula,
                          isSelected: _selectedIndexes.contains(index),
                          readOnlyMode: widget.readOnlyMode,
                          onTap: () async {
                            // an item is already selected, and it is not the selected item
                            if (_selectedIndexes.isNotEmpty &&
                                !_selectedIndexes.contains(index)) {
                              SnackbarHelper.showCustomSnackbar(
                                context: context,
                                message: "Ya tienes esta clase seleccionada.",
                                type: SnackbarType.warning,
                              );
                              return;
                            }
                            final AccionClase accion =
                                _selectedIndexes.contains(index)
                                ? AccionClase.quitar
                                : AccionClase.agregar;
                            await _onTap(matricula, index, accion);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                _buildModalidadesFilter(),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.school,
                          size: 100,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "No hay clases disponibles",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomSheet: SafeArea(
        child: Container(
          height: 50,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          alignment: Alignment.topCenter,
          child: Text(
            "Total de clases: ${filteredMatriculas.length}",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
