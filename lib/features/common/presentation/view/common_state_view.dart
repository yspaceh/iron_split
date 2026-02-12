// lib/features/common/presentation/widgets/common_simple_state_view.dart

import 'package:flutter/material.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/common_bottom_sheet.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/gen/strings.g.dart';

class CommonStateView extends StatelessWidget {
  final LoadStatus status;
  final Widget? leading;
  final String title;
  final Widget child; // 成功時顯示的內容
  final AppErrorCodes? errorCode; // 錯誤代碼，用於對應翻譯
  final VoidCallback? onRetry;
  final bool isSheetMode;
  final List<Widget>? actions;

  const CommonStateView(
      {super.key,
      required this.status,
      required this.child,
      this.errorCode,
      this.onRetry,
      this.isSheetMode = false,
      required this.title,
      this.leading,
      this.actions});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    switch (status) {
      case LoadStatus.initial:
      case LoadStatus.loading:
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      case LoadStatus.success:
        return child;
      case LoadStatus.error:
        if (isSheetMode) {
          return CommonBottomSheet(
            title: title,
            bottomActionBar: onRetry != null
                ? StickyBottomActionBar.sheet(
                    children: [
                      AppButton(
                        text: t.common.buttons.retry,
                        type: AppButtonType.primary,
                        onPressed: onRetry,
                      ),
                    ],
                  )
                : null,
            children: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                ErrorMapper.map(context, code: errorCode),
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(t.S11_Invite_Confirm.title),
              centerTitle: true,
              leading: leading,
              actions: actions,
            ),
            bottomNavigationBar: onRetry != null
                ? StickyBottomActionBar.sheet(
                    children: [
                      AppButton(
                        text: t.common.buttons.retry,
                        type: AppButtonType.primary,
                        onPressed: onRetry,
                      ),
                    ],
                  )
                : null,
            body: SafeArea(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  ErrorMapper.map(context, code: errorCode),
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
              ),
            ),
          );
        }
    }
  }
}
