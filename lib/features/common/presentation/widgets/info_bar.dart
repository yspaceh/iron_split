import 'package:flutter/material.dart';

class InfoBar extends StatelessWidget {
  final Text text;
  const InfoBar({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.savings,
              color: theme.colorScheme.onTertiaryContainer, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: text,
          ),
        ],
      ),
    );
  }
}
