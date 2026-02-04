import 'package:flutter/material.dart';
import 'package:iron_split/features/task/presentation/viewmodels/s17_task_locked_vm.dart';

class S17StatusView extends StatelessWidget {
  final LockedPageStatus pageStatus;

  const S17StatusView({
    super.key,
    required this.pageStatus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 根據 Mode 決定圖片路徑 (示意)
    final imagePath = pageStatus == LockedPageStatus.cleared
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
              pageStatus == LockedPageStatus.cleared
                  ? Icons.check_circle
                  : Icons.lock,
              size: 80,
              color: theme.colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
