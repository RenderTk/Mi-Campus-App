import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/models/historial_pago.dart';
import 'package:usap_mobile/providers/user_provider.dart';
import 'package:usap_mobile/services/payments_service.dart';

class HistorialPagosProviderNotifier
    extends AsyncNotifier<List<HistorialPago>> {
  final PaymentsService _paymentsService = PaymentsService();

  @override
  Future<List<HistorialPago>> build() async {
    state = const AsyncValue.loading();

    final user = await ref.watch(userProvider.future);
    if (user == null) {
      throw Exception('User not found');
    }

    final now = DateTime.now();
    final fechaInicio = DateTime(now.year, 1, 1);
    final historialPagos = await _paymentsService.getStudentHistorialPagos(
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

      final refreshedHistorialPagos = await _paymentsService
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
