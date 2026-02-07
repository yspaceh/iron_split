// lib/features/common/presentation/widgets/common_simple_state_view.dart

import 'package:flutter/material.dart';

class CommonStateView extends StatelessWidget {
  final String message;

  const CommonStateView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        message,
        style: theme.textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
