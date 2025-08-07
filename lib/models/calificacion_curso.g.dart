// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calificacion_curso.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalificacionCurso _$CalificacionCursoFromJson(Map<String, dynamic> json) =>
    CalificacionCurso(
      orderBy: (json['ORDERBY'] as num).toInt(),
      anio: json['ANIO'] as String,
      periodo: json['PERIODO'] as String,
      codigoCurso: json['CODIGO_CURSO'] as String,
      descripcionCurso: json['DESCRIPCION_CURSO'] as String,
      creditos: (json['CREDITOS'] as num).toInt(),
      estatus: CalificacionCurso.getEstatusClase(json['ESTATUS'] as String),
      nota: (json['NOTA'] as num?)?.toInt(),
      idSeccionCliente: (json['ID_SECCION_CLIENTE'] as num).toInt(),
      idSeccion: (json['ID_SECCION'] as num).toInt(),
      estatusAcademico: json['ESTATUS_ACADEMICO'] as String,
      dias: json['DIAS'] as String,
      inicio: json['INICIO'] as String,
      fin: json['FIN'] as String,
      catedratico: json['CATEDRATICO'] as String,
      etiqueta: json['ETIQUETA'] as String?,
    );

Map<String, dynamic> _$CalificacionCursoToJson(CalificacionCurso instance) =>
    <String, dynamic>{
      'ORDERBY': instance.orderBy,
      'ANIO': instance.anio,
      'PERIODO': instance.periodo,
      'CODIGO_CURSO': instance.codigoCurso,
      'DESCRIPCION_CURSO': instance.descripcionCurso,
      'CREDITOS': instance.creditos,
      'ESTATUS': _$EstatusCalificacionEnumMap[instance.estatus]!,
      'NOTA': instance.nota,
      'ID_SECCION_CLIENTE': instance.idSeccionCliente,
      'ID_SECCION': instance.idSeccion,
      'ESTATUS_ACADEMICO': instance.estatusAcademico,
      'DIAS': instance.dias,
      'INICIO': instance.inicio,
      'FIN': instance.fin,
      'CATEDRATICO': instance.catedratico,
      'ETIQUETA': instance.etiqueta,
    };

const _$EstatusCalificacionEnumMap = {
  EstatusCalificacion.aprobada: 'aprobada',
  EstatusCalificacion.reprobada: 'reprobada',
  EstatusCalificacion.cursando: 'cursando',
  EstatusCalificacion.retiro: 'retiro',
};
