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
  @JsonKey(name: 'ID_DETALLE')
  int? idDetalle;
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
  @JsonKey(name: 'SIMBOLO')
  String? simbolo;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<DetallesDeHistorialPagoTipoMatriula> detalles = [];

  HistorialPago({
    this.idFactura,
    this.fechaProceso,
    this.descripcion,
    this.referencia1,
    this.monto,
    this.idDetalle,
    this.descripcionDtl,
    this.montoTotal,
    this.montoDtl,
    this.montoMora,
    this.montoBecCredito,
    this.financiado,
    this.simbolo,
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

  static String toTitleCase(String text) {
    if (text.isEmpty) return text;

    text = text.toLowerCase();
    return text[0].toUpperCase() + text.substring(1);
  }

  factory HistorialPago.fromJson(Map<String, dynamic> json) =>
      _$HistorialPagoFromJson(json);

  Map<String, dynamic> toJson() => _$HistorialPagoToJson(this);

  static Map<String, DateTime> getSemesterDateRange(int semester, int year) {
    // Validate inputs
    if (semester < 0 || semester > 3) {
      throw ArgumentError(
        'Semester must be 0 (all year), 1 (first semester), 2 (second semester), or 3 (third semester)',
      );
    }

    if (year < 2010 || year > 2025) {
      throw ArgumentError('Year must be a valid integer between 2010 and 2025');
    }

    DateTime fechaInicio;
    DateTime fechaFinal;

    switch (semester) {
      case 0: // All year
        fechaInicio = DateTime(year, 1, 1); // January 1st
        fechaFinal = DateTime(year, 12, 31); // December 31st
        break;

      case 1: // First semester (January - April)
        fechaInicio = DateTime(year, 1, 1); // January 1st
        fechaFinal = DateTime(year, 4, 30); // April 30th
        break;

      case 2: // Second semester (May - August)
        fechaInicio = DateTime(year, 5, 1); // May 1st
        fechaFinal = DateTime(year, 8, 31); // August 31st
        break;

      case 3: // Third semester (September - December)
        fechaInicio = DateTime(year, 9, 1); // September 1st
        fechaFinal = DateTime(year, 12, 31); // December 31st
        break;

      default:
        throw ArgumentError('Invalid semester value');
    }

    return {'fechaInicio': fechaInicio, 'fechaFinal': fechaFinal};
  }
}
