import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_campus_app/providers/user_provider.dart';
import 'package:mi_campus_app/screens/home_screen/home_screen.dart';
import 'package:mi_campus_app/screens/login_screen.dart';
import 'package:mi_campus_app/themes/app_theme.dart';
import 'package:mi_campus_app/utils/app_providers.dart';
import 'package:timezone/data/latest_10y.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';

// Create a global instance of the notifications plugin
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting for Spanish locale
  await initializeDateFormatting('es_ES', null);

  // Initialize timezone settings and notifications
  await initNotificationsSettings(flutterLocalNotificationsPlugin);

  runApp(
    ProviderScope(observers: [AppProviderObservers()], child: const MyApp()),
  );
}

Future<void> initNotificationsSettings(
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
) async {
  // Initialize timezone data
  initializeTimeZones();

  // Set local timezone to Mexico City
  setLocalLocation(getLocation('America/Mexico_City'));

  // Configure notification settings
  const androidSettings = AndroidInitializationSettings(
    '@mipmap/ic_notification',
  );
  const iosSettings = DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  //Requesting permissions on Android 13 or higher
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.requestNotificationsPermission();
  // Initialize the notifications plugin
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);

    return MaterialApp(
      title: 'Mi Campus app',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
