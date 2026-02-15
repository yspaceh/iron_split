// lib/features/common/presentation/widgets/common_simple_state_view.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  final String? errorActionText;
  final VoidCallback? onErrorAction;
  final bool isSheetMode;
  final List<Widget>? actions;
  final Color? loadingBackgroundColor;
  final Color? loadingForegroundColor;

  const CommonStateView(
      {super.key,
      required this.status,
      required this.child,
      this.errorCode,
      this.onErrorAction,
      this.isSheetMode = false,
      required this.title,
      this.leading,
      this.actions,
      this.errorActionText,
      this.loadingBackgroundColor,
      this.loadingForegroundColor});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    switch (status) {
      case LoadStatus.initial:
      case LoadStatus.loading:
        return Scaffold(
          backgroundColor:
              loadingBackgroundColor ?? theme.colorScheme.surfaceContainerLow,
          body: Center(
            child: CircularProgressIndicator(
                color: loadingForegroundColor ?? theme.colorScheme.primary),
          ),
        );
      case LoadStatus.success:
        return child;
      case LoadStatus.error:
        if (errorCode == AppErrorCodes.unauthorized) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // 避免重複導航 (如果已經在 S00 就不用跳了)
            if (GoRouter.of(context)
                    .routerDelegate
                    .currentConfiguration
                    .fullPath !=
                '/') {
              context.goNamed('S00');
            }
          });
          // 導航發生前，顯示轉圈圈或空白，不要顯示錯誤文字
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (isSheetMode) {
          return CommonBottomSheet(
            title: title,
            bottomActionBar: onErrorAction != null
                ? StickyBottomActionBar.sheet(
                    children: [
                      AppButton(
                        text: errorActionText ?? t.common.buttons.retry,
                        type: AppButtonType.primary,
                        onPressed: onErrorAction,
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
              title: Text(title),
              centerTitle: true,
              leading: leading,
              actions: actions,
            ),
            bottomNavigationBar: onErrorAction != null
                ? StickyBottomActionBar.sheet(
                    children: [
                      AppButton(
                        text: errorActionText ?? t.common.buttons.retry,
                        type: AppButtonType.primary,
                        onPressed: onErrorAction,
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
