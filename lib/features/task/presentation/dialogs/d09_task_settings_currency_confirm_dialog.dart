import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: D09_TaskSettings.CurrencyConfirm
class D09TaskSettingsCurrencyConfirmDialog extends StatelessWidget {
  const D09TaskSettingsCurrencyConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(t.D09_TaskSettings_CurrencyConfirm.title),
      content: Text(t.D09_TaskSettings_CurrencyConfirm.content),
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          child: Text(t.common.cancel),
        ),
        TextButton(
          onPressed: () => context.pop(true),
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.error,
          ),
          child: Text(t.common.confirm),
        ),
      ],
    );
  }
}
