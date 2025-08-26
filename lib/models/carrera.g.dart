// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carrera.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CarreraCWProxy {
  Carrera nombre(String nombre);

  Carrera progresoCarrera(int progresoCarrera);

  Carrera totalCompletadas(int totalCompletadas);

  Carrera totalClases(int totalClases);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Carrera(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Carrera(...).copyWith(id: 12, name: "My name")
  /// ```
  Carrera call({
    String nombre,
    int progresoCarrera,
    int totalCompletadas,
    int totalClases,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfCarrera.copyWith(...)` or call `instanceOfCarrera.copyWith.fieldName(value)` for a single field.
class _$CarreraCWProxyImpl implements _$CarreraCWProxy {
  const _$CarreraCWProxyImpl(this._value);

  final Carrera _value;

  @override
  Carrera nombre(String nombre) => call(nombre: nombre);

  @override
  Carrera progresoCarrera(int progresoCarrera) =>
      call(progresoCarrera: progresoCarrera);

  @override
  Carrera totalCompletadas(int totalCompletadas) =>
      call(totalCompletadas: totalCompletadas);

  @override
  Carrera totalClases(int totalClases) => call(totalClases: totalClases);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Carrera(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Carrera(...).copyWith(id: 12, name: "My name")
  /// ```
  Carrera call({
    Object? nombre = const $CopyWithPlaceholder(),
    Object? progresoCarrera = const $CopyWithPlaceholder(),
    Object? totalCompletadas = const $CopyWithPlaceholder(),
    Object? totalClases = const $CopyWithPlaceholder(),
  }) {
    return Carrera(
      nombre: nombre == const $CopyWithPlaceholder() || nombre == null
          ? _value.nombre
          // ignore: cast_nullable_to_non_nullable
          : nombre as String,
      progresoCarrera:
          progresoCarrera == const $CopyWithPlaceholder() ||
              progresoCarrera == null
          ? _value.progresoCarrera
          // ignore: cast_nullable_to_non_nullable
          : progresoCarrera as int,
      totalClasesCompletadas:
          totalCompletadas == const $CopyWithPlaceholder() ||
              totalCompletadas == null
          ? _value.totalClasesCompletadas
          // ignore: cast_nullable_to_non_nullable
          : totalCompletadas as int,
      totalClases:
          totalClases == const $CopyWithPlaceholder() || totalClases == null
          ? _value.totalClases
          // ignore: cast_nullable_to_non_nullable
          : totalClases as int,
    );
  }
}

extension $CarreraCopyWith on Carrera {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfCarrera.copyWith(...)` or `instanceOfCarrera.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CarreraCWProxy get copyWith => _$CarreraCWProxyImpl(this);
}
