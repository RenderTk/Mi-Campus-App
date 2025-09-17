import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_campus_app/models/matricula.dart';
import 'package:mi_campus_app/models/student.dart';
import 'package:mi_campus_app/providers/matricula_provider.dart';
import 'package:mi_campus_app/providers/student_provider.dart';
import 'package:mi_campus_app/screens/materias_correquisito_screen/materias_correquisito_screen.dart';
import 'package:mi_campus_app/screens/materias_screen/widgets/materia_card.dart';
import 'package:mi_campus_app/services/matricula_data_service.dart';
import 'package:mi_campus_app/utils/snackbar_helper.dart';
import 'package:mi_campus_app/widgets/scrollable_segmented_buttons.dart';

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
          .where((entry) => entry.value.estaSeleccionada == true)
          .map((entry) => entry.key)
          .toSet();
    });
  }

  Future<TipoModalidad?> askForTipoModalidadMateriaBase(
    Matricula matricula,
    int index,
  ) async {
    if (matricula.esHibrida && !_selectedIndexes.contains(index)) {
      final selectedModalidad = await _showModalidadPicker(matricula);
      if (selectedModalidad == null) return null;

      return selectedModalidad;
    } else if (matricula.esHibrida) {
      // 1 = presencial
      // 0 = videoconferencia
      return matricula.hibrida == 1
          ? TipoModalidad.presencial
          : TipoModalidad.videoconferencia;
    }
    return null;
  }

  Future<TipoModalidad?> askForTipoModalidadMateriaCorrequisito(
    Matricula matricula,
  ) async {
    if (matricula.esHibrida) {
      final selectedModalidad = await _showModalidadPicker(matricula);
      if (selectedModalidad == null) return null;

      return selectedModalidad;
    }
    return null;
  }

  Future<String?> _addOrRemoveMateria(
    Matricula matricula,
    Student student,
    AccionClase accion,
    TipoModalidad? modalidad,
    bool esDeCorrequisito, {
    String? idSeccion,
    String? idSeccionCorrequisito,
    String? codigoCurso,
    String? codigoCursoCorrequisito,
    TipoModalidad? tipoModalidadCorrequisito,
  }) async {
    //update on server
    final msg = await _matriculaDataService.addClaseOrRemoveClaseFromStudent(
      matricula,
      student.user.id,
      accion,
      modalidad,
      esDeCorrequisito,
      idSeccion: idSeccion,
      idSeccionCorrequisito: idSeccionCorrequisito,
      codigoCurso: codigoCurso,
      codigoCursoCorrequisito: codigoCursoCorrequisito,
      tipoModalidadCorrequisito: tipoModalidadCorrequisito,
    );

    // if there is a message is because something went wrong
    if (msg != null) {
      return msg;
    }

    //update state on provider
    //only if is not correquisito materia
    if (esDeCorrequisito == false) {
      await ref
          .read(matriculaProvider.notifier)
          .addOrRemoveClaseFromStudent(
            matricula,
            accion,
            modalidad,
            matricula.esHibrida,
          );
    }

    return null;
  }

  void onSuccess(int index, Matricula matricula, AccionClase accion) {
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

  Future<void> _onTap(
    Matricula matricula,
    int index,
    AccionClase accion,
  ) async {
    try {
      //load student
      final student = await ref.read(studentProvider.future);
      final selectedModalidad = await askForTipoModalidadMateriaBase(
        matricula,
        index,
      );

      // si la materia no tiene correquisito solo agregamos la materia base
      // o si la accion es quitar solo quitamos la materia base y la correquisito
      // se quita automaticamente
      if (matricula.tieneCorrequisito == false ||
          accion == AccionClase.quitar) {
        // si la materia es hibrida y no se selecciono modalidad
        if (matricula.esHibrida && selectedModalidad == null) {
          return;
        }

        if (!mounted) return;
        //validate cupos on base materia
        if (accion == AccionClase.agregar &&
            !_validateCupos(context, matricula, selectedModalidad)) {
          return;
        }
        final msg = await _addOrRemoveMateria(
          matricula,
          student,
          accion,
          selectedModalidad,
          false,
        );

        // if there is a message is because something went wrong
        if (msg != null) {
          if (!mounted) return;
          SnackbarHelper.showCustomSnackbar(
            context: context,
            message: msg,
            type: SnackbarType.warning,
          );
          return;
        }

        onSuccess(index, matricula, accion);
        return;
      }

      // if matricula have correquisito show correrquisito screen
      if (!mounted) return;
      //validate cupos on base materia
      if (accion == AccionClase.agregar &&
          !_validateCupos(context, matricula, selectedModalidad)) {
        return;
      }
      final matriculaCorrequisito = await Navigator.push<Matricula>(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MateriasCorrequisitoScreen(
              matricula: matricula,
              codigoAlumno: student.user.id,
            );
          },
        ),
      );

      if (matriculaCorrequisito == null) return;

      // ask for modalidad of correquisito materia
      final selectedModalidadCorrequisito =
          await askForTipoModalidadMateriaCorrequisito(matriculaCorrequisito);

      // si la materia correquisito es hibrida y no se selecciono modalidad
      if (matriculaCorrequisito.esHibrida &&
          selectedModalidadCorrequisito == null) {
        return;
      }

      if (!mounted) return;
      //validate cupos on materia correquisito
      if (accion == AccionClase.agregar &&
          !_validateCupos(
            context,
            matriculaCorrequisito,
            selectedModalidadCorrequisito,
          )) {
        return;
      }
      // intenta agregar la correquisito primero
      final msg = await _addOrRemoveMateria(
        matriculaCorrequisito,
        student,
        accion,
        selectedModalidad,
        true,
        idSeccion: matricula.idSeccion.toString(),
        idSeccionCorrequisito: matriculaCorrequisito.idSeccion.toString(),
        codigoCurso: matricula.codigoCurso,
        codigoCursoCorrequisito: matriculaCorrequisito.codigoCurso,
        tipoModalidadCorrequisito: selectedModalidadCorrequisito,
      );

      // if there is a message is because something went wrong
      if (msg != null) {
        if (!mounted) return;
        SnackbarHelper.showCustomSnackbar(
          context: context,
          message: msg,
          type: SnackbarType.warning,
        );
        return;
      }

      await _addOrRemoveMateria(
        matricula,
        student,
        accion,
        selectedModalidad,
        false,
        idSeccion: matricula.idSeccion.toString(),
        idSeccionCorrequisito: matriculaCorrequisito.idSeccion.toString(),
        codigoCurso: matricula.codigoCurso,
        codigoCursoCorrequisito: matriculaCorrequisito.codigoCurso,
        tipoModalidadCorrequisito: selectedModalidadCorrequisito,
      );

      onSuccess(index, matricula, accion);
    } catch (e) {
      if (!mounted) return; // widget was disposed, stop here
      SnackbarHelper.showCustomSnackbar(
        context: context,
        message: "Ocurrio un error al ${accion.name} la clase",
        type: SnackbarType.warning,
      );
    }
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
    final estaPagada = filteredMatriculas.any(
      (matricula) => matricula.estaPagada,
    );

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
                          esDeCorrequisito: false,
                          readOnlyMode: widget.readOnlyMode,
                          estaPagada: estaPagada,
                          onTap: (Matricula matricula) async {
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
