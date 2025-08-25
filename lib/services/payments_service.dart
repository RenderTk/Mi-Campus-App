import 'package:intl/intl.dart';
import 'package:usap_mobile/models/historial_pago.dart';
import 'package:usap_mobile/models/pago_pendiente.dart';
import 'package:usap_mobile/models/pago_pendiente_detalle.dart';
import 'package:usap_mobile/services/dio_service.dart';

const String historialPagosUrl =
    "HistoricoPago_Alumno/obtener_historico_pago/{fecha_inicio}/{fecha_final}/{codigo_alumno}";

const String pagoPendienteUrl = "detallePago/modalidad";
const String pagoPendienteDetalleUrl =
    "detallePago/detalle/{idFactura}/{codigo_alumno}";

class PaymentsService {
  final _dioService = DioService();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  Future<List<HistorialPago>> getStudentHistorialPagos(
    String codigoAlumno,
    DateTime fechaInicio,
    DateTime fechaFinal,
  ) async {
    // 1. Petición HTTP
    final url = historialPagosUrl
        .replaceFirst("{fecha_inicio}", formatter.format(fechaInicio))
        .replaceFirst("{fecha_final}", formatter.format(fechaFinal))
        .replaceFirst("{codigo_alumno}", codigoAlumno);

    final dio = await _dioService.getDioWithAutoRefresh();
    final response = await dio.get<List<dynamic>>(url);

    if (response.statusCode != 200 || response.data == null) {
      throw Exception("Error al obtener el historial de pagos");
    }

    // 2. Parsear y procesar en una sola operación
    final histororialPagos = response.data!
        .map((e) => HistorialPago.fromJson(e))
        .toList();

    // 3. Identificar facturas de matrícula
    final facturasMatricula = histororialPagos
        .where((h) => h.descripcionDtl == "MATRICULA")
        .map((h) => h.idFactura)
        .toSet();

    // 4. Procesar matrículas: agregar detalles y filtrar en una pasada
    final List<DetallesDeHistorialPagoTipoMatriula> detallesMatricula = [];

    for (final idFacturaPagoMatricula in facturasMatricula) {
      //1486778

      // 5. Obtener pagos relacionados a la factura de matrícula
      final pagos = histororialPagos
          .where((pago) => pago.idFactura == idFacturaPagoMatricula)
          .toList();

      // 5.1. Obtener el pago de matrícula
      final pagoMatricula = pagos.firstWhere(
        (pago) => pago.descripcionDtl == "MATRICULA",
      );

      // 5.2 quitar el pago de matrícula de la lista de pagos
      pagos.remove(pagoMatricula);

      //6. Agregar detalles para la matrícula
      detallesMatricula.addAll(
        pagos.map(
          (pago) => DetallesDeHistorialPagoTipoMatriula(
            descripcion: pago.descripcionDtl,
            montoTotal: ((pago.montoTotal ?? 0) + (pago.montoBecCredito ?? 0)),
            descuentoBeca: pago.montoBecCredito,
            mora: pago.montoMora,
          ),
        ),
      );

      // 7. Guardar detalles en la factura de matrícula
      pagoMatricula.detalles.addAll(detallesMatricula);

      //7.1 Limpiar detalles
      detallesMatricula.clear();
    }

    // 8. Retornar solo matrículas principales y pagos que no son parte de matrículas
    return histororialPagos
        .where(
          (pago) =>
              pago.descripcionDtl == "MATRICULA" ||
              !facturasMatricula.contains(pago.idFactura),
        )
        .toList();
  }

  Future<List<PagoPendiente>> getPendingPayments(String codigoAlumno) async {
    final dio = await _dioService.getDioWithAutoRefresh();

    final payload = {"cuenta_alumno": codigoAlumno, "id_mod_pago_nueva": 1};
    final response = await dio.post<List<dynamic>>(
      pagoPendienteUrl,
      data: payload,
    );

    if (response.statusCode != 200 || response.data == null) {
      throw Exception("Error al obtener los pagos pendientes");
    }

    if (response.data == null) {
      return [];
    }
    final data = response.data!;
    final pagos = data.map((e) => PagoPendiente.fromJson(e)).toList();

    // Parallelize the detail requests
    final detailFutures = pagos.map((pago) async {
      final detalles = await getPendingPaymentDetails(
        pago.codigoAlumno ?? "",
        pago.idFactura.toString(),
      );
      pago.detalleFactura = detalles;
      return pago;
    }).toList();

    // Wait for all requests to complete
    final pagosWithDetails = await Future.wait(detailFutures);

    return pagosWithDetails;
  }

  Future<PagoPendienteDetalle?> getPendingPaymentDetails(
    String codigoAlumno,
    String idFactura,
  ) async {
    final url = pagoPendienteDetalleUrl
        .replaceFirst("{idFactura}", idFactura)
        .replaceFirst("{codigo_alumno}", codigoAlumno);

    final dio = await _dioService.getDioWithAutoRefresh();
    final response = await dio.get<List<dynamic>>(url);
    if (response.statusCode != 200) {
      throw Exception("Error al obtener los pagos pendientes");
    }

    if (response.data == null) {
      return null;
    }
    final data = response.data!;
    return data.map((e) => PagoPendienteDetalle.fromJson(e)).firstOrNull;
  }
}
