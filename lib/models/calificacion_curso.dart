import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'calificacion_curso.g.dart';

enum EstatusCalificacion { aprobada, reprobada, cursando, retiro }

@CopyWith()
@JsonSerializable()
class CalificacionCurso {
  @JsonKey(name: 'ORDERBY')
  int orderBy;

  @JsonKey(name: 'ANIO')
  String anio;

  @JsonKey(name: 'PERIODO')
  String periodo;

  @JsonKey(name: 'CODIGO_CURSO')
  String codigoCurso;

  @JsonKey(name: 'DESCRIPCION_CURSO')
  String descripcionCurso;

  @JsonKey(name: 'CREDITOS')
  int creditos;

  @JsonKey(name: 'ESTATUS', fromJson: getEstatusClase)
  EstatusCalificacion estatus;

  @JsonKey(name: 'NOTA')
  int? nota;

  @JsonKey(name: 'ID_SECCION_CLIENTE')
  int idSeccionCliente;

  @JsonKey(name: 'ID_SECCION')
  int idSeccion;

  @JsonKey(name: 'ESTATUS_ACADEMICO')
  String estatusAcademico;

  @JsonKey(name: 'DIAS')
  String dias;

  @JsonKey(name: 'INICIO')
  String inicio;

  @JsonKey(name: 'FIN')
  String fin;

  @JsonKey(name: 'CATEDRATICO')
  String catedratico;

  @JsonKey(name: 'ETIQUETA')
  String? etiqueta;

  CalificacionCurso({
    required this.orderBy,
    required this.anio,
    required this.periodo,
    required this.codigoCurso,
    required this.descripcionCurso,
    required this.creditos,
    required this.estatus,
    required this.nota,
    required this.idSeccionCliente,
    required this.idSeccion,
    required this.estatusAcademico,
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
  String? get diasNormalizado => dias.trim();

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
}
