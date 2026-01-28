import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iron_split/core/constants/currency_constants.dart';

class RecordItem {
  String id;
  String name;
  double amount;
  String? memo;

  // Split Logic for this specific item
  String splitMethod; // 'even', 'percent', 'exact'
  List<String> splitMemberIds;
  Map<String, double>? splitDetails;

  RecordItem({
    required this.id,
    required this.name,
    required this.amount,
    this.memo,
    this.splitMethod = 'even',
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

  factory RecordItem.fromMap(Map<String, dynamic> map) {
    return RecordItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      memo: map['memo'],
      splitMethod: map['splitMethod'] ?? 'even',
      splitMemberIds: List<String>.from(map['splitMemberIds'] ?? []),
      splitDetails: map['splitDetails'] != null
          ? Map<String, double>.from(map['splitDetails'])
          : null,
    );
  }
}

class RecordModel {
  final String? id;
  final DateTime date;
  final String title;
  final String type; // 'expense' or 'income'
  final int categoryIndex;
  final String categoryId;
  final String payerType; // 'member', 'prepay'
  final String? payerId;
  final Map<String, dynamic>? paymentDetails;

  // --- 資料庫原始欄位 (保持不變以相容 Firestore) ---
  final double amount; // 存入 DB 的金額
  final String currencyCode; // 存入 DB 的幣別代碼 (String)
  final double exchangeRate; // 匯率
  // ----------------------------------------------

  final String splitMethod;
  final List<String> splitMemberIds;
  final Map<String, double>? splitDetails;
  final String? memo;
  final List<RecordItem> items;
  final DateTime? createdAt;
  final String? createdBy;

  RecordModel({
    this.id,
    required this.date,
    required this.title,
    this.type = 'expense',
    this.categoryIndex = 0,
    this.categoryId = 'other',
    this.payerType = 'prepay',
    this.payerId,
    this.paymentDetails,
    required this.amount,
    required this.currencyCode,
    this.exchangeRate = 1.0,
    this.splitMethod = 'even',
    this.splitMemberIds = const [],
    this.splitDetails,
    this.memo,
    this.items = const [],
    this.createdAt,
    this.createdBy,
  });

  // --- [新增] 語意化 Getters (核心邏輯) ---

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
    String? title,
    String? type,
    int? categoryIndex,
    String? categoryId,
    String? payerType,
    String? payerId,
    Map<String, dynamic>? paymentDetails,
    double? amount,
    String? currencyCode,
    double? exchangeRate,
    String? splitMethod,
    List<String>? splitMemberIds,
    Map<String, double>? splitDetails,
    String? memo,
    List<RecordItem>? items,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return RecordModel(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      type: type ?? this.type,
      categoryIndex: categoryIndex ?? this.categoryIndex,
      categoryId: categoryId ?? this.categoryId,
      payerType: payerType ?? this.payerType,
      payerId: payerId ?? this.payerId,
      paymentDetails: paymentDetails ?? this.paymentDetails,
      amount: amount ?? this.amount,
      currencyCode: currencyCode ?? this.currencyCode,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      splitMethod: splitMethod ?? this.splitMethod,
      splitMemberIds: splitMemberIds ?? this.splitMemberIds,
      splitDetails: splitDetails ?? this.splitDetails,
      memo: memo ?? this.memo,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'title': title,
      'type': type,
      'categoryIndex': categoryIndex,
      'categoryId': categoryId,
      'payerType': payerType,
      'payerId': payerId,
      'paymentDetails': paymentDetails,
      // 存入資料庫時使用原始欄位名稱
      'amount': amount,
      'currency': currencyCode,
      'exchangeRate': exchangeRate,
      'splitMethod': splitMethod,
      'splitMemberIds': splitMemberIds,
      'splitDetails': splitDetails,
      'memo': memo,
      'items': items.map((x) => x.toMap()).toList(),
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'createdBy': createdBy,
    };
  }

  factory RecordModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return RecordModel(
      id: doc.id,
      date: (data['date'] as Timestamp).toDate(),
      title: data['title'] ?? '',
      type: data['type'] ?? 'expense',
      categoryIndex: data['categoryIndex'] ?? 0,
      categoryId:
          data['categoryId'] ?? _mapCategoryIndexToId(data['categoryIndex']),
      payerType: data['payerType'] ?? 'prepay',
      payerId: data['payerId'],
      paymentDetails: data['paymentDetails'],

      // 從 DB 讀取原始欄位
      amount: (data['amount'] ?? 0).toDouble(),
      currencyCode: data['currency'] ?? CurrencyOption.defaultCode,
      exchangeRate: (data['exchangeRate'] ?? 1.0).toDouble(),

      splitMethod: data['splitMethod'] ?? 'even',
      splitMemberIds: List<String>.from(data['splitMemberIds'] ?? []),
      splitDetails: data['splitDetails'] != null
          ? Map<String, double>.from(data['splitDetails'])
          : null,
      memo: data['memo'],
      items: (data['items'] as List<dynamic>?)
              ?.map((x) => RecordItem.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
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
