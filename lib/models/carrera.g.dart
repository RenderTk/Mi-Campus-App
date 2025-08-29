// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carrera.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CarreraCWProxy {
  Carrera nombre(String nombre);

  Carrera progresoCarrera(int progresoCarrera);

  Carrera promedioGraduacion(double promedioGraduacion);

  Carrera promedioHistorico(double promedioHistorico);

  Carrera totalClasesCompletadas(int totalClasesCompletadas);

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
    double promedioGraduacion,
    double promedioHistorico,
    int totalClasesCompletadas,
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
  Carrera promedioGraduacion(double promedioGraduacion) =>
      call(promedioGraduacion: promedioGraduacion);

  @override
  Carrera promedioHistorico(double promedioHistorico) =>
      call(promedioHistorico: promedioHistorico);

  @override
  Carrera totalClasesCompletadas(int totalClasesCompletadas) =>
      call(totalClasesCompletadas: totalClasesCompletadas);

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
    Object? promedioGraduacion = const $CopyWithPlaceholder(),
    Object? promedioHistorico = const $CopyWithPlaceholder(),
    Object? totalClasesCompletadas = const $CopyWithPlaceholder(),
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
      promedioGraduacion:
          promedioGraduacion == const $CopyWithPlaceholder() ||
              promedioGraduacion == null
          ? _value.promedioGraduacion
          // ignore: cast_nullable_to_non_nullable
          : promedioGraduacion as double,
      promedioHistorico:
          promedioHistorico == const $CopyWithPlaceholder() ||
              promedioHistorico == null
          ? _value.promedioHistorico
          // ignore: cast_nullable_to_non_nullable
          : promedioHistorico as double,
      totalClasesCompletadas:
          totalClasesCompletadas == const $CopyWithPlaceholder() ||
              totalClasesCompletadas == null
          ? _value.totalClasesCompletadas
          // ignore: cast_nullable_to_non_nullable
          : totalClasesCompletadas as int,
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
