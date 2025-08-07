import 'package:flutter/material.dart';

class ScrollableSegmentedButtons extends StatefulWidget {
  final List<String> options;
  final Function(String) onSelected;
  final String selected;

  const ScrollableSegmentedButtons({
    required this.options,
    required this.onSelected,
    required this.selected,
    super.key,
  });

  @override
  State<ScrollableSegmentedButtons> createState() =>
      _ScrollableSegmentedButtonsState();
}

class _ScrollableSegmentedButtonsState
    extends State<ScrollableSegmentedButtons> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Color getTextColor(bool isSelected) {
      if (isSelected && isDarkMode) {
        return Colors.black;
      }
      if (isSelected && !isDarkMode) {
        return Colors.white;
      }
      return isDarkMode ? Colors.white : Colors.black;
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.options.map((option) {
          final isSelected = widget.selected == option;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(
                option,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: getTextColor(isSelected),
                ),
              ),
              selected: isSelected,
              onSelected: (_) => widget.onSelected(option),
              selectedColor: Theme.of(context).colorScheme.primary,
            ),
          );
        }).toList(),
      ),
    );
  }
}
