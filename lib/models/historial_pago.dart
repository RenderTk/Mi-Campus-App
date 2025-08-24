import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
part 'historial_pago.g.dart';

class DetallesDeHistorialPagoTipoMatriula {
  String? descripcion;
  double? montoTotal;
  double? descuentoBeca;
  double? mora;

  DetallesDeHistorialPagoTipoMatriula({
    required this.descripcion,
    required this.montoTotal,
    required this.descuentoBeca,
    required this.mora,
  });
}

@CopyWith()
@JsonSerializable()
class HistorialPago {
  @JsonKey(name: 'ID_FACTURA')
  int? idFactura;

  @JsonKey(name: 'FECHA_PROCESO', fromJson: parseFechaProceso)
  DateTime? fechaProceso;

  @JsonKey(name: 'DESCRIPCION')
  String? descripcion;

  @JsonKey(name: 'REFERENCIA1')
  String? referencia1;

  @JsonKey(name: 'MONTO')
  double? monto;

  @JsonKey(name: 'DESCRIPCION_DTL')
  String? descripcionDtl;

  @JsonKey(name: 'MONTO_TOTAL')
  double? montoTotal;

  @JsonKey(name: 'MONTO_DTL')
  double? montoDtl;

  @JsonKey(name: 'MONTO_MORA')
  double? montoMora;

  @JsonKey(name: 'MONTO_BEC_CREDITO')
  double? montoBecCredito;

  @JsonKey(name: 'FINANCIADO')
  int? financiado;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<DetallesDeHistorialPagoTipoMatriula> detalles = [];

  HistorialPago({
    this.idFactura,
    this.fechaProceso,
    this.descripcion,
    this.referencia1,
    this.monto,
    this.descripcionDtl,
    this.montoTotal,
    this.montoDtl,
    this.montoMora,
    this.montoBecCredito,
    this.financiado,
  });

  /// Método helper estático para parsear fecha desde JSON
  static DateTime? parseFechaProceso(String? fechaProceso) {
    if (fechaProceso == null || fechaProceso.isEmpty) {
      return null;
    }

    try {
      // Usar DateFormat de intl para parsear formato DD/MM/YYYY
      final formatter = DateFormat('dd/MM/yyyy');
      return formatter.parseStrict(fechaProceso);
    } catch (e) {
      // Si falla, intentar con otros formatos comunes como fallback
      try {
        // Intentar formato ISO como último recurso
        return DateTime.parse(fechaProceso);
      } catch (_) {
        return null;
      }
    }
  }

  static void sortListByFechaDesc(List<HistorialPago> pagos) {
    pagos.sort((a, b) {
      final fechaA = a.fechaProceso;
      final fechaB = b.fechaProceso;

      if (fechaA == null && fechaB == null) return 0;
      if (fechaA == null) return 1;
      if (fechaB == null) return -1;

      return fechaB.compareTo(fechaA);
    });
  }

  String get fechaAmigable {
    if (fechaProceso == null) return 'Fecha no disponible';

    final formatter = DateFormat('MMMM d, y', 'es_ES');
    final fechaFormateada = formatter.format(fechaProceso!);
    return fechaFormateada[0].toUpperCase() + fechaFormateada.substring(1);
  }

  factory HistorialPago.fromJson(Map<String, dynamic> json) =>
      _$HistorialPagoFromJson(json);

  Map<String, dynamic> toJson() => _$HistorialPagoToJson(this);
}
