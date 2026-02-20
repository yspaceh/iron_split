import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/split_method_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';

class RecordDetail {
  String id;
  String name;
  double amount;
  String? memo;

  // Split Logic for this specific item
  String splitMethod; // 'even', 'percent', 'exact'
  List<String> splitMemberIds;
  Map<String, double>? splitDetails;

  RecordDetail({
    required this.id,
    required this.name,
    required this.amount,
    this.memo,
    this.splitMethod = SplitMethodConstant.defaultMethod,
    required this.splitMemberIds,
    this.splitDetails,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'memo': memo,
      'splitMethod': splitMethod,
      'splitMemberIds': splitMemberIds,
      'splitDetails': splitDetails,
    };
  }

  factory RecordDetail.fromMap(Map<String, dynamic> map) {
    return RecordDetail(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      memo: map['memo'],
      splitMethod: map['splitMethod'] ?? SplitMethodConstant.defaultMethod,
      splitMemberIds: map['splitMemberIds'] is List
          ? (map['splitMemberIds'] as List).whereType<String>().toList()
          : [],
      splitDetails: map['splitDetails'] is Map
          ? (map['splitDetails'] as Map).map(
              (key, value) =>
                  MapEntry(key.toString(), (value as num).toDouble()),
            )
          : null,
    );
  }
}

class RecordModel {
  final String? id;
  final DateTime date;
  final String? dateString;
  final String title;
  final RecordType type; // 'expense' or 'income'
  final int categoryIndex;
  final String categoryId;
  final PayerType payerType; // 'member', 'prepay'
  final List<String> payersId;
  final Map<String, dynamic>? paymentDetails;
  final double amount; // 存入 DB 的金額
  final String currencyCode; // 存入 DB 的幣別代碼 (String)
  final double exchangeRate; // 匯率
  final double remainder;
  final String splitMethod;
  final List<String> splitMemberIds;
  final Map<String, double>? splitDetails;
  final String? memo;
  final List<RecordDetail> details;
  final DateTime? createdAt;
  final String? createdBy;

  RecordModel({
    this.id,
    required this.date,
    this.dateString,
    required this.title,
    this.type = RecordType.expense,
    this.categoryIndex = 0,
    this.categoryId = 'other',
    this.payerType = PayerType.prepay,
    this.payersId = const [],
    this.paymentDetails,
    required this.amount,
    required this.currencyCode,
    this.exchangeRate = 1.0,
    this.remainder = 0.0,
    this.splitMethod = SplitMethodConstant.defaultMethod,
    this.splitMemberIds = const [],
    this.splitDetails,
    this.memo,
    this.details = const [],
    this.createdAt,
    this.createdBy,
  });

  // ---  語意化 Getters (核心邏輯) ---

  /// [原始金額]
  /// 對應單據/發票上的金額 (Transaction Amount)。
  /// UI 顯示單據詳情或編輯時使用此值。
  double get originalAmount => amount;

  /// [原始幣別]
  /// 對應單據/發票上的幣別代碼 (Transaction Currency)。
  String get originalCurrencyCode => currencyCode;

  /// [結算幣別價值]
  /// 用於：計算總帳、BalanceCard 加總、比例圖表。
  /// 邏輯：原始金額 * 匯率
  double get baseAmount => amount * exchangeRate;

  // ----------------------------------------

  RecordModel copyWith({
    String? id,
    DateTime? date,
    String? dateString,
    String? title,
    RecordType? type,
    int? categoryIndex,
    String? categoryId,
    PayerType? payerType,
    List<String>? payersId,
    Map<String, dynamic>? paymentDetails,
    double? amount,
    String? currencyCode,
    double? exchangeRate,
    double? remainder,
    String? splitMethod,
    List<String>? splitMemberIds,
    Map<String, double>? splitDetails,
    String? memo,
    List<RecordDetail>? details,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return RecordModel(
      id: id ?? this.id,
      date: date ?? this.date,
      dateString: dateString ?? this.dateString,
      title: title ?? this.title,
      type: type ?? this.type,
      categoryIndex: categoryIndex ?? this.categoryIndex,
      categoryId: categoryId ?? this.categoryId,
      payerType: payerType ?? this.payerType,
      payersId: payersId ?? this.payersId,
      paymentDetails: paymentDetails ?? this.paymentDetails,
      amount: amount ?? this.amount,
      currencyCode: currencyCode ?? this.currencyCode,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      remainder: remainder ?? this.remainder,
      splitMethod: splitMethod ?? this.splitMethod,
      splitMemberIds: splitMemberIds ?? this.splitMemberIds,
      splitDetails: splitDetails ?? this.splitDetails,
      memo: memo ?? this.memo,
      details: details ?? this.details,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'dateString':
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      'title': title,
      'type': type.code,
      'categoryIndex': categoryIndex,
      'categoryId': categoryId,
      'payerType': payerType.code,
      'payersId': payersId,
      'paymentDetails': paymentDetails,
      // 存入資料庫時使用原始欄位名稱
      'amount': amount,
      'currency': currencyCode,
      'exchangeRate': exchangeRate,
      'remainder': remainder,
      'splitMethod': splitMethod,
      'splitMemberIds': splitMemberIds,
      'splitDetails': splitDetails,
      'memo': memo,
      'details': details.map((x) => x.toMap()).toList(),
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'createdBy': createdBy,
    };
  }

  factory RecordModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data =
        doc.data() is Map ? doc.data() as Map<String, dynamic> : {};
    DateTime baseDate =
        (data['date'] as Timestamp?)?.toDate() ?? DateTime.now();
    final dateStr = data['dateString'] as String?;
    // 就用使用者的「本地手機」重新建構這一天，並強制定在中午 12 點！
    if (dateStr != null) {
      // tryParse 遇到格式錯誤會安全回傳 null，不會閃退
      final parsedDate = DateTime.tryParse(dateStr);
      if (parsedDate != null) {
        baseDate = parsedDate;
      }
    }
    final DateTime finalDate =
        DateTime(baseDate.year, baseDate.month, baseDate.day, 12);
    return RecordModel(
      id: doc.id,
      date: finalDate,
      dateString: data['dateString'],
      title: data['title'] ?? '',
      type: RecordType.fromCode(data['type'] as String?),
      categoryIndex: data['categoryIndex'] ?? 0,
      categoryId:
          data['categoryId'] ?? _mapCategoryIndexToId(data['categoryIndex']),
      payerType: PayerType.fromCode(data['payerType'] as String?),
      payersId: data['payersId'] is List
          ? (data['payersId'] as List).whereType<String>().toList()
          : (data['payersId'] is String ? [data['payersId'] as String] : []),
      paymentDetails: data['paymentDetails'],

      // 從 DB 讀取原始欄位
      amount: (data['amount'] ?? 0).toDouble(),
      currencyCode: data['currency'] ?? CurrencyConstants.defaultCode,
      exchangeRate: (data['exchangeRate'] ?? 1.0).toDouble(),
      remainder: (data['remainder'] ?? 0).toDouble(),
      splitMethod: data['splitMethod'] ?? SplitMethodConstant.defaultMethod,
      splitMemberIds: data['splitMemberIds'] is List
          ? (data['splitMemberIds'] as List).whereType<String>().toList()
          : [],
      splitDetails: data['splitDetails'] is Map
          ? (data['splitDetails'] as Map).map(
              (key, value) =>
                  MapEntry(key.toString(), (value as num).toDouble()),
            )
          : null,
      memo: data['memo'],
      details: data['details'] is List
          ? (data['details'] as List)
              .map((x) =>
                  x is Map<String, dynamic> ? RecordDetail.fromMap(x) : null)
              .whereType<RecordDetail>()
              .toList()
          : [],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      createdBy: data['createdBy'],
    );
  }

  static String _mapCategoryIndexToId(int? index) {
    // 簡單的 mapping，維持原樣
    switch (index) {
      case 0:
        return 'fastfood';
      case 1:
        return 'directions_bus';
      case 2:
        return 'hotel';
      case 3:
        return 'shopping_bag';
      case 4:
        return 'movie';
      case 5:
        return 'directions_bus';
      case 6:
        return 'fastfood';
      default:
        return 'more_horiz';
    }
  }
}
