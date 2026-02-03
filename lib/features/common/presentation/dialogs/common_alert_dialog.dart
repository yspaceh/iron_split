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
  /// 1. 加入泛型 <T>，讓呼叫者決定回傳型別 (例如 bool, String, int)。
  /// 2. 回傳 Future<T?>，這樣 showDialog 的結果才能傳出去。
  /// 3. 如果呼叫時不指定 <T>，它預設就是 dynamic，不接值也沒問題（相容舊代碼）。
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
      actions: actions,
      actionsPadding:
          const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 12),
    );
  }
}
