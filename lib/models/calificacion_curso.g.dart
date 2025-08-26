// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calificacion_curso.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CalificacionCursoCWProxy {
  CalificacionCurso anio(String anio);

  CalificacionCurso periodo(String periodo);

  CalificacionCurso codigoCurso(String codigoCurso);

  CalificacionCurso descripcionCurso(String descripcionCurso);

  CalificacionCurso estatus(EstatusCalificacion estatus);

  CalificacionCurso nota(int? nota);

  CalificacionCurso dias(String? dias);

  CalificacionCurso inicio(String? inicio);

  CalificacionCurso fin(String? fin);

  CalificacionCurso catedratico(String? catedratico);

  CalificacionCurso etiqueta(String? etiqueta);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CalificacionCurso(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CalificacionCurso(...).copyWith(id: 12, name: "My name")
  /// ```
  CalificacionCurso call({
    String anio,
    String periodo,
    String codigoCurso,
    String descripcionCurso,
    EstatusCalificacion estatus,
    int? nota,
    String? dias,
    String? inicio,
    String? fin,
    String? catedratico,
    String? etiqueta,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfCalificacionCurso.copyWith(...)` or call `instanceOfCalificacionCurso.copyWith.fieldName(value)` for a single field.
class _$CalificacionCursoCWProxyImpl implements _$CalificacionCursoCWProxy {
  const _$CalificacionCursoCWProxyImpl(this._value);

  final CalificacionCurso _value;

  @override
  CalificacionCurso anio(String anio) => call(anio: anio);

  @override
  CalificacionCurso periodo(String periodo) => call(periodo: periodo);

  @override
  CalificacionCurso codigoCurso(String codigoCurso) =>
      call(codigoCurso: codigoCurso);

  @override
  CalificacionCurso descripcionCurso(String descripcionCurso) =>
      call(descripcionCurso: descripcionCurso);

  @override
  CalificacionCurso estatus(EstatusCalificacion estatus) =>
      call(estatus: estatus);

  @override
  CalificacionCurso nota(int? nota) => call(nota: nota);

  @override
  CalificacionCurso dias(String? dias) => call(dias: dias);

  @override
  CalificacionCurso inicio(String? inicio) => call(inicio: inicio);

  @override
  CalificacionCurso fin(String? fin) => call(fin: fin);

  @override
  CalificacionCurso catedratico(String? catedratico) =>
      call(catedratico: catedratico);

  @override
  CalificacionCurso etiqueta(String? etiqueta) => call(etiqueta: etiqueta);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CalificacionCurso(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CalificacionCurso(...).copyWith(id: 12, name: "My name")
  /// ```
  CalificacionCurso call({
    Object? anio = const $CopyWithPlaceholder(),
    Object? periodo = const $CopyWithPlaceholder(),
    Object? codigoCurso = const $CopyWithPlaceholder(),
    Object? descripcionCurso = const $CopyWithPlaceholder(),
    Object? estatus = const $CopyWithPlaceholder(),
    Object? nota = const $CopyWithPlaceholder(),
    Object? dias = const $CopyWithPlaceholder(),
    Object? inicio = const $CopyWithPlaceholder(),
    Object? fin = const $CopyWithPlaceholder(),
    Object? catedratico = const $CopyWithPlaceholder(),
    Object? etiqueta = const $CopyWithPlaceholder(),
  }) {
    return CalificacionCurso(
      anio: anio == const $CopyWithPlaceholder() || anio == null
          ? _value.anio
          // ignore: cast_nullable_to_non_nullable
          : anio as String,
      periodo: periodo == const $CopyWithPlaceholder() || periodo == null
          ? _value.periodo
          // ignore: cast_nullable_to_non_nullable
          : periodo as String,
      codigoCurso:
          codigoCurso == const $CopyWithPlaceholder() || codigoCurso == null
          ? _value.codigoCurso
          // ignore: cast_nullable_to_non_nullable
          : codigoCurso as String,
      descripcionCurso:
          descripcionCurso == const $CopyWithPlaceholder() ||
              descripcionCurso == null
          ? _value.descripcionCurso
          // ignore: cast_nullable_to_non_nullable
          : descripcionCurso as String,
      estatus: estatus == const $CopyWithPlaceholder() || estatus == null
          ? _value.estatus
          // ignore: cast_nullable_to_non_nullable
          : estatus as EstatusCalificacion,
      nota: nota == const $CopyWithPlaceholder()
          ? _value.nota
          // ignore: cast_nullable_to_non_nullable
          : nota as int?,
      dias: dias == const $CopyWithPlaceholder()
          ? _value.dias
          // ignore: cast_nullable_to_non_nullable
          : dias as String?,
      inicio: inicio == const $CopyWithPlaceholder()
          ? _value.inicio
          // ignore: cast_nullable_to_non_nullable
          : inicio as String?,
      fin: fin == const $CopyWithPlaceholder()
          ? _value.fin
          // ignore: cast_nullable_to_non_nullable
          : fin as String?,
      catedratico: catedratico == const $CopyWithPlaceholder()
          ? _value.catedratico
          // ignore: cast_nullable_to_non_nullable
          : catedratico as String?,
      etiqueta: etiqueta == const $CopyWithPlaceholder()
          ? _value.etiqueta
          // ignore: cast_nullable_to_non_nullable
          : etiqueta as String?,
    );
  }
}

extension $CalificacionCursoCopyWith on CalificacionCurso {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfCalificacionCurso.copyWith(...)` or `instanceOfCalificacionCurso.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CalificacionCursoCWProxy get copyWith =>
      _$CalificacionCursoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalificacionCurso _$CalificacionCursoFromJson(Map<String, dynamic> json) =>
    CalificacionCurso(
      anio: json['ANIO'] as String,
      periodo: json['PERIODO'] as String,
      codigoCurso: json['CODIGO_CURSO'] as String,
      descripcionCurso: json['DESCRIPCION_CURSO'] as String,
      estatus: CalificacionCurso.getEstatusClase(json['ESTATUS'] as String),
      nota: (json['NOTA'] as num?)?.toInt(),
      dias: json['DIAS'] as String?,
      inicio: json['INICIO'] as String?,
      fin: json['FIN'] as String?,
      catedratico: json['CATEDRATICO'] as String?,
      etiqueta: json['ETIQUETA'] as String?,
    );

Map<String, dynamic> _$CalificacionCursoToJson(CalificacionCurso instance) =>
    <String, dynamic>{
      'ANIO': instance.anio,
      'PERIODO': instance.periodo,
      'CODIGO_CURSO': instance.codigoCurso,
      'DESCRIPCION_CURSO': instance.descripcionCurso,
      'ESTATUS': _$EstatusCalificacionEnumMap[instance.estatus]!,
      'NOTA': instance.nota,
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
