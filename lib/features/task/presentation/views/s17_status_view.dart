import 'package:flutter/material.dart';
import 'package:iron_split/gen/strings.g.dart';

enum LockedMode { closed, cleared }

class S17StatusView extends StatelessWidget {
  final LockedMode mode;

  const S17StatusView({
    super.key,
    required this.mode,
  });

  void _handleDownload(BuildContext context) {
    // TODO: Implement Download Logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Download (TODO)")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    // 根據 Mode 決定圖片路徑 (示意)
    final imagePath = mode == LockedMode.cleared
        ? 'assets/images/img_settlement_cleared.png'
        : 'assets/images/img_task_closed.png';

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // 中央視覺
          Image.asset(
            imagePath,
            width: 160,
            height: 160,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Icon(
              mode == LockedMode.cleared ? Icons.check_circle : Icons.lock,
              size: 80,
              color: theme.colorScheme.secondary,
            ),
          ),

          const SizedBox(height: 32),

          // Retention Notice
          Text(
            t.S17_Task_Locked.retention_notice,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          const Spacer(),

          // 下載按鈕 (唯一操作)
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _handleDownload(context),
              icon: const Icon(Icons.download),
              label: Text(t.S17_Task_Locked.buttons.download),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
