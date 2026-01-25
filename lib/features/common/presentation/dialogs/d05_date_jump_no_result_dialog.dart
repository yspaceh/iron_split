import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/gen/strings.g.dart';

class D05DateJumpNoResultDialog extends StatelessWidget {
  const D05DateJumpNoResultDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(t.D05_DateJump_NoResult.title),
      content: Text(t.D05_DateJump_NoResult.content),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(t.D05_DateJump_NoResult.action_ok),
        ),
      ],
    );
  }
}
