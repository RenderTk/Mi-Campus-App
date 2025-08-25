import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pago_pendiente_detalle.g.dart';

@CopyWith()
@JsonSerializable()
class PagoPendienteDetalle {
  @JsonKey(name: 'DESCRIPCION')
  String? descripcion;

  @JsonKey(name: 'MONTO')
  double? monto;

  @JsonKey(name: 'MORA')
  double? mora;

  @JsonKey(name: 'BECA')
  double? beca;

  @JsonKey(name: 'CREDITO')
  double? credito;

  @JsonKey(name: 'PAGAR')
  double? pagar;

  @JsonKey(name: 'FINAN')
  int? finan;

  PagoPendienteDetalle({
    this.descripcion,
    this.monto,
    this.mora,
    this.beca,
    this.credito,
    this.pagar,
    this.finan,
  });

  factory PagoPendienteDetalle.fromJson(Map<String, dynamic> json) =>
      _$PagoPendienteDetalleFromJson(json);

  Map<String, dynamic> toJson() => _$PagoPendienteDetalleToJson(this);
}
