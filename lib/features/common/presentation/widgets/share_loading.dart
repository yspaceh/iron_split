import 'package:flutter/material.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/gen/strings.g.dart';

/// 用於全 App 統一顯示狀態圖示的元件
class SharePreparing extends StatelessWidget {
// 用於圖片 (PNG/SVG/Rive)

  const SharePreparing({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: AppLayout.spaceL),
            Text(
              t.common.preparing,
              style: textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
