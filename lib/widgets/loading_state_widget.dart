import 'package:flutter/material.dart';

class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
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
  }
}
