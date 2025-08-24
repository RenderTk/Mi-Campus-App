// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seccion_curso.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SeccionCursoCWProxy {
  SeccionCurso idSeccionCliente(int? idSeccionCliente);

  SeccionCurso codigoCurso(String? codigoCurso);

  SeccionCurso descripcionCurso(String? descripcionCurso);

  SeccionCurso numeroSeccion(int? numeroSeccion);

  SeccionCurso inicio(String? inicio);

  SeccionCurso fin(String? fin);

  SeccionCurso estado(String? estado);

  SeccionCurso dia(String? dia);

  SeccionCurso aula(String? aula);

  SeccionCurso grupo(String? grupo);

  SeccionCurso url(String? url);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `SeccionCurso(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// SeccionCurso(...).copyWith(id: 12, name: "My name")
  /// ```
  SeccionCurso call({
    int? idSeccionCliente,
    String? codigoCurso,
    String? descripcionCurso,
    int? numeroSeccion,
    String? inicio,
    String? fin,
    String? estado,
    String? dia,
    String? aula,
    String? grupo,
    String? url,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfSeccionCurso.copyWith(...)` or call `instanceOfSeccionCurso.copyWith.fieldName(value)` for a single field.
class _$SeccionCursoCWProxyImpl implements _$SeccionCursoCWProxy {
  const _$SeccionCursoCWProxyImpl(this._value);

  final SeccionCurso _value;

  @override
  SeccionCurso idSeccionCliente(int? idSeccionCliente) =>
      call(idSeccionCliente: idSeccionCliente);

  @override
  SeccionCurso codigoCurso(String? codigoCurso) =>
      call(codigoCurso: codigoCurso);

  @override
  SeccionCurso descripcionCurso(String? descripcionCurso) =>
      call(descripcionCurso: descripcionCurso);

  @override
  SeccionCurso numeroSeccion(int? numeroSeccion) =>
      call(numeroSeccion: numeroSeccion);

  @override
  SeccionCurso inicio(String? inicio) => call(inicio: inicio);

  @override
  SeccionCurso fin(String? fin) => call(fin: fin);

  @override
  SeccionCurso estado(String? estado) => call(estado: estado);

  @override
  SeccionCurso dia(String? dia) => call(dia: dia);

  @override
  SeccionCurso aula(String? aula) => call(aula: aula);

  @override
  SeccionCurso grupo(String? grupo) => call(grupo: grupo);

  @override
  SeccionCurso url(String? url) => call(url: url);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `SeccionCurso(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// SeccionCurso(...).copyWith(id: 12, name: "My name")
  /// ```
  SeccionCurso call({
    Object? idSeccionCliente = const $CopyWithPlaceholder(),
    Object? codigoCurso = const $CopyWithPlaceholder(),
    Object? descripcionCurso = const $CopyWithPlaceholder(),
    Object? numeroSeccion = const $CopyWithPlaceholder(),
    Object? inicio = const $CopyWithPlaceholder(),
    Object? fin = const $CopyWithPlaceholder(),
    Object? estado = const $CopyWithPlaceholder(),
    Object? dia = const $CopyWithPlaceholder(),
    Object? aula = const $CopyWithPlaceholder(),
    Object? grupo = const $CopyWithPlaceholder(),
    Object? url = const $CopyWithPlaceholder(),
  }) {
    return SeccionCurso(
      idSeccionCliente: idSeccionCliente == const $CopyWithPlaceholder()
          ? _value.idSeccionCliente
          // ignore: cast_nullable_to_non_nullable
          : idSeccionCliente as int?,
      codigoCurso: codigoCurso == const $CopyWithPlaceholder()
          ? _value.codigoCurso
          // ignore: cast_nullable_to_non_nullable
          : codigoCurso as String?,
      descripcionCurso: descripcionCurso == const $CopyWithPlaceholder()
          ? _value.descripcionCurso
          // ignore: cast_nullable_to_non_nullable
          : descripcionCurso as String?,
      numeroSeccion: numeroSeccion == const $CopyWithPlaceholder()
          ? _value.numeroSeccion
          // ignore: cast_nullable_to_non_nullable
          : numeroSeccion as int?,
      inicio: inicio == const $CopyWithPlaceholder()
          ? _value.inicio
          // ignore: cast_nullable_to_non_nullable
          : inicio as String?,
      fin: fin == const $CopyWithPlaceholder()
          ? _value.fin
          // ignore: cast_nullable_to_non_nullable
          : fin as String?,
      estado: estado == const $CopyWithPlaceholder()
          ? _value.estado
          // ignore: cast_nullable_to_non_nullable
          : estado as String?,
      dia: dia == const $CopyWithPlaceholder()
          ? _value.dia
          // ignore: cast_nullable_to_non_nullable
          : dia as String?,
      aula: aula == const $CopyWithPlaceholder()
          ? _value.aula
          // ignore: cast_nullable_to_non_nullable
          : aula as String?,
      grupo: grupo == const $CopyWithPlaceholder()
          ? _value.grupo
          // ignore: cast_nullable_to_non_nullable
          : grupo as String?,
      url: url == const $CopyWithPlaceholder()
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String?,
    );
  }
}

extension $SeccionCursoCopyWith on SeccionCurso {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfSeccionCurso.copyWith(...)` or `instanceOfSeccionCurso.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SeccionCursoCWProxy get copyWith => _$SeccionCursoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeccionCurso _$SeccionCursoFromJson(Map<String, dynamic> json) => SeccionCurso(
  idSeccionCliente: (json['ID_SECCION_CLIENTE'] as num?)?.toInt(),
  codigoCurso: json['CODIGO_CURSO'] as String?,
  descripcionCurso: json['DESCRIPCION_CURSO'] as String?,
  numeroSeccion: (json['NUMERO_SECCION'] as num?)?.toInt(),
  inicio: json['INICIO'] as String?,
  fin: json['FIN'] as String?,
  estado: json['ESTADO'] as String?,
  dia: json['DIA'] as String?,
  aula: json['AULA'] as String?,
  grupo: json['GRUPO'] as String?,
  url: json['URL'] as String?,
);

Map<String, dynamic> _$SeccionCursoToJson(SeccionCurso instance) =>
    <String, dynamic>{
      'ID_SECCION_CLIENTE': instance.idSeccionCliente,
      'CODIGO_CURSO': instance.codigoCurso,
      'DESCRIPCION_CURSO': instance.descripcionCurso,
      'NUMERO_SECCION': instance.numeroSeccion,
      'INICIO': instance.inicio,
      'FIN': instance.fin,
      'ESTADO': instance.estado,
      'DIA': instance.dia,
      'AULA': instance.aula,
      'GRUPO': instance.grupo,
      'URL': instance.url,
    };
