import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/core/utils/daily_statistics_helper.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/core/models/record_model.dart';

class S13PersonalView extends StatelessWidget {
  final String taskId;

  const S13PersonalView({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Personal View'));
  }
}

class S13DailyStatsCard extends StatelessWidget {
  final List<QueryDocumentSnapshot> records;
  final DateTime targetDate;
  final String currency;

  const S13DailyStatsCard({
    super.key,
    required this.records,
    required this.targetDate,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Filter records for targetDate
    final dailyRecords = records.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final ts = data['date'] as Timestamp?;
      if (ts == null) return false;
      final date = ts.toDate().toLocal();
      return date.year == targetDate.year &&
          date.month == targetDate.month &&
          date.day == targetDate.day;
    }).toList();

    final recordModels =
        dailyRecords.map((doc) => RecordModel.fromFirestore(doc)).toList();
    final dailyTotal =
        DailyStatisticsHelper.calculateDailyExpense(recordModels);

    return Card(
      color: colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.S13_Task_Dashboard.daily_stats_title,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(currency, style: theme.textTheme.titleLarge),
                const SizedBox(width: 8),
                Text(
                  dailyTotal.toStringAsFixed(1),
                  style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSecondaryContainer),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
