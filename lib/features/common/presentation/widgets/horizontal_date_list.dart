import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HorizontalDateList extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const HorizontalDateList({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<HorizontalDateList> createState() => _HorizontalDateListState();
}

class _HorizontalDateListState extends State<HorizontalDateList> {
  final ScrollController _scrollController = ScrollController();

  static const double _itemWidth = 48;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToDate(widget.selectedDate, animate: false);
    });
  }

  @override
  void didUpdateWidget(covariant HorizontalDateList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!DateUtils.isSameDay(oldWidget.selectedDate, widget.selectedDate)) {
      _scrollToDate(widget.selectedDate, animate: true);
    }
  }

  void _scrollToDate(DateTime date, {bool animate = true}) {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    final maxScroll = position.maxScrollExtent;
    final minScroll = position.minScrollExtent;

    // [Fix 1] If content fits screen, don't scroll
    if (maxScroll <= 0) return;

    int index = date.difference(widget.startDate).inDays;
    if (index < 0) index = 0;

    double centeredOffset = (index * _itemWidth) -
        (MediaQuery.of(context).size.width / 2) +
        (_itemWidth / 2);

    // [Fix 2] Clamp targetOffset to maxScroll
    if (centeredOffset > maxScroll) centeredOffset = maxScroll;
    if (centeredOffset < minScroll) centeredOffset = minScroll;

    double targetOffset = index * _itemWidth;
    if (targetOffset > maxScroll) targetOffset = maxScroll;
    if (targetOffset < minScroll) targetOffset = minScroll;

    if (animate) {
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _scrollController.jumpTo(targetOffset);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final days = widget.endDate.difference(widget.startDate).inDays + 1;
    final dates = List.generate(days > 0 ? days : 1,
        (index) => widget.startDate.add(Duration(days: index)));

    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: dates.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final date = dates[index];
        final isToday = DateUtils.isSameDay(date, DateTime.now());
        final isSelected = DateUtils.isSameDay(date, widget.selectedDate);
        final String locale = Localizations.localeOf(context).toString();
        // 格式化：星期 (WED) 全大寫
        final weekStr = DateFormat('E', locale).format(date).toUpperCase();
        // 格式化：日期 (05)
        final dayStr = DateFormat('dd').format(date);

        return InkWell(
          onTap: () => widget.onDateSelected(date),
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: _itemWidth,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 40, // 豎向膠囊高度
                    width: 32, // 寬度
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary // 選中：酒紅底
                          : Colors.transparent, // 未選：透明
                      borderRadius: BorderRadius.circular(10), // 圓角矩形
                      // 如果是今天但未選中，可以加個外框？(可選)
                      // border: isToday && !isSelected
                      //    ? Border.all(color: colorScheme.outline, width: 1)
                      //    : null,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            dayStr,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? colorScheme.onPrimary // 選中：白字
                                  : colorScheme.onSurface, // 未選：深灰字
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      weekStr,
                      style: textTheme.labelSmall?.copyWith(
                        color: isSelected
                            ? colorScheme.onPrimary // 選中時星期也變紅？還是維持灰？
                            : colorScheme.onSurfaceVariant, // 灰色
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                if (isToday)
                  Positioned(
                    bottom: 11,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.onPrimary.withValues(alpha: 0.9)
                              : colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
