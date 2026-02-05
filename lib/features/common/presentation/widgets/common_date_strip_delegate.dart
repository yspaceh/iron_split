import 'package:flutter/material.dart';
import 'package:iron_split/features/common/presentation/widgets/horizontal_date_list.dart'; // 引用上一輪做的列表
import 'package:iron_split/gen/strings.g.dart'; // 為了 Locale

class CommonDateStripDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  // 為了讓 DatePicker 能夠正確判斷 Locale，我們可能需要 context，
  // 但 delegate 的 build 方法就有 context，所以邏輯寫在 build 裡即可。

  CommonDateStripDelegate({
    required this.height,
    required this.startDate,
    required this.endDate,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);

    return Container(
      height: height,
      color: theme.colorScheme.surfaceContainerLow,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                // 1. 共用的日曆按鈕
                IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: () async {
                    // 處理 Locale 邏輯 (複製自您原本的代碼)
                    Locale activeLocale =
                        TranslationProvider.of(context).flutterLocale;
                    if (activeLocale.languageCode == 'zh') {
                      activeLocale = const Locale.fromSubtags(
                          languageCode: 'zh',
                          scriptCode: 'Hant',
                          countryCode: 'TW');
                    }

                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: startDate.subtract(const Duration(days: 365)),
                      lastDate: endDate.add(const Duration(days: 365)),
                      locale: activeLocale,
                      builder: (context, child) => Theme(
                        data: Theme.of(context).copyWith(
                            colorScheme: Theme.of(context).colorScheme),
                        child: child!,
                      ),
                    );
                    if (picked != null) onDateSelected(picked);
                  },
                ),

                // 2. 共用的日期滾動列表
                Expanded(
                  child: HorizontalDateList(
                    startDate: startDate,
                    endDate: endDate,
                    selectedDate: selectedDate,
                    onDateSelected: onDateSelected,
                  ),
                ),
              ],
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
