import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'calificacion_curso.g.dart';

enum EstatusCalificacion { aprobada, reprobada, cursando, retiro }

@CopyWith()
@JsonSerializable()
class CalificacionCurso {
  @JsonKey(name: 'ANIO')
  String anio;

  @JsonKey(name: 'PERIODO')
  String periodo;

  @JsonKey(name: 'CODIGO_CURSO')
  String codigoCurso;

  @JsonKey(name: 'DESCRIPCION_CURSO')
  String descripcionCurso;

  @JsonKey(name: 'ESTATUS', fromJson: getEstatusClase)
  EstatusCalificacion estatus;

  @JsonKey(name: 'NOTA')
  int? nota;

  @JsonKey(name: 'DIAS')
  String? dias;

  @JsonKey(name: 'INICIO')
  String? inicio;

  @JsonKey(name: 'FIN')
  String? fin;

  @JsonKey(name: 'CATEDRATICO')
  String? catedratico;

  @JsonKey(name: 'ETIQUETA')
  String? etiqueta;

  CalificacionCurso({
    required this.anio,
    required this.periodo,
    required this.codigoCurso,
    required this.descripcionCurso,
    required this.estatus,
    required this.nota,
    required this.dias,
    required this.inicio,
    required this.fin,
    required this.catedratico,
    required this.etiqueta,
  });

  factory CalificacionCurso.fromJson(Map<String, dynamic> json) =>
      _$CalificacionCursoFromJson(json);

  Map<String, dynamic> toJson() => _$CalificacionCursoToJson(this);

  /// Formato legible del horario
  String get horario => "$inicio - $fin";

  /// Devuelve si el curso está aprobado
  bool get estaAprobado => estatus == EstatusCalificacion.aprobada;

  /// Normaliza días
  String? get diasNormalizado => dias?.trim();

  /// Convierte los días abreviados a lista de días completos
  List<String>? get diasDeLaSemana {
    if (dias?.isEmpty ?? true) return [];

    final diasAbrev = dias?.split('-');
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
        ?.map((dia) => conversion[dia.trim().toUpperCase()] ?? dia)
        .toList();
  }

  static EstatusCalificacion getEstatusClase(String estatus) {
    /// Devuelve el estatus de la clase
    switch (estatus.toLowerCase()) {
      case 'aprobado':
        return EstatusCalificacion.aprobada;
      case 'reprobado':
        return EstatusCalificacion.reprobada;
      case 'cursando':
        return EstatusCalificacion.cursando;
      case 'retiro':
        return EstatusCalificacion.retiro;
      default:
        return EstatusCalificacion.cursando;
    }
  }

  static List<List<CalificacionCurso>> groupByAnio(
    List<CalificacionCurso> calificaciones,
  ) {
    final anios = calificaciones
        .map((calificacion) => calificacion.anio)
        .toSet()
        .toList();
    final grupos = <List<CalificacionCurso>>[];

    anios.sort((a, b) => b.compareTo(a));
    for (final anio in anios) {
      final calificacionesAnio = calificaciones
          .where((calificacion) => calificacion.anio == anio)
          .toList();
      grupos.add(calificacionesAnio);
    }
    return grupos;
  }

  static List<List<CalificacionCurso>> groupByPeriodo(
    List<CalificacionCurso> calificaciones,
  ) {
    final periodos = calificaciones
        .map((calificacion) => calificacion.periodo)
        .toSet()
        .toList();
    final grupos = <List<CalificacionCurso>>[];

    periodos.sort((a, b) => b.compareTo(a));
    for (final periodo in periodos) {
      final calificacionesPeriodo = calificaciones
          .where((calificacion) => calificacion.periodo == periodo)
          .toList();
      grupos.add(calificacionesPeriodo);
    }
    return grupos;
  }

  static void orderCalificaciones(List<CalificacionCurso> calificaciones) {
    calificaciones.sort((a, b) {
      final anioCompare = b.anio.compareTo(a.anio);
      if (anioCompare != 0) return anioCompare;

      final periodoCompare = int.parse(
        b.periodo,
      ).compareTo(int.parse(a.periodo));
      if (periodoCompare != 0) return periodoCompare;

      final aNota = a.nota;
      final bNota = b.nota;

      if (aNota == null && bNota == null) return 0;
      if (aNota == null) return 1; // nulls last
      if (bNota == null) return -1;

      return bNota.compareTo(aNota); // higher nota first
    });
  }

  static double getPromedio(List<CalificacionCurso> calificaciones) {
    final notasValidas = calificaciones
        .map((calificacion) => calificacion.nota)
        .where((nota) => nota != null)
        .cast<num>() // or cast<double>()
        .toList();

    if (notasValidas.isEmpty) return 0.0;

    final suma = notasValidas.reduce((a, b) => a + b);
    return suma / notasValidas.length;
  }
}
