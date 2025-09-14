import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingStateWidget extends StatefulWidget {
  const LoadingStateWidget({
    super.key,
    this.message = "Cargando",
    this.backgroundColor,
    this.foregroundColor,
  });

  final String message;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  State<LoadingStateWidget> createState() => _LoadingStateWidgetState();
}

class _LoadingStateWidgetState extends State<LoadingStateWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    final colorScheme = Theme.of(context).colorScheme;
    final bgColor = widget.backgroundColor ?? colorScheme.surface;

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Platform-specific indicator
            Center(
              child: platform == TargetPlatform.iOS
                  ? const CupertinoActivityIndicator(radius: 16)
                  : const CircularProgressIndicator(strokeWidth: 3),
            ),

            const SizedBox(height: 32),

            // Text with animated dots
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // Calcular cuántos puntos mostrar basado en el progreso de la animación
                final progress = _controller.value;
                int dotsCount = 0;

                if (progress >= 0 && progress < 0.25) {
                  dotsCount = 0;
                } else if (progress >= 0.25 && progress < 0.5) {
                  dotsCount = 1;
                } else if (progress >= 0.5 && progress < 0.75) {
                  dotsCount = 2;
                } else {
                  dotsCount = 3;
                }

                // Crear el texto con los puntos
                String dots = '.' * dotsCount;

                return Text(
                  '${widget.message}$dots',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
