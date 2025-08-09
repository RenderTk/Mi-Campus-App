import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'matricula.g.dart';

@CopyWith()
@JsonSerializable()
class Matricula {
  @JsonKey(name: 'ID_SECCION')
  int? idSeccion;

  @JsonKey(name: 'CODIGO_CURSO')
  String? codigoCurso;

  @JsonKey(name: 'DESCRIPCION_CURSO')
  String? descripcionCurso;

  @JsonKey(name: 'CREDITOS')
  int? creditos;

  @JsonKey(name: 'DIAS')
  String? dias;

  @JsonKey(name: 'INICIO')
  DateTime? inicio;

  @JsonKey(name: 'FIN')
  DateTime? fin;

  @JsonKey(name: 'AULA')
  String? aula;

  @JsonKey(name: 'NUMERO_SECCION')
  int? numeroSeccion;

  @JsonKey(name: 'PERIODO')
  int? periodo;

  @JsonKey(name: 'DISPONIBLE')
  int? cupos;

  @JsonKey(name: 'DISPONIBLE_MODALIDAD')
  int? cuposModalidad;

  @JsonKey(name: 'ID_CONTROL_MATRICULA')
  int? idControlMatricula;

  @JsonKey(name: 'ID_CONTROL_MATRICULA_PI')
  int? idControlMatriculaPI;

  @JsonKey(name: 'ID_PLAN')
  int? idPlan;

  @JsonKey(name: 'ESTATUS_FINANCIERO')
  String? estatusFinanciero;

  @JsonKey(name: 'ESTATUS_ACADEMICO')
  String? estatusAcademico;

  @JsonKey(name: 'HIBRIDA', fromJson: _hibridaFromJson)
  int? hibrida;

  @JsonKey(name: 'NOM_HIBRIDA')
  String? nomHibrida;

  @JsonKey(name: 'CHECKED')
  int? estaSeleccionada;

  @JsonKey(name: 'VALOR')
  double? valor;

  @JsonKey(name: 'VALOR_MODALIDAD')
  double? valorModalidad;

  @JsonKey(name: 'ALIAS')
  String? alias;

  @JsonKey(name: 'NOMBRE_COMPLETO')
  String? nombreCompleto;

  @JsonKey(name: 'GRUPO')
  String? grupo;

  @JsonKey(name: 'OPTATIVA')
  int? optativa;

  @JsonKey(name: 'CORREQUISITOS')
  int? correquisitos;

  @JsonKey(name: 'ID_ESTADO_MODALIDAD')
  int? idEstadoModalidad;

  @JsonKey(name: 'MODALIDAD')
  String? modalidad;

  @JsonKey(name: 'ID_DETALLE_PLAN')
  int? idDetallePlan;

  @JsonKey(name: 'HDR')
  int? hdr;

  @JsonKey(name: 'AUTONOMA')
  int? autonoma;

  @JsonKey(name: 'DEPENDIENTE')
  int? dependiente;

  Matricula({
    this.idSeccion,
    this.codigoCurso,
    this.descripcionCurso,
    this.creditos,
    this.dias,
    this.inicio,
    this.fin,
    this.aula,
    this.numeroSeccion,
    this.periodo,
    this.cupos,
    this.cuposModalidad,
    this.idControlMatricula,
    this.idControlMatriculaPI,
    this.idPlan,
    this.estatusFinanciero,
    this.estatusAcademico,
    this.hibrida,
    this.nomHibrida,
    this.estaSeleccionada,
    this.valor,
    this.valorModalidad,
    this.alias,
    this.nombreCompleto,
    this.grupo,
    this.optativa,
    this.correquisitos,
    this.idEstadoModalidad,
    this.modalidad,
    this.idDetallePlan,
    this.hdr,
    this.autonoma,
    this.dependiente,
  });

  factory Matricula.fromJson(Map<String, dynamic> json) =>
      _$MatriculaFromJson(json);

  Map<String, dynamic> toJson() => _$MatriculaToJson(this);

  static int? _hibridaFromJson(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is bool) return value ? 1 : 0;
    if (value is String) {
      // Just in case they ever send "true"/"false" or "1"/"0"
      if (value.toLowerCase() == 'true') return 1;
      if (value.toLowerCase() == 'false') return 0;
      return int.tryParse(value);
    }
    return null; // fallback for unexpected types
  }

  /// Obtiene los días de la semana sin espacios adicionales
  String? get diasNormalizados => dias?.trim();

  /// Obtiene el aula sin espacios adicionales
  String? get aulaNormalizada => aula?.trim();

  /// Verifica si es un curso HDR (Header/Plan de estudios)
  bool get esHDR => hdr == 1;

  /// Verifica si es una materia optativa
  bool get esOptativa => optativa == 1;

  /// Verifica si tiene correquisitos
  bool get tieneCorrequisitos => correquisitos == 1;

  /// Verifica si hay cupos disponibles
  bool get tieneCupos => (cupos ?? 0) > 0;

  /// Verifica si hay cupos disponibles en modalidad
  bool get tieneCuposModalidad => (cuposModalidad ?? 0) > 0;

  /// Verifica si es modalidad presencial
  bool get esPresencial => modalidad == 'PRESENCIAL';

  /// Verifica si es por videoconferencia
  bool get esVirtual => modalidad == 'POR VIDEOCONFERENCIA';

  /// Verifica si es modalidad híbrida
  bool get esHibrida => modalidad == 'HIBRIDA';

  bool get presencialSeleccionada => hibrida == 1;

  bool get videoconferenciaSeleccionada => hibrida == 0;

  /// Obtiene una representación legible del horario

  String? get horarioCompleto {
    if (inicio != null && fin != null) {
      final formato = DateFormat('hh:mm a'); // Formato 12h con AM/PM
      final inicioStr = formato.format(inicio!);
      final finStr = formato.format(fin!);
      return '$inicioStr - $finStr';
    }
    return null;
  }

  /// Convierte los días abreviados a lista de días completos
  List<String> get diasDeLaSemana {
    if (dias == null || dias!.isEmpty) return [];

    final diasAbrev = dias!.split('-');
    final Map<String, String> conversion = {
      'L': 'Lunes',
      'M': 'Miércoles',
      'J': 'Jueves',
      'V': 'Viernes',
      'S': 'Sábado',
      'D': 'Domingo',
      'K': 'Martes', // Parece ser otra forma de Martes en el JSON
    };

    return diasAbrev
        .map((dia) => conversion[dia.trim().toUpperCase()] ?? dia)
        .toList();
  }

  /// Obtiene el próximo día de clase
  DateTime? get proximaFechaClase {
    if (inicio == null || diasDeLaSemana.isEmpty) return null;

    final ahora = DateTime.now();
    final diasSemana = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];

    // Encontrar el próximo día de clase
    for (int i = 0; i < 7; i++) {
      final fechaFutura = ahora.add(Duration(days: i));
      final diaSemana = diasSemana[fechaFutura.weekday - 1];

      if (diasDeLaSemana.contains(diaSemana)) {
        // Crear la fecha con la hora de inicio
        final fechaClase = DateTime(
          fechaFutura.year,
          fechaFutura.month,
          fechaFutura.day,
          inicio!.hour,
          inicio!.minute,
        );

        // Si es hoy, verificar que no haya pasado la hora
        if (i == 0 && ahora.isAfter(fechaClase)) {
          continue;
        }

        return fechaClase;
      }
    }

    return null;
  }

  /// Obtiene información del profesor sin espacios adicionales
  String? get profesorNormalizado => nombreCompleto?.trim();

  /// Verifica si tiene profesor asignado
  bool get tieneProfesorAsignado =>
      nombreCompleto != null &&
      nombreCompleto!.isNotEmpty &&
      !nombreCompleto!.contains('SIN ASIGNAR');

  /// Obtiene el valor a pagar (prioriza valor_modalidad si existe)
  double? get valorAPagar => valorModalidad ?? valor;

  /// Métodos helper estáticos

  /// 1. Filtra solo los cursos que no son HDR (cursos reales)
  static List<Matricula> filtrarCursosReales(List<Matricula> secciones) {
    return secciones.where((seccion) => !seccion.esHDR).toList();
  }

  /// 4. Encuentra la próxima clase más cercana
  static Matricula? obtenerProximaClase(List<Matricula> secciones) {
    final cursosReales = filtrarCursosReales(secciones);
    if (cursosReales.isEmpty) return null;

    final ahora = DateTime.now();
    Matricula? proximaClase;
    DateTime? fechaMasCercana;

    for (final seccion in cursosReales) {
      final fechaClase = seccion.proximaFechaClase;
      if (fechaClase == null) continue;

      if (fechaClase.isAfter(ahora)) {
        if (fechaMasCercana == null || fechaClase.isBefore(fechaMasCercana)) {
          fechaMasCercana = fechaClase;
          proximaClase = seccion;
        }
      }
    }

    return proximaClase;
  }

  /// 5. Calcula el tiempo restante hasta la próxima clase
  static String calcularTiempoRestante(Matricula seccion) {
    final fechaClase = seccion.proximaFechaClase;
    if (fechaClase == null) {
      return "Fecha no disponible";
    }

    final ahora = DateTime.now();
    final diferencia = fechaClase.difference(ahora);

    if (diferencia.isNegative) {
      return "Clase iniciada";
    }

    final totalMinutos = diferencia.inMinutes;
    final totalHoras = diferencia.inHours;
    final dias = diferencia.inDays;

    if (dias > 0) {
      return "En ${dias}d";
    } else if (totalHoras > 0) {
      final minutosRestantes = totalMinutos - (totalHoras * 60);
      return "En ${totalHoras}h ${minutosRestantes}min";
    } else {
      return "En ${totalMinutos}min";
    }
  }

  /// 8. Obtiene información completa de la próxima clase
  static Map<String, dynamic>? obtenerInfoProximaClase(
    List<Matricula> secciones,
  ) {
    final proximaClase = obtenerProximaClase(secciones);
    if (proximaClase == null) return null;

    return {
      'seccion': proximaClase,
      'tiempoRestante': calcularTiempoRestante(proximaClase),
      'fechaClase': proximaClase.proximaFechaClase,
      'profesor': proximaClase.profesorNormalizado,
      'aula': proximaClase.aulaNormalizada,
      'modalidad': proximaClase.modalidad,
    };
  }

  /// 9. Filtra por modalidad específica
  static List<Matricula> filtrarPorModalidad(
    List<Matricula> secciones,
    String modalidad,
  ) {
    return secciones
        .where(
          (seccion) =>
              seccion.modalidad?.toLowerCase() == modalidad.toLowerCase(),
        )
        .toList();
  }

  static List<List<Matricula>> agruparPorPeriodo(List<Matricula> secciones) {
    final List<List<Matricula>> grupos = [];
    final periodos = secciones
        .map((seccion) => seccion.periodo)
        .toSet()
        .toList();

    for (final periodo in periodos) {
      final seccionesClase = secciones
          .where((seccion) => seccion.periodo == periodo)
          .toList();
      grupos.add(seccionesClase);
    }
    return grupos;
  }

  static List<List<Matricula>> agruparPorClase(List<Matricula> secciones) {
    final List<List<Matricula>> grupos = [];
    final clasesNombres = secciones
        .map((seccion) => seccion.descripcionCurso)
        .toSet()
        .toList();

    for (final clase in clasesNombres) {
      final seccionesClase = secciones
          .where((seccion) => seccion.descripcionCurso == clase)
          .toList();
      grupos.add(seccionesClase);
    }
    return grupos;
  }
}
