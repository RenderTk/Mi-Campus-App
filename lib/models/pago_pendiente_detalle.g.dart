// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pago_pendiente_detalle.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PagoPendienteDetalleCWProxy {
  PagoPendienteDetalle descripcion(String? descripcion);

  PagoPendienteDetalle monto(double? monto);

  PagoPendienteDetalle mora(double? mora);

  PagoPendienteDetalle beca(double? beca);

  PagoPendienteDetalle credito(double? credito);

  PagoPendienteDetalle pagar(double? pagar);

  PagoPendienteDetalle finan(int? finan);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `PagoPendienteDetalle(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// PagoPendienteDetalle(...).copyWith(id: 12, name: "My name")
  /// ```
  PagoPendienteDetalle call({
    String? descripcion,
    double? monto,
    double? mora,
    double? beca,
    double? credito,
    double? pagar,
    int? finan,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfPagoPendienteDetalle.copyWith(...)` or call `instanceOfPagoPendienteDetalle.copyWith.fieldName(value)` for a single field.
class _$PagoPendienteDetalleCWProxyImpl
    implements _$PagoPendienteDetalleCWProxy {
  const _$PagoPendienteDetalleCWProxyImpl(this._value);

  final PagoPendienteDetalle _value;

  @override
  PagoPendienteDetalle descripcion(String? descripcion) =>
      call(descripcion: descripcion);

  @override
  PagoPendienteDetalle monto(double? monto) => call(monto: monto);

  @override
  PagoPendienteDetalle mora(double? mora) => call(mora: mora);

  @override
  PagoPendienteDetalle beca(double? beca) => call(beca: beca);

  @override
  PagoPendienteDetalle credito(double? credito) => call(credito: credito);

  @override
  PagoPendienteDetalle pagar(double? pagar) => call(pagar: pagar);

  @override
  PagoPendienteDetalle finan(int? finan) => call(finan: finan);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `PagoPendienteDetalle(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// PagoPendienteDetalle(...).copyWith(id: 12, name: "My name")
  /// ```
  PagoPendienteDetalle call({
    Object? descripcion = const $CopyWithPlaceholder(),
    Object? monto = const $CopyWithPlaceholder(),
    Object? mora = const $CopyWithPlaceholder(),
    Object? beca = const $CopyWithPlaceholder(),
    Object? credito = const $CopyWithPlaceholder(),
    Object? pagar = const $CopyWithPlaceholder(),
    Object? finan = const $CopyWithPlaceholder(),
  }) {
    return PagoPendienteDetalle(
      descripcion: descripcion == const $CopyWithPlaceholder()
          ? _value.descripcion
          // ignore: cast_nullable_to_non_nullable
          : descripcion as String?,
      monto: monto == const $CopyWithPlaceholder()
          ? _value.monto
          // ignore: cast_nullable_to_non_nullable
          : monto as double?,
      mora: mora == const $CopyWithPlaceholder()
          ? _value.mora
          // ignore: cast_nullable_to_non_nullable
          : mora as double?,
      beca: beca == const $CopyWithPlaceholder()
          ? _value.beca
          // ignore: cast_nullable_to_non_nullable
          : beca as double?,
      credito: credito == const $CopyWithPlaceholder()
          ? _value.credito
          // ignore: cast_nullable_to_non_nullable
          : credito as double?,
      pagar: pagar == const $CopyWithPlaceholder()
          ? _value.pagar
          // ignore: cast_nullable_to_non_nullable
          : pagar as double?,
      finan: finan == const $CopyWithPlaceholder()
          ? _value.finan
          // ignore: cast_nullable_to_non_nullable
          : finan as int?,
    );
  }
}

extension $PagoPendienteDetalleCopyWith on PagoPendienteDetalle {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfPagoPendienteDetalle.copyWith(...)` or `instanceOfPagoPendienteDetalle.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PagoPendienteDetalleCWProxy get copyWith =>
      _$PagoPendienteDetalleCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagoPendienteDetalle _$PagoPendienteDetalleFromJson(
  Map<String, dynamic> json,
) => PagoPendienteDetalle(
  descripcion: json['DESCRIPCION'] as String?,
  monto: (json['MONTO'] as num?)?.toDouble(),
  mora: (json['MORA'] as num?)?.toDouble(),
  beca: (json['BECA'] as num?)?.toDouble(),
  credito: (json['CREDITO'] as num?)?.toDouble(),
  pagar: (json['PAGAR'] as num?)?.toDouble(),
  finan: (json['FINAN'] as num?)?.toInt(),
);

Map<String, dynamic> _$PagoPendienteDetalleToJson(
  PagoPendienteDetalle instance,
) => <String, dynamic>{
  'DESCRIPCION': instance.descripcion,
  'MONTO': instance.monto,
  'MORA': instance.mora,
  'BECA': instance.beca,
  'CREDITO': instance.credito,
  'PAGAR': instance.pagar,
  'FINAN': instance.finan,
};
