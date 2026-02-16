import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';

class TaskModel {
  final String id;
  final String name; // Was 'title'
  final String baseCurrency;
  final Map<String, dynamic> members;
  final List<String> memberIds;
  final String status; // Was 'mode'/'state', now 'ongoing' etc.
  final String createdBy; // Was 'ownerId'
  final String remainderRule; // Added to match S14
  final String? remainderAbsorberId;
  final DateTime createdAt;
  final DateTime? finalizedAt;
  final DateTime updatedAt; // Added
  final DateTime? startDate;
  final DateTime? endDate;
  final int memberCount; // Added for convenience
  final Map<String, dynamic>? settlement; // [Bible 7.4] 結算快照

  TaskModel({
    required this.id,
    required this.name,
    required this.baseCurrency,
    required this.members,
    required this.memberIds,
    required this.status,
    required this.createdBy,
    required this.remainderRule,
    required this.createdAt,
    required this.updatedAt,
    this.finalizedAt,
    this.startDate,
    this.endDate,
    this.memberCount = 1,
    this.remainderAbsorberId,
    this.settlement,
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
        memberIds: [],
        status: 'unknown',
        createdBy: '',
        remainderRule: RemainderRuleConstants.defaultRule,
        remainderAbsorberId: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        settlement: data!['settlement'] as Map<String, dynamic>?,
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

    List<String> parsedMemberIds = [];
    if (data['memberIds'] is List) {
      parsedMemberIds = List<String>.from(data['memberIds']);
    } else {
      // 兼容舊資料：自動補齊
      parsedMemberIds = rawMembers.keys.toList();
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
      members: sortMembers(rawMembers),
      memberIds: parsedMemberIds,
      status: data['status'] as String? ?? 'ongoing',
      createdBy: data['createdBy'] as String? ?? '',
      remainderRule: data['remainderRule'] as String? ??
          RemainderRuleConstants.defaultRule,
      remainderAbsorberId: data['remainderAbsorberId'] as String?,
      createdAt: parseDate(data['createdAt']),
      updatedAt: parseDate(data['updatedAt']),
      finalizedAt:
          data['finalizedAt'] != null ? parseDate(data['finalizedAt']) : null,
      startDate:
          data['startDate'] != null ? parseDate(data['startDate']) : null,
      endDate: data['endDate'] != null ? parseDate(data['endDate']) : null,
      settlement: data['settlement'] as Map<String, dynamic>?,
      memberCount:
          (data['memberCount'] as num?)?.toInt() ?? parsedMemberIds.length,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'baseCurrency': baseCurrency,
      'members': members,
      'memberIds': members.keys.toList(),
      'status': status,
      'createdBy': createdBy,
      'remainderRule': remainderRule,
      'remainderAbsorberId': remainderAbsorberId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'finalizedAt':
          finalizedAt != null ? Timestamp.fromDate(finalizedAt!) : null,
      'startDate': startDate != null ? Timestamp.fromDate(startDate!) : null,
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'memberCount': memberCount,
      'settlement': settlement,
    };
  }

  //  靜態排序邏輯 (讓外部也能用)
  static int compareMemberData(
      Map<String, dynamic> dataA, Map<String, dynamic> dataB) {
    final bool isALinked = dataA['isLinked'] == true;
    final bool isBLinked = dataB['isLinked'] == true;

    // 1. 狀態不同：已連結優先
    if (isALinked != isBLinked) {
      return isALinked ? -1 : 1;
    }

    // 2. 狀態相同：比較時間
    if (isALinked) {
      // 皆為已連結：按 joinedAt
      final timeA = _parseTimeStatic(dataA['joinedAt']);
      final timeB = _parseTimeStatic(dataB['joinedAt']);
      return timeA.compareTo(timeB);
    } else {
      // 皆為未連結：按 createdAt
      final timeA = _parseTimeStatic(dataA['createdAt']);
      final timeB = _parseTimeStatic(dataB['createdAt']);
      return timeA.compareTo(timeB);
    }
  }

  // 靜態時間解析 (將原本的 _parseTime 改為 static)
  static int _parseTimeStatic(dynamic val) {
    if (val == null) return 0;
    if (val is Timestamp) return val.millisecondsSinceEpoch;
    if (val is int) return val;
    if (val is DateTime) return val.millisecondsSinceEpoch;
    if (val is String) {
      return DateTime.tryParse(val)?.millisecondsSinceEpoch ?? 0;
    }
    return 0;
  }
}

// Extension 改為呼叫上面的靜態方法
extension TaskModelMemberSorting on TaskModel {
  List<MapEntry<String, dynamic>> get sortedMembers {
    final List<MapEntry<String, dynamic>> membersList =
        members.entries.toList();

    // 直接使用靜態方法
    membersList.sort((a, b) {
      return TaskModel.compareMemberData(
          a.value as Map<String, dynamic>, b.value as Map<String, dynamic>);
    });

    return membersList;
  }
}
