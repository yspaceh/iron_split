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
      'startDate': startDate != null ? Timestamp.fromDate(startDate!) : null,
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'memberCount': memberCount,
      'settlement': settlement,
    };
  }
}

extension TaskModelMemberSorting on TaskModel {
  /// [新增] 全 App 統一的成員排序名單
  /// 1. 已連結者優先，按 joinedAt (加入時間) 排序
  /// 2. 未連結者在後，按 createdAt (生成時間) 排序
  List<MapEntry<String, dynamic>> get sortedMembers {
    final List<MapEntry<String, dynamic>> membersList =
        members.entries.toList();

    membersList.sort((a, b) {
      final dataA = a.value as Map<String, dynamic>;
      final dataB = b.value as Map<String, dynamic>;

      final bool isALinked = dataA['isLinked'] == true;
      final bool isBLinked = dataB['isLinked'] == true;

      // 1. 狀態不同：已連結優先
      if (isALinked != isBLinked) {
        return isALinked ? -1 : 1; // -1 代表 a 排在 b 前面
      }

      // 2. 狀態相同：比較時間
      if (isALinked) {
        // 皆為已連結：按加入時間 (joinedAt)
        final timeA = _parseTime(dataA['joinedAt']);
        final timeB = _parseTime(dataB['joinedAt']);
        return timeA.compareTo(timeB);
      } else {
        // 皆為未連結 (幽靈)：按生成時間 (createdAt)
        final timeA = _parseTime(dataA['createdAt']);
        final timeB = _parseTime(dataB['createdAt']);
        return timeA.compareTo(timeB);
      }
    });

    return membersList;
  }

  /// [防呆輔助] 處理 Firestore Timestamp、毫秒 int 與字串的差異
  int _parseTime(dynamic val) {
    if (val == null) return 0; // 避免 null 報錯，預設排在最前面
    if (val is Timestamp) return val.millisecondsSinceEpoch;
    if (val is int) return val;
    if (val is DateTime) return val.millisecondsSinceEpoch;
    if (val is String) {
      return DateTime.tryParse(val)?.millisecondsSinceEpoch ?? 0;
    }
    return 0;
  }
}
