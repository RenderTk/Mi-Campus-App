import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:usap_mobile/exceptions/token_refresh_failed_exception.dart';
import 'package:usap_mobile/models/student.dart';
import 'package:usap_mobile/providers/auth_provider.dart';
import 'package:usap_mobile/providers/student_provider.dart';
import 'package:usap_mobile/widgets/degree_progress_widget.dart';
import 'package:usap_mobile/widgets/quick_access_widget.dart';
import 'package:usap_mobile/widgets/upcoming_class_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final student = ref.watch(studentProvider);

    Widget buildLoadingState() => Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Image.asset(
              isDarkMode
                  ? "assets/usap_logo_small_dark.webp"
                  : "assets/usap_logo_small_light.webp",
              height: 120,
              width: 400,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Cargando...",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 25),
          const Center(child: CircularProgressIndicator()),
        ],
      ),
    );

    Widget buildErrorState() => const Scaffold(
      body: Center(
        child: Text(
          "Ocurrio un error al cargar los datos de su cuenta. Intente mas tarde.",
        ),
      ),
    );

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
                ref.invalidate(studentProvider);
              },
              icon: const Icon(FontAwesomeIcons.arrowsRotate),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 0,
                ),
                title: Text(
                  student.user.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  student.user.id,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: IconButton(
                  onPressed: () {
                    ref.read(isLoggedInProvider.notifier).setLoggedOut();
                  },
                  icon: const Icon(FontAwesomeIcons.rightFromBracket),
                ),
              ),
              DegreeProgressWidget(student: student),
              const QuickAccessWidget(),
              UpcomingClassWidget(student: student),
            ],
          ),
        ),

        bottomNavigationBar: NavigationBar(
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
          ref.read(isLoggedInProvider.notifier).setLoggedOut();
        }

        return buildErrorState();
      },
      loading: () => buildLoadingState(),
    );
  }
}
