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

  // Container(60) + Margin(4*2) = 68.0
  static const double _itemWidth = 68.0;

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

    double targetOffset = index * _itemWidth;

    // [Fix 2] Clamp targetOffset to maxScroll
    if (targetOffset > maxScroll) {
      targetOffset = maxScroll;
    }
    if (targetOffset < minScroll) {
      targetOffset = minScroll;
    }

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
    final days = widget.endDate.difference(widget.startDate).inDays + 1;
    final dates = List.generate(days > 0 ? days : 1,
        (index) => widget.startDate.add(Duration(days: index)));

    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: dates.length,
      itemBuilder: (context, index) {
        final date = dates[index];
        final isToday = DateUtils.isSameDay(date, DateTime.now());
        final isSelected = DateUtils.isSameDay(date, widget.selectedDate);
        final dateStr = DateFormat('MM/dd').format(date);

        return InkWell(
          onTap: () => widget.onDateSelected(date),
          child: Container(
            width: 60,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(dateStr,
                        style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface)),
                  ),
                ),
                if (isToday)
                  Positioned(
                    bottom: 6,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
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
