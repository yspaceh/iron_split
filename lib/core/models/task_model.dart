import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iron_split/core/constants/currency_constants.dart';

class TaskModel {
  final String id;
  final String title;
  final String baseCurrency;
  final Map<String, dynamic> members;
  final bool isPrepay;
  final String mode;
  final String state;
  final String ownerId;
  final DateTime createdAt;
  final DateTime? startDate; // [新增] 支援日期軸
  final DateTime? endDate; // [新增] 支援日期軸

  TaskModel({
    required this.id,
    required this.title,
    required this.baseCurrency,
    required this.members,
    required this.isPrepay,
    required this.mode,
    required this.state,
    required this.ownerId,
    required this.createdAt,
    this.startDate,
    this.endDate,
  });

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      return TaskModel(
        id: doc.id,
        title: 'Unknown Task',
        baseCurrency: CurrencyOption.defaultCode,
        members: {},
        isPrepay: false,
        mode: 'active',
        state: 'pending',
        ownerId: '',
        createdAt: DateTime.now(),
      );
    }

    // Helper to parse dates
    DateTime? parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val);
      return null;
    }

    return TaskModel(
      id: doc.id,
      title: data['title'] as String? ?? '',
      baseCurrency:
          data['baseCurrency'] as String? ?? CurrencyOption.defaultCode,
      members: data['members'] is Map
          ? Map<String, dynamic>.from(data['members'])
          : {},
      isPrepay: data['isPrepay'] as bool? ?? false,
      mode: data['mode'] as String? ?? 'active',
      state: data['state'] as String? ?? 'pending',
      ownerId: data['ownerId'] as String? ?? '',
      createdAt: parseDate(data['createdAt']) ?? DateTime.now(),
      startDate: parseDate(data['startDate']),
      endDate: parseDate(data['endDate']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'baseCurrency': baseCurrency,
      'members': members,
      'isPrepay': isPrepay,
      'mode': mode,
      'state': state,
      'ownerId': ownerId,
      'createdAt': Timestamp.fromDate(createdAt),
      'startDate': startDate != null ? Timestamp.fromDate(startDate!) : null,
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
    };
  }
}
