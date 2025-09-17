import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_campus_app/providers/pantallas_bloqueadas_provider.dart';
import 'package:mi_campus_app/screens/calificaciones_screen/calificaciones_screen.dart';
import 'package:mi_campus_app/screens/horarios_screen/horarios_screen.dart';
import 'package:mi_campus_app/screens/materias_screen/materias_screen.dart';
import 'package:mi_campus_app/screens/pagos_screen/pagos_screen.dart';
import 'package:mi_campus_app/widgets/pantalla_bloqueada_dialog.dart';

bool isPantallaBloqueada(WidgetRef ref, PantallasBloqueadas pantalla) {
  final isBloqueada = ref
      .read(pantallasBloqueadasProvider.notifier)
      .isPantallaBloqueada(pantalla);
  return isBloqueada;
}

Future<bool> checkPantallaNavigation(
  BuildContext context,
  bool isBloqueada,
  String mensaje,
) async {
  if (isBloqueada) {
    return await showPantallaBloqueadaDialog(context, mensaje);
  }

  return false;
}

class _QuickAccessCard extends StatelessWidget {
  const _QuickAccessCard({
    required this.onTap,
    required this.title,
    required this.icon,
    required this.iconColor,
  });
  final VoidCallback onTap;
  final String title;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Card(
        color: Theme.of(
          context,
        ).colorScheme.secondaryFixed.withValues(alpha: 0.1),
        margin: const EdgeInsets.all(5),
        child: Container(
          height: 85,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: iconColor),
              const SizedBox(height: 10),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuickAccessWidget extends ConsumerWidget {
  const QuickAccessWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pantallasBloqueadas = ref.watch(pantallasBloqueadasProvider);

    return pantallasBloqueadas.when(
      data: (data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 0,
              ),
              child: Text(
                'Accesos rápidos',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _QuickAccessCard(
                    title: "Horarios",
                    icon: Icons.calendar_month_outlined,
                    iconColor: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HorariosScreen(),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: _QuickAccessCard(
                    title: "Calificaciones",
                    icon: Icons.checklist_outlined,
                    iconColor: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CalificacionesScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _QuickAccessCard(
                    title: "Materias",
                    icon: Icons.library_books_outlined,
                    iconColor: const Color.fromARGB(255, 206, 188, 26),
                    onTap: () async {
                      bool isBloqueada = isPantallaBloqueada(
                        ref,
                        PantallasBloqueadas.matricula,
                      );
                      bool canNavigate = await checkPantallaNavigation(
                        context,
                        isBloqueada,
                        'La matrícula ya está cerrada. Puedes entrar en modo lectura para ver tus materias seleccionadas.',
                      );

                      if (!context.mounted) return;
                      if (canNavigate || !isBloqueada) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MateriasScreen(
                              readOnlyMode: isBloqueada,
                            ), // if isBloqueada then readOnlyMode
                          ),
                        );
                      }
                    },
                  ),
                ),
                Expanded(
                  child: _QuickAccessCard(
                    title: "Pagos",
                    icon: Icons.payment_outlined,
                    iconColor: Colors.red,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PagosScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
      error: (error, stackTrace) => const SizedBox.shrink(),
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
