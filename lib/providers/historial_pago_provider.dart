import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_campus_app/models/historial_pago.dart';
import 'package:mi_campus_app/providers/user_provider.dart';
import 'package:mi_campus_app/services/payments_data_service.dart';

class HistorialPagosProviderNotifier
    extends AsyncNotifier<List<HistorialPago>> {
  final PaymentsDataService _paymentsDataService = PaymentsDataService();

  @override
  Future<List<HistorialPago>> build() async {
    state = const AsyncValue.loading();

    final user = await ref.watch(userProvider.future);
    if (user == null) {
      throw Exception('User not found');
    }

    final now = DateTime.now();
    final fechaInicio = DateTime(now.year, 1, 1);
    final historialPagos = await _paymentsDataService.getStudentHistorialPagos(
      user.id,
      fechaInicio,
      now,
    );
    return historialPagos;
  }

  Future<void> refetchByDates(DateTime fechaInicio, DateTime fechaFinal) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      // throw Exception('error al refrescar');

      final user = ref.read(userProvider).value;
      if (user == null) {
        throw Exception('User not found');
      }
      if (fechaInicio.isAfter(fechaFinal)) {
        throw Exception(
          'La fecha de inicio debe ser anterior a la fecha final',
        );
      }

      final refreshedHistorialPagos = await _paymentsDataService
          .getStudentHistorialPagos(user.id, fechaInicio, fechaFinal);
      return refreshedHistorialPagos;
    });
  }

  void clearState() {
    state = const AsyncValue.loading();
    state = const AsyncValue.data([]);
  }
}

final historialPagosProvider =
    AsyncNotifierProvider<HistorialPagosProviderNotifier, List<HistorialPago>>(
      () => HistorialPagosProviderNotifier(),
    );
