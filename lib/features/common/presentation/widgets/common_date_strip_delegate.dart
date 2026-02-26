import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/features/common/presentation/dialogs/d14_date_select_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/horizontal_date_list.dart'; // 引用上一輪做的列表
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart'; // 為了 Locale

class CommonDateStripDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final bool isEnlarged;

  // 為了讓 DatePicker 能夠正確判斷 Locale，我們可能需要 context，
  // 但 delegate 的 build 方法就有 context，所以邏輯寫在 build 裡即可。

  CommonDateStripDelegate({
    required this.height,
    required this.startDate,
    required this.endDate,
    required this.selectedDate,
    required this.onDateSelected,
    required this.isEnlarged,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final monthNum = DateFormat('MM').format(selectedDate);
    final displayState = context.watch<DisplayState>();
    final isEnlarged = displayState.isEnlarged;
    final double horizontalMargin = AppLayout.pageMargin(isEnlarged);

    return Container(
      height: height,
      color: colorScheme.surfaceContainerLow,
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      child: Row(
        children: [
          // 1. 共用的日曆按鈕
          // 1. 左側固定月份 (Sticky Month Label)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppLayout.radiusS),
              onTap: () async {
                // 點擊月份開啟日曆選擇器（要顯示繁體中文）
                Locale activeLocale =
                    TranslationProvider.of(context).flutterLocale;
                if (activeLocale.languageCode == 'zh') {
                  activeLocale = const Locale.fromSubtags(
                      languageCode: 'zh',
                      scriptCode: 'Hant',
                      countryCode: 'TW');
                }

                final picked = await D14DateSelectDialog.show<DateTime>(
                  context,
                  selectedDate: selectedDate,
                  startDate: startDate,
                  endDate: endDate,
                );
                if (picked != null) onDateSelected(picked);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12, top: 4, bottom: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 月份數字 (02)
                    Text(
                      monthNum,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900, // 特粗
                        color: colorScheme.primary, // 酒紅色
                        height: 1.0,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 分隔線 (Optional，視視覺需求決定要不要加)
          Container(
            width: 1,
            height: 32,
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            margin: const EdgeInsets.only(right: 4),
          ),

          // 2. 共用的日期滾動列表
          Expanded(
            child: HorizontalDateList(
              startDate: startDate,
              endDate: endDate,
              selectedDate: selectedDate,
              onDateSelected: onDateSelected,
              isEnlarged: isEnlarged,
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant CommonDateStripDelegate oldDelegate) {
    return oldDelegate.startDate != startDate ||
        oldDelegate.endDate != endDate ||
        oldDelegate.selectedDate != selectedDate;
  }
}
