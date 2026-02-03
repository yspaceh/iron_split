import 'package:flutter/material.dart';

class CircularCheckbox extends StatelessWidget {
  final bool isSelected;
  const CircularCheckbox({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? colorScheme.primary : colorScheme.outline,
          width: 2,
        ),
        color: isSelected ? colorScheme.primary : Colors.transparent,
      ),
      child: isSelected
          ? Icon(Icons.check_rounded, size: 16, color: Colors.white)
          : null,
    );
  }
}
