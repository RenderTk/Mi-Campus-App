// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seccion_curso.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeccionCurso _$SeccionCursoFromJson(Map<String, dynamic> json) => SeccionCurso(
  idSeccionCliente: (json['ID_SECCION_CLIENTE'] as num?)?.toInt(),
  codigoCurso: json['CODIGO_CURSO'] as String?,
  descripcionCurso: json['DESCRIPCION_CURSO'] as String?,
  creditos: (json['CREDITOS'] as num?)?.toInt(),
  numeroSeccion: (json['NUMERO_SECCION'] as num?)?.toInt(),
  inicio: json['INICIO'] as String?,
  fin: json['FIN'] as String?,
  estatus: json['ESTATUS'] as String?,
  estatusAcademico: json['ESTATUS_ACADEMICO'] as String?,
  estatusFinanciero: json['ESTATUS_FINANCIERO'] as String?,
  estado: json['ESTADO'] as String?,
  estadoPago: json['ESTADO_PAGO'] as String?,
  dia: json['DIA'] as String?,
  aula: json['AULA'] as String?,
  inicioDia: json['INICIO_DIA'] as String?,
  finDia: json['FIN_DIA'] as String?,
  grupo: json['GRUPO'] as String?,
  url: json['URL'] as String?,
);

Map<String, dynamic> _$SeccionCursoToJson(SeccionCurso instance) =>
    <String, dynamic>{
      'ID_SECCION_CLIENTE': instance.idSeccionCliente,
      'CODIGO_CURSO': instance.codigoCurso,
      'DESCRIPCION_CURSO': instance.descripcionCurso,
      'CREDITOS': instance.creditos,
      'NUMERO_SECCION': instance.numeroSeccion,
      'INICIO': instance.inicio,
      'FIN': instance.fin,
      'ESTATUS': instance.estatus,
      'ESTATUS_ACADEMICO': instance.estatusAcademico,
      'ESTATUS_FINANCIERO': instance.estatusFinanciero,
      'ESTADO': instance.estado,
      'ESTADO_PAGO': instance.estadoPago,
      'DIA': instance.dia,
      'AULA': instance.aula,
      'INICIO_DIA': instance.inicioDia,
      'FIN_DIA': instance.finDia,
      'GRUPO': instance.grupo,
      'URL': instance.url,
    };
