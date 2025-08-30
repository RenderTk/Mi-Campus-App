// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pantalla_bloqueada.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PantallaBloqueadaCWProxy {
  PantallaBloqueada titulo(String? titulo);

  PantallaBloqueada mensaje(String? mensaje);

  PantallaBloqueada paginas(String? paginas);

  PantallaBloqueada resultado(bool? resultado);

  PantallaBloqueada bloquear(bool? bloquear);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `PantallaBloqueada(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// PantallaBloqueada(...).copyWith(id: 12, name: "My name")
  /// ```
  PantallaBloqueada call({
    String? titulo,
    String? mensaje,
    String? paginas,
    bool? resultado,
    bool? bloquear,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfPantallaBloqueada.copyWith(...)` or call `instanceOfPantallaBloqueada.copyWith.fieldName(value)` for a single field.
class _$PantallaBloqueadaCWProxyImpl implements _$PantallaBloqueadaCWProxy {
  const _$PantallaBloqueadaCWProxyImpl(this._value);

  final PantallaBloqueada _value;

  @override
  PantallaBloqueada titulo(String? titulo) => call(titulo: titulo);

  @override
  PantallaBloqueada mensaje(String? mensaje) => call(mensaje: mensaje);

  @override
  PantallaBloqueada paginas(String? paginas) => call(paginas: paginas);

  @override
  PantallaBloqueada resultado(bool? resultado) => call(resultado: resultado);

  @override
  PantallaBloqueada bloquear(bool? bloquear) => call(bloquear: bloquear);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `PantallaBloqueada(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// PantallaBloqueada(...).copyWith(id: 12, name: "My name")
  /// ```
  PantallaBloqueada call({
    Object? titulo = const $CopyWithPlaceholder(),
    Object? mensaje = const $CopyWithPlaceholder(),
    Object? paginas = const $CopyWithPlaceholder(),
    Object? resultado = const $CopyWithPlaceholder(),
    Object? bloquear = const $CopyWithPlaceholder(),
  }) {
    return PantallaBloqueada(
      titulo: titulo == const $CopyWithPlaceholder()
          ? _value.titulo
          // ignore: cast_nullable_to_non_nullable
          : titulo as String?,
      mensaje: mensaje == const $CopyWithPlaceholder()
          ? _value.mensaje
          // ignore: cast_nullable_to_non_nullable
          : mensaje as String?,
      paginas: paginas == const $CopyWithPlaceholder()
          ? _value.paginas
          // ignore: cast_nullable_to_non_nullable
          : paginas as String?,
      resultado: resultado == const $CopyWithPlaceholder()
          ? _value.resultado
          // ignore: cast_nullable_to_non_nullable
          : resultado as bool?,
      bloquear: bloquear == const $CopyWithPlaceholder()
          ? _value.bloquear
          // ignore: cast_nullable_to_non_nullable
          : bloquear as bool?,
    );
  }
}

extension $PantallaBloqueadaCopyWith on PantallaBloqueada {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfPantallaBloqueada.copyWith(...)` or `instanceOfPantallaBloqueada.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PantallaBloqueadaCWProxy get copyWith =>
      _$PantallaBloqueadaCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PantallaBloqueada _$PantallaBloqueadaFromJson(Map<String, dynamic> json) =>
    PantallaBloqueada(
      titulo: json['TITULO'] as String?,
      mensaje: json['MENSAJE'] as String?,
      paginas: json['PAGINAS'] as String?,
      resultado: PantallaBloqueada._boolFromJson(json['RESULTADO']),
      bloquear: PantallaBloqueada._boolFromJson(json['BLOQUEAR']),
    );

Map<String, dynamic> _$PantallaBloqueadaToJson(PantallaBloqueada instance) =>
    <String, dynamic>{
      'TITULO': instance.titulo,
      'MENSAJE': instance.mensaje,
      'PAGINAS': instance.paginas,
      'RESULTADO': instance.resultado,
      'BLOQUEAR': instance.bloquear,
    };
