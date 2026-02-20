import 'package:flutter/material.dart';

class CommonAlertDialog extends StatelessWidget {
  final String title;
  final Widget? content;
  final List<Widget>? actions;

  const CommonAlertDialog({
    super.key,
    required this.title,
    this.content,
    this.actions,
  });

  /// Helper static method
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    Widget? content,
    List<Widget>? actions,
  }) {
    return showDialog(
      context: context,
      builder: (context) => CommonAlertDialog(
        title: title,
        content: content,
        actions: actions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(title, style: theme.textTheme.titleLarge),
      content: content, // 如果 content 為 null，AlertDialog 會自動處理佈局
      scrollable: true,
      actionsAlignment: MainAxisAlignment.end,
      actions: [
        if (actions == null) const SizedBox.shrink(),
        Row(
          children: actions!.map((child) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: child == actions!.last ? 0 : 12.0,
                ),
                child: child,
              ),
            );
          }).toList(),
        ),
      ],
      actionsPadding:
          const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 12),
    );
  }
}
