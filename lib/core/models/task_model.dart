import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';

class TaskModel {
  final String id;
  final String name; // Was 'title'
  final String baseCurrency;
  final Map<String, dynamic> members;
  final String status; // Was 'mode'/'state', now 'ongoing' etc.
  final String createdBy; // Was 'ownerId'
  final String remainderRule; // Added to match S14
  final String? remainderAbsorberId;
  final DateTime createdAt;
  final DateTime updatedAt; // Added
  final DateTime? startDate;
  final DateTime? endDate;
  final int memberCount; // Added for convenience

  TaskModel({
    required this.id,
    required this.name,
    required this.baseCurrency,
    required this.members,
    required this.status,
    required this.createdBy,
    required this.remainderRule,
    required this.createdAt,
    required this.updatedAt,
    this.startDate,
    this.endDate,
    this.memberCount = 1,
    this.remainderAbsorberId,
  });

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      // Fallback for empty/error docs
      return TaskModel(
        id: doc.id,
        name: 'Error Task',
        baseCurrency: CurrencyConstants.defaultCode,
        members: {},
        status: 'unknown',
        createdBy: '',
        remainderRule: RemainderRuleConstants.defaultRule,
        remainderAbsorberId: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    // Helper to parse dates safely
    DateTime parseDate(dynamic val, {DateTime? fallback}) {
      if (val is Timestamp) return val.toDate();
      if (val is String) {
        return DateTime.tryParse(val) ?? fallback ?? DateTime.now();
      }
      return fallback ?? DateTime.now();
    }

    return TaskModel(
      id: doc.id,
      name: data['name'] as String? ?? '', // Matches D03 write
      baseCurrency:
          data['baseCurrency'] as String? ?? CurrencyConstants.defaultCode,
      members: data['members'] is Map
          ? Map<String, dynamic>.from(data['members'])
          : {},

      // Status handling (Bible: ongoing, closed, archived)
      status: data['status'] as String? ?? 'ongoing',

      // Captain/Owner handling (Bible: createdBy)
      createdBy: data['createdBy'] as String? ?? '',

      // Rule handling (S14: remainderRule)
      remainderRule: data['remainderRule'] as String? ??
          RemainderRuleConstants.defaultRule,
      remainderAbsorberId: data['remainderAbsorberId'] as String?,

      createdAt: parseDate(data['createdAt']),
      updatedAt: parseDate(data['updatedAt']),
      startDate:
          data['startDate'] != null ? parseDate(data['startDate']) : null,
      endDate: data['endDate'] != null ? parseDate(data['endDate']) : null,

      memberCount: (data['memberCount'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'baseCurrency': baseCurrency,
      'members': members,
      'status': status,
      'createdBy': createdBy,
      'remainderRule': remainderRule,
      'remainderAbsorberId': remainderAbsorberId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'startDate': startDate != null ? Timestamp.fromDate(startDate!) : null,
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'memberCount': memberCount,
    };
  }
}
