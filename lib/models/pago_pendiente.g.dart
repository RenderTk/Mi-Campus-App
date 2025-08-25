// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pago_pendiente.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PagoPendienteCWProxy {
  PagoPendiente idFactura(int? idFactura);

  PagoPendiente codigoAlumno(String? codigoAlumno);

  PagoPendiente fechaProceso(DateTime? fechaProceso);

  PagoPendiente descripcion(String? descripcion);

  PagoPendiente referencia1(String? referencia1);

  PagoPendiente monto(double? monto);

  PagoPendiente financiado(int? financiado);

  PagoPendiente contado(bool? contado);

  PagoPendiente idTipoTransaccion(int? idTipoTransaccion);

  PagoPendiente simbolo(String? simbolo);

  PagoPendiente detalleFactura(dynamic detalleFactura);

  PagoPendiente detallePago(PagoPendienteDetalle? detallePago);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `PagoPendiente(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// PagoPendiente(...).copyWith(id: 12, name: "My name")
  /// ```
  PagoPendiente call({
    int? idFactura,
    String? codigoAlumno,
    DateTime? fechaProceso,
    String? descripcion,
    String? referencia1,
    double? monto,
    int? financiado,
    bool? contado,
    int? idTipoTransaccion,
    String? simbolo,
    dynamic detalleFactura,
    PagoPendienteDetalle? detallePago,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfPagoPendiente.copyWith(...)` or call `instanceOfPagoPendiente.copyWith.fieldName(value)` for a single field.
class _$PagoPendienteCWProxyImpl implements _$PagoPendienteCWProxy {
  const _$PagoPendienteCWProxyImpl(this._value);

  final PagoPendiente _value;

  @override
  PagoPendiente idFactura(int? idFactura) => call(idFactura: idFactura);

  @override
  PagoPendiente codigoAlumno(String? codigoAlumno) =>
      call(codigoAlumno: codigoAlumno);

  @override
  PagoPendiente fechaProceso(DateTime? fechaProceso) =>
      call(fechaProceso: fechaProceso);

  @override
  PagoPendiente descripcion(String? descripcion) =>
      call(descripcion: descripcion);

  @override
  PagoPendiente referencia1(String? referencia1) =>
      call(referencia1: referencia1);

  @override
  PagoPendiente monto(double? monto) => call(monto: monto);

  @override
  PagoPendiente financiado(int? financiado) => call(financiado: financiado);

  @override
  PagoPendiente contado(bool? contado) => call(contado: contado);

  @override
  PagoPendiente idTipoTransaccion(int? idTipoTransaccion) =>
      call(idTipoTransaccion: idTipoTransaccion);

  @override
  PagoPendiente simbolo(String? simbolo) => call(simbolo: simbolo);

  @override
  PagoPendiente detalleFactura(dynamic detalleFactura) =>
      call(detalleFactura: detalleFactura);

  @override
  PagoPendiente detallePago(PagoPendienteDetalle? detallePago) =>
      call(detallePago: detallePago);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `PagoPendiente(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// PagoPendiente(...).copyWith(id: 12, name: "My name")
  /// ```
  PagoPendiente call({
    Object? idFactura = const $CopyWithPlaceholder(),
    Object? codigoAlumno = const $CopyWithPlaceholder(),
    Object? fechaProceso = const $CopyWithPlaceholder(),
    Object? descripcion = const $CopyWithPlaceholder(),
    Object? referencia1 = const $CopyWithPlaceholder(),
    Object? monto = const $CopyWithPlaceholder(),
    Object? financiado = const $CopyWithPlaceholder(),
    Object? contado = const $CopyWithPlaceholder(),
    Object? idTipoTransaccion = const $CopyWithPlaceholder(),
    Object? simbolo = const $CopyWithPlaceholder(),
    Object? detalleFactura = const $CopyWithPlaceholder(),
    Object? detallePago = const $CopyWithPlaceholder(),
  }) {
    return PagoPendiente(
      idFactura: idFactura == const $CopyWithPlaceholder()
          ? _value.idFactura
          // ignore: cast_nullable_to_non_nullable
          : idFactura as int?,
      codigoAlumno: codigoAlumno == const $CopyWithPlaceholder()
          ? _value.codigoAlumno
          // ignore: cast_nullable_to_non_nullable
          : codigoAlumno as String?,
      fechaProceso: fechaProceso == const $CopyWithPlaceholder()
          ? _value.fechaProceso
          // ignore: cast_nullable_to_non_nullable
          : fechaProceso as DateTime?,
      descripcion: descripcion == const $CopyWithPlaceholder()
          ? _value.descripcion
          // ignore: cast_nullable_to_non_nullable
          : descripcion as String?,
      referencia1: referencia1 == const $CopyWithPlaceholder()
          ? _value.referencia1
          // ignore: cast_nullable_to_non_nullable
          : referencia1 as String?,
      monto: monto == const $CopyWithPlaceholder()
          ? _value.monto
          // ignore: cast_nullable_to_non_nullable
          : monto as double?,
      financiado: financiado == const $CopyWithPlaceholder()
          ? _value.financiado
          // ignore: cast_nullable_to_non_nullable
          : financiado as int?,
      contado: contado == const $CopyWithPlaceholder()
          ? _value.contado
          // ignore: cast_nullable_to_non_nullable
          : contado as bool?,
      idTipoTransaccion: idTipoTransaccion == const $CopyWithPlaceholder()
          ? _value.idTipoTransaccion
          // ignore: cast_nullable_to_non_nullable
          : idTipoTransaccion as int?,
      simbolo: simbolo == const $CopyWithPlaceholder()
          ? _value.simbolo
          // ignore: cast_nullable_to_non_nullable
          : simbolo as String?,
      detalleFactura: detalleFactura == const $CopyWithPlaceholder()
          ? _value.detalleFactura
          // ignore: cast_nullable_to_non_nullable
          : detalleFactura as dynamic,
      detallePago: detallePago == const $CopyWithPlaceholder()
          ? _value.detallePago
          // ignore: cast_nullable_to_non_nullable
          : detallePago as PagoPendienteDetalle?,
    );
  }
}

extension $PagoPendienteCopyWith on PagoPendiente {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfPagoPendiente.copyWith(...)` or `instanceOfPagoPendiente.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PagoPendienteCWProxy get copyWith => _$PagoPendienteCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagoPendiente _$PagoPendienteFromJson(Map<String, dynamic> json) =>
    PagoPendiente(
      idFactura: (json['ID_FACTURA'] as num?)?.toInt(),
      codigoAlumno: json['CUENTA_ALUMNO'] as String?,
      fechaProceso: json['FECHA_PROCESO'] == null
          ? null
          : DateTime.parse(json['FECHA_PROCESO'] as String),
      descripcion: json['DESCRIPCION'] as String?,
      referencia1: json['REFERENCIA1'] as String?,
      monto: (json['MONTO'] as num?)?.toDouble(),
      financiado: (json['FINANCIADO'] as num?)?.toInt(),
      contado: PagoPendiente._contadoFromJson(json['CONTADO']),
      idTipoTransaccion: (json['ID_TIPO_TRANSACCION'] as num?)?.toInt(),
      simbolo: json['SIMBOLO'] as String?,
      detalleFactura: json['DETALLE_FACTURA'],
    );

Map<String, dynamic> _$PagoPendienteToJson(PagoPendiente instance) =>
    <String, dynamic>{
      'ID_FACTURA': instance.idFactura,
      'CUENTA_ALUMNO': instance.codigoAlumno,
      'FECHA_PROCESO': instance.fechaProceso?.toIso8601String(),
      'DESCRIPCION': instance.descripcion,
      'REFERENCIA1': instance.referencia1,
      'MONTO': instance.monto,
      'FINANCIADO': instance.financiado,
      'CONTADO': instance.contado,
      'ID_TIPO_TRANSACCION': instance.idTipoTransaccion,
      'SIMBOLO': instance.simbolo,
      'DETALLE_FACTURA': instance.detalleFactura,
    };
