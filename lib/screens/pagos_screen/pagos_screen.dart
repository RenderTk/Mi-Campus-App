import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/exceptions/token_refresh_failed_exception.dart';
import 'package:usap_mobile/providers/historial_pago_provider.dart';
import 'package:usap_mobile/providers/user_provider.dart';
import 'package:usap_mobile/screens/pagos_screen/widgets/historial_pagos_filter.dart';
import 'package:usap_mobile/screens/pagos_screen/widgets/historial_pagos_widegt.dart';
import 'package:usap_mobile/screens/pagos_screen/widgets/pagos_buttons.dart';
import 'package:usap_mobile/screens/pagos_screen/widgets/pagos_pendientes_widget.dart';
import 'package:usap_mobile/widgets/session_expired_widget.dart';

class PagosScreen extends ConsumerStatefulWidget {
  const PagosScreen({super.key});

  @override
  ConsumerState<PagosScreen> createState() => _PagosScreenState();
}

class _PagosScreenState extends ConsumerState<PagosScreen> {
  PagosTab _selectedTab = PagosTab.pagosPendientes;
  Widget tabWidget = const PagosPendientesWidget();

  @override
  Widget build(BuildContext context) {
    final historialPagos = ref.watch(historialPagosProvider);
    tabWidget = _selectedTab == PagosTab.pagosPendientes
        ? const PagosPendientesWidget()
        : const HistorialPagosWidget();

    if (historialPagos.hasError) {
      final error = historialPagos.error;
      if (error is TokenRefreshFailedException) {
        return SessionExpiredWidget(
          onLogin: () async {
            Navigator.pop(context);
            await ref.watch(userProvider.notifier).logOut();
          },
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Mis Pagos")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            PagosButtons(
              selectedTab: _selectedTab,
              onTap: () {
                setState(() {
                  if (_selectedTab == PagosTab.pagosPendientes) {
                    _selectedTab = PagosTab.historialPagos;
                    return;
                  }
                  _selectedTab = PagosTab.pagosPendientes;
                });
              },
            ),
            if (_selectedTab == PagosTab.historialPagos) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: HistorialPagosFilters(),
              ),
            ],

            Expanded(child: tabWidget),
          ],
        ),
      ),
    );
  }
}
