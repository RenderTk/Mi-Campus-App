import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/models/pago_pendiente.dart';
import 'package:usap_mobile/providers/user_provider.dart';
import 'package:usap_mobile/services/payments_data_service.dart';

class PagosPendientesNotifier extends AsyncNotifier<List<PagoPendiente>> {
  final _paymentsService = PaymentsDataService();
  @override
  Future<List<PagoPendiente>> build() async {
    state = const AsyncLoading();

    final user = await ref.watch(userProvider.future);
    if (user == null) {
      throw Exception('User not found');
    }
    final pendingPayments = await _paymentsService.getPendingPayments(user.id);
    return pendingPayments;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = await ref.read(userProvider.future);
      return await _paymentsService.getPendingPayments(user?.id ?? "");
    });
  }
}

final pagosPendientesProvider =
    AsyncNotifierProvider<PagosPendientesNotifier, List<PagoPendiente>>(
      () => PagosPendientesNotifier(),
    );
