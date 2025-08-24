import 'package:flutter/material.dart';

enum PagosTab { pagosPendientes, historialPagos }

class PagosButtons extends StatelessWidget {
  const PagosButtons({
    super.key,
    required this.selectedTab,
    required this.onTap,
  });
  final PagosTab selectedTab;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            child: Card(
              color: Theme.of(
                context,
              ).colorScheme.secondaryFixed.withValues(alpha: 0.1),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: selectedTab == PagosTab.pagosPendientes
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: selectedTab == PagosTab.pagosPendientes
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Pagos pendientes",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: selectedTab == PagosTab.pagosPendientes
                            ? Colors.white
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            child: Card(
              color: Theme.of(
                context,
              ).colorScheme.secondaryFixed.withValues(alpha: 0.1),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: selectedTab == PagosTab.historialPagos
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long,
                      color: selectedTab == PagosTab.historialPagos
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Historial de pagos",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: selectedTab == PagosTab.historialPagos
                            ? Colors.white
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
