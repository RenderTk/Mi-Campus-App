import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:usap_mobile/models/pago_pendiente_detalle.dart';

part 'pago_pendiente.g.dart';

@CopyWith()
@JsonSerializable()
class PagoPendiente {
  @JsonKey(name: 'ID_FACTURA')
  int? idFactura;

  @JsonKey(name: 'CUENTA_ALUMNO')
  String? codigoAlumno;

  @JsonKey(name: 'FECHA_PROCESO')
  DateTime? fechaProceso;

  @JsonKey(name: 'DESCRIPCION')
  String? descripcion;

  @JsonKey(name: 'REFERENCIA1')
  String? referencia1;

  @JsonKey(name: 'MONTO')
  double? monto;

  @JsonKey(name: 'FINANCIADO')
  int? financiado;

  @JsonKey(name: 'CONTADO', fromJson: _contadoFromJson)
  bool? contado;

  @JsonKey(name: 'ID_TIPO_TRANSACCION')
  int? idTipoTransaccion;

  @JsonKey(name: 'SIMBOLO')
  String? simbolo;

  @JsonKey(name: 'DETALLE_FACTURA')
  dynamic detalleFactura;

  @JsonKey(includeFromJson: false)
  PagoPendienteDetalle? detallePago;

  PagoPendiente({
    this.idFactura,
    this.codigoAlumno,
    this.fechaProceso,
    this.descripcion,
    this.referencia1,
    this.monto,
    this.financiado,
    this.contado,
    this.idTipoTransaccion,
    this.simbolo,
    this.detalleFactura,
    this.detallePago,
  });

  factory PagoPendiente.fromJson(Map<String, dynamic> json) =>
      _$PagoPendienteFromJson(json);

  Map<String, dynamic> toJson() => _$PagoPendienteToJson(this);

  static bool? _contadoFromJson(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      if (value.toLowerCase() == 'true') return true;
      if (value.toLowerCase() == 'false') return false;
      final intValue = int.tryParse(value);
      return intValue == 1;
    }
    return null;
  }

  /// Obtiene la descripción sin espacios adicionales
  String? get descripcionNormalizada => descripcion?.trim();

  /// Obtiene la referencia sin espacios adicionales
  String? get referenciaNormalizada => referencia1?.trim();

  /// Verifica si es un pago de contado
  bool get esPagoContado => contado == true;

  /// Verifica si es un pago financiado
  bool get esFinanciado => (financiado ?? 0) > 0;

  /// Obtiene la fecha formateada para mostrar
  String? get fechaFormateada {
    if (fechaProceso == null) return null;
    final formato = DateFormat('dd/MM/yyyy');
    return formato.format(fechaProceso!);
  }

  /// Obtiene la fecha formateada con día de la semana
  String? get fechaCompletaFormateada {
    if (fechaProceso == null) return null;
    final formato = DateFormat('EEEE, dd MMMM yyyy', 'es_ES');
    return formato.format(fechaProceso!);
  }

  /// Verifica si el pago está vencido
  bool get estaVencido {
    if (fechaProceso == null) return false;
    final ahora = DateTime.now();
    return fechaProceso!.isBefore(ahora);
  }

  /// Verifica si el pago vence hoy
  bool get venceHoy {
    if (fechaProceso == null) return false;
    final ahora = DateTime.now();
    return fechaProceso!.year == ahora.year &&
        fechaProceso!.month == ahora.month &&
        fechaProceso!.day == ahora.day;
  }

  /// Verifica si el pago vence en los próximos días especificados
  bool venceEnProximosDias(int dias) {
    if (fechaProceso == null) return false;
    final ahora = DateTime.now();
    final fechaLimite = ahora.add(Duration(days: dias));
    return fechaProceso!.isAfter(ahora) && fechaProceso!.isBefore(fechaLimite);
  }

  /// Obtiene los días restantes para el vencimiento
  int get diasRestantes {
    if (fechaProceso == null) return 0;
    final ahora = DateTime.now();
    final diferencia = fechaProceso!.difference(ahora);
    return diferencia.inDays;
  }

  /// Métodos helper estáticos

  /// Filtra pagos vencidos
  static List<PagoPendiente> filtrarVencidos(List<PagoPendiente> pagos) {
    return pagos.where((pago) => pago.estaVencido).toList();
  }

  /// Filtra pagos que vencen hoy
  static List<PagoPendiente> filtrarVencenHoy(List<PagoPendiente> pagos) {
    return pagos.where((pago) => pago.venceHoy).toList();
  }

  /// Ordena pagos por fecha de vencimiento (más próximos primero)
  static List<PagoPendiente> ordenarPorFechaVencimiento(
    List<PagoPendiente> pagos,
  ) {
    final List<PagoPendiente> pagosCopia = List.from(pagos);
    pagosCopia.sort((a, b) {
      if (a.fechaProceso == null && b.fechaProceso == null) return 0;
      if (a.fechaProceso == null) return 1;
      if (b.fechaProceso == null) return -1;
      return a.fechaProceso!.compareTo(b.fechaProceso!);
    });
    return pagosCopia;
  }
}
