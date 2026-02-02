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

    // 邏輯：先抓 Linked (保持原順序)，再抓 Unlinked (保持原順序)，最後組合成新的 Map
    Map<String, dynamic> sortMembers(Map<String, dynamic> rawMembers) {
      final entries = rawMembers.entries.toList();

      // 1. 連結成員 (Linked)
      final linked = entries.where((e) {
        final mData = e.value as Map<String, dynamic>;
        return mData['isLinked'] == true;
      });

      // 2. 未連結成員 (Unlinked)
      final unlinked = entries.where((e) {
        final mData = e.value as Map<String, dynamic>;
        return mData['isLinked'] != true;
      });

      // 3. 重新組裝成有序的 Map
      // Map.fromEntries 會依照 List 的順序建立 Key，確保遍歷順序正確
      return Map.fromEntries([...linked, ...unlinked]);
    }

    // 取得原始 Map
    final rawMembers = data['members'] is Map
        ? Map<String, dynamic>.from(data['members'])
        : <String, dynamic>{};

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
      members: sortMembers(rawMembers),
      status: data['status'] as String? ?? 'ongoing',
      createdBy: data['createdBy'] as String? ?? '',
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
