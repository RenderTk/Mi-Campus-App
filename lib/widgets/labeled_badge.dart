import 'package:flutter/material.dart';

class LabeledBadge extends StatelessWidget {
  const LabeledBadge({
    super.key,
    required this.msg,
    required this.foregroundColor,
    required this.backgroundColor,
    this.icon,
    this.iconSize = 25,
  });
  final String msg;
  final Color foregroundColor;
  final Color backgroundColor;
  final IconData? icon;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: icon == null
          ? Text(
              msg,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: foregroundColor),
            )
          : Row(
              children: [
                Icon(icon, size: iconSize, color: foregroundColor),
                const SizedBox(width: 8),
                Text(
                  msg,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: foregroundColor),
                ),
              ],
            ),
    );
  }
}
