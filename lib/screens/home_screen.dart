import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:usap_mobile/models/user.dart';
import 'package:usap_mobile/providers/auth_provider.dart';
import 'package:usap_mobile/providers/user_provider.dart';
import 'package:usap_mobile/widgets/degree_progress_widget.dart';
import 'package:usap_mobile/widgets/quick_access_widget.dart';
import 'package:usap_mobile/widgets/upcoming_class_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    Widget buildLoadingState() =>
        const Scaffold(body: Center(child: CircularProgressIndicator()));

    Widget buildErrorState() => const Scaffold(
      body: Center(
        child: Text(
          "Ocurrio un error al cargar los datos de su cuenta. Intente mas tarde.",
        ),
      ),
    );

    Widget buildSuccessState(User user) {
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
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Image(
                  image: NetworkImage(
                    isDarkMode
                        ? "https://ui-avatars.com/api/?rounded=true&name=${user.name}&background=1E293B&color=CBD5E1"
                        : "https://ui-avatars.com/api/?rounded=true&name=${user.name}&background=E2E8F0&color=1E293B",
                  ),
                ),
              ),
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
                  user.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  user.id,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: IconButton(
                  onPressed: () {
                    ref.read(isLoggedInProvider.notifier).setLoggedOut();
                  },
                  icon: const Icon(FontAwesomeIcons.rightFromBracket),
                ),
              ),
              DegreeProgressWidget(user: user),
              const QuickAccessWidget(),
              const UpcomingClassWidget(),
            ],
          ),
        ),

        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text('Menu'),
              ),
              ListTile(
                title: const Text('Cerrar Sesión'),
                onTap: () async {
                  await ref.read(authProvider.notifier).closeSession();
                },
              ),
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

    return user.when(
      data: (user) => buildSuccessState(user),
      error: (error, stackTrace) => buildErrorState(),
      loading: () => buildLoadingState(),
    );
  }
}
