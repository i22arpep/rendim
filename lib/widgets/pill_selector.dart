import 'package:flutter/material.dart';

class PillSelector<T> extends StatelessWidget {
  final List<T> options;
  final T selectedValue;
  final String Function(T) labelBuilder;
  final void Function(T) onChanged;

  const PillSelector({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = option == selectedValue;
        final theme = Theme.of(context);
        return GestureDetector(
          onTap: () => onChanged(option),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? theme.colorScheme.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? theme.colorScheme.primary : (theme.brightness == Brightness.dark ? Colors.white : Colors.black),
                width: 2,
              ),
            ),
            child: Text(
              labelBuilder(option),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isSelected
                    ? Colors.black
                    : (theme.brightness == Brightness.dark ? Colors.white : Colors.black),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
