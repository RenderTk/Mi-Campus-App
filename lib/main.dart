import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/providers/user_provider.dart';
import 'package:usap_mobile/screens/home_screen.dart';
import 'package:usap_mobile/screens/login_screen.dart';
import 'package:usap_mobile/themes/app_theme.dart';
import 'package:usap_mobile/utils/app_providers.dart';

void main() {
  runApp(
    ProviderScope(observers: [AppProviderObservers()], child: const MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);

    return MaterialApp(
      title: 'Usap mobile',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
