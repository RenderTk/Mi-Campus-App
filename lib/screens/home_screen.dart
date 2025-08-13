import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:usap_mobile/exceptions/token_refresh_failed_exception.dart';
import 'package:usap_mobile/models/student.dart';
import 'package:usap_mobile/providers/calendar_events_provider.dart';
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
