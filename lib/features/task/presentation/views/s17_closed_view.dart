import 'package:flutter/material.dart';
import 'package:iron_split/gen/strings.g.dart';

class S13ClosedView extends StatelessWidget {
  final String taskId;

  const S13ClosedView({
    super.key,
    required this.taskId,
  });

  /// 處理下載 (TODO)
  void _handleDownload(BuildContext context) {
    // TODO: Implement CSV/PDF export logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Download feature coming soon (TODO)")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // 1. 圖片暫代 (之後可換動畫)
            // TODO: 之後換成動畫
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_clock, // 或 storefront, check_circle
                size: 64,
                color: theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 24),

            // 3. 資料保留提示 (30天)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      t.S13_Task_Dashboard.retention_notice,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // 4. 按鈕群組
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _handleDownload(context),
                icon: const Icon(Icons.download),
                label: Text(t.S13_Task_Dashboard.buttons.download),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
