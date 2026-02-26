import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';

class TaskModel {
  final String id;
  final String name; // Was 'title'
  final String baseCurrency;
  final Map<String, TaskMember> members;
  final List<String> memberIds;
  final TaskStatus status; // Was 'mode'/'state', now 'ongoing' etc.
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
  final String? activeInviteCode;
  final DateTime? activeInviteExpiresAt;

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
    this.activeInviteCode,
    this.activeInviteExpiresAt,
  });

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() is Map ? doc.data() as Map<String, dynamic> : null;

    if (data == null) {
      // Fallback for empty/error docs
      return TaskModel(
        id: doc.id,
        name: 'Error Task',
        baseCurrency: CurrencyConstants.defaultCode,
        members: {},
        memberIds: [],
        status: TaskStatus.ongoing,
        createdBy: '',
        remainderRule: RemainderRuleConstants.defaultRule,
        remainderAbsorberId: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        settlement: null,
      );
    }

    // 邏輯：先抓 Linked (保持原順序)，再抓 Unlinked (保持原順序)，最後組合成新的 Map
    Map<String, TaskMember> sortMembers(Map<String, TaskMember> members) {
      final entries = members.entries.toList();
      entries.sort((a, b) => TaskModel.compareMembers(a.value, b.value));
      return Map.fromEntries(entries);
    }

    // 取得原始 Map
    final rawMembers =
        data['members'] is Map ? data['members'] as Map<String, dynamic> : {};

    final parsedMembers = rawMembers.map<String, TaskMember>((key, value) {
      final String safeKey = key.toString();
      return MapEntry(
        safeKey,
        value is Map<String, dynamic>
            ? TaskMember.fromMap(safeKey, value)
            : TaskMember.fromMap(safeKey, {}), // 提供預設空 Map 或處理錯誤
      );
    });

    List<String> parsedMemberIds = [];
    if (data['memberIds'] is List) {
      parsedMemberIds =
          (data['memberIds'] as List).whereType<String>().toList();
    } else {
      // 兼容舊資料：自動補齊
      parsedMemberIds = rawMembers.keys.whereType<String>().toList();
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
      members: sortMembers(parsedMembers),
      memberIds: parsedMemberIds,
      status: _parseStatus(data['status'] as String?),
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
      settlement: data['settlement'] is Map
          ? data['settlement'] as Map<String, dynamic>
          : null,
      memberCount:
          (data['memberCount'] as num?)?.toInt() ?? parsedMemberIds.length,
      activeInviteCode: data['activeInviteCode'] as String?,
      activeInviteExpiresAt: data['activeInviteExpiresAt'] != null
          ? parseDate(data['activeInviteExpiresAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'baseCurrency': baseCurrency,
      'members': members.map((key, value) => MapEntry(key, value.toMap())),
      'memberIds': members.keys.toList(),
      'status': status.name,
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
      'activeInviteCode': activeInviteCode,
      'activeInviteExpiresAt': activeInviteExpiresAt != null
          ? Timestamp.fromDate(activeInviteExpiresAt!)
          : null,
    };
  }

  //  靜態排序邏輯 (讓外部也能用)
  static int compareMembers(TaskMember a, TaskMember b) {
    // 1. 狀態不同：已連結優先 (a 跟 b 狀態不一樣時，必定是一個 true 一個 false)
    if (a.isLinked != b.isLinked) {
      return a.isLinked ? -1 : 1;
    }

    // --- 此時 a 和 b 的 isLinked 狀態必定「完全相同」 ---

    int timeDiff;

    if (a.isLinked) {
      // 2a. 兩人都是「已連結 (true)」：比較 joinedAt
      timeDiff = a.joinedAt.compareTo(b.joinedAt);
    } else {
      // 2b. 兩人都是「未連結 (false)」：比較 createdAt
      timeDiff = a.createdAt.compareTo(b.createdAt);
    }

    // 如果時間分得出先後，就直接回傳
    if (timeDiff != 0) {
      return timeDiff;
    }

    // 3. 時間「完全相同」：比較名字 (確保順序絕對穩定，不會亂跳)
    return a.displayName.compareTo(b.displayName);
  }

  // 直接把 Getter 寫在 TaskModel 類別裡面，不使用 Extension
  List<MapEntry<String, TaskMember>> get sortedMembers {
    final membersList = members.entries.toList();
    membersList.sort((a, b) {
      return TaskModel.compareMembers(a.value, b.value);
    });
    return membersList;
  }

  // 直接把 Getter 寫在 TaskModel 類別裡面，不使用 Extension
  List<TaskMember> get sortedMembersList {
    final list = members.values.toList();
    list.sort(TaskModel.compareMembers);
    return list;
  }

  static TaskStatus _parseStatus(String? statusStr) {
    // 從 Enum 中找出名字相符的，如果找不到就預設回傳 ongoing
    return TaskStatus.values.firstWhere(
      (e) => e.name == statusStr,
      orElse: () => TaskStatus.ongoing,
    );
  }
}

class TaskMember {
  final String id; // uid
  final String displayName;
  final String? avatar;
  final bool isLinked;
  final String role; // 'captain' | 'member'
  final DateTime joinedAt;
  final DateTime createdAt;
  final double prepaid;
  final double expense;
  final bool hasSeenRoleIntro;
  final bool hasRerolled;
  final double defaultSplitRatio;

  // Constructor
  TaskMember({
    required this.id,
    required this.displayName,
    this.avatar,
    required this.isLinked,
    required this.role,
    required this.joinedAt,
    required this.createdAt,
    this.prepaid = 0.0,
    this.expense = 0.0,
    this.hasSeenRoleIntro = false,
    this.hasRerolled = false,
    this.defaultSplitRatio = 1.0,
  });

  // Factory: 從 Firestore Map 轉換
  // 這裡是「防呆」的第一線，所有 ?? '' 都在這裡處理完
  factory TaskMember.fromMap(String id, Map<String, dynamic> data) {
    return TaskMember(
      id: id,
      // 強制給預設值，解決 Null Error
      displayName: data['displayName'] as String? ?? 'Unknown Member',
      avatar: data['avatar'] as String?,
      isLinked: data['isLinked'] as bool? ?? false,
      role: data['role'] as String? ?? 'member',
      joinedAt: _parseTime(data['joinedAt']),
      createdAt: _parseTime(data['createdAt']),
      prepaid: (data['prepaid'] as num?)?.toDouble() ?? 0.0,
      expense: (data['expense'] as num?)?.toDouble() ?? 0.0,
      hasSeenRoleIntro: data['hasSeenRoleIntro'] as bool? ?? false,
      hasRerolled: data['hasRerolled'] as bool? ?? false,
      defaultSplitRatio: (data['defaultSplitRatio'] as num?)?.toDouble() ?? 1.0,
    );
  }

  // Helper: 判斷是否為隊長
  bool get isCaptain => role == 'captain';

  // Helper: 判斷是否為 Ghost
  bool get isGhost => !isLinked;

  // 時間解析 helper
  static DateTime _parseTime(dynamic val) {
    if (val == null) return DateTime.fromMillisecondsSinceEpoch(0);
    if (val is Timestamp) return val.toDate();
    if (val is String) {
      return DateTime.tryParse(val) ?? DateTime.fromMillisecondsSinceEpoch(0);
    }
    if (val is int) {
      // 兼容微秒與毫秒
      if (val > 10000000000000) {
        return DateTime.fromMicrosecondsSinceEpoch(val);
      }
      return DateTime.fromMillisecondsSinceEpoch(val);
    }
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  // 轉回 Map (寫入 DB 用)
  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'displayName': displayName,
      'avatar': avatar,
      'isLinked': isLinked,
      'role': role,
      'joinedAt': Timestamp.fromDate(joinedAt),
      'createdAt': Timestamp.fromDate(createdAt),
      'prepaid': prepaid,
      'expense': expense,
      'hasSeenRoleIntro': hasSeenRoleIntro,
      'hasRerolled': hasRerolled,
      'defaultSplitRatio': defaultSplitRatio,
    };
  }
}
