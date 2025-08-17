import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:usap_mobile/exceptions/token_refresh_failed_exception.dart';
import 'package:usap_mobile/models/student.dart';
import 'package:usap_mobile/providers/calendar_events_provider.dart';
import 'package:usap_mobile/providers/calendar_navigation_provider.dart';
import 'package:usap_mobile/providers/matricula_provider.dart';
import 'package:usap_mobile/providers/student_provider.dart';
import 'package:usap_mobile/providers/user_provider.dart';
import 'package:usap_mobile/widgets/error_state_widget.dart';
import 'package:usap_mobile/widgets/home_body_widgets/dashboard_widget.dart';
import 'package:usap_mobile/widgets/home_body_widgets/moodle_calendar_url_widget.dart';
import 'package:usap_mobile/widgets/home_body_widgets/perfil_widget.dart';
import 'package:usap_mobile/widgets/loading_state_widget.dart';
import 'package:usap_mobile/widgets/session_expired_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await ref.read(matriculaProvider.future);
    });
  }

  Widget _buildDeleteCalendarEventsButton() {
    final calendarEvents = ref.watch(calendarEventsProvider).valueOrNull;
    if (calendarEvents == null || calendarEvents.isEmpty) {
      return const SizedBox.shrink();
    }

    return IconButton(
      onPressed: () async {
        final bool? shouldDelete = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Eliminar todos los eventos'),
              content: const Text(
                '¿Estás seguro de que quieres eliminar todos los eventos del calendario? Esta acción no se puede deshacer.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Return false for cancel
                  },
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Return true for confirm
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError,
                  ),
                  child: const Text('Eliminar'),
                ),
              ],
            );
          },
        );

        // Only delete if user confirmed
        if (shouldDelete == true) {
          await ref.read(calendarEventsProvider.notifier).deleteAllEvents();
        }
      },
      icon: const Icon(FontAwesomeIcons.trash),
    );
  }

  @override
  Widget build(BuildContext context) {
    final student = ref.watch(studentProvider);

    Widget buildSuccessState(Student student) {
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;

      return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            isDarkMode
                ? "assets/usap_logo_small_dark.webp"
                : "assets/usap_logo_small_light.webp",
            height: 50,
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(FontAwesomeIcons.bell),
            ),
            IconButton(
              onPressed: () {
                ref.invalidate(userProvider);
                ref.invalidate(calendarEventsProvider);
              },
              icon: const Icon(FontAwesomeIcons.arrowsRotate),
            ),

            // only show this button when in calendar screen or MoodleCalendarUrlWidget
            if (selectedIndex == 1) ...[
              _buildDeleteCalendarEventsButton(),
              IconButton(
                onPressed: () => ref
                    .read(calendarNavigationProvider.notifier)
                    .showOpposite(),
                icon: const Icon(FontAwesomeIcons.calendarPlus),
              ),
            ],
          ],
        ),
        body: IndexedStack(
          index: selectedIndex,
          children: const [
            DashboardWidget(),
            MoodleCalendarUrlWidget(),
            PerfilWidget(),
          ],
        ),

        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, size: 30),
              label: 'Inicio',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined, size: 30),
              label: 'Calendario',
            ),

            NavigationDestination(
              icon: Icon(Icons.person_outline, size: 30),
              label: 'Perfil',
            ),
          ],
        ),
      );
    }

    return student.when(
      data: (student) => buildSuccessState(student),
      error: (error, stackTrace) {
        // si se intento refrescar el token y no se pudo, se cierra la sesion
        // y se redirige al login
        if (error is TokenRefreshFailedException) {
          return SessionExpiredWidget(
            onLogin: () async {
              await ref.read(userProvider.notifier).logOut();
            },
          );
        }

        return ErrorStateWidget(
          errorMessage:
              "Ocurrio un error al cargar los datos de su cuenta. Intente mas tarde.",
          onRetry: () async => ref.invalidate(userProvider),
          showExitButton: true,
        );
      },
      loading: () => const LoadingStateWidget(),
    );
  }
}
