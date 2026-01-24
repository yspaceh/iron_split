import 'package:cloud_firestore/cloud_firestore.dart';

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

  RecordItem copyWith({
    String? id,
    String? name,
    double? amount,
    String? memo,
    String? splitMethod,
    List<String>? splitMemberIds,
    Map<String, double>? splitDetails,
  }) {
    return RecordItem(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      memo: memo ?? this.memo,
      splitMethod: splitMethod ?? this.splitMethod,
      splitMemberIds: splitMemberIds ?? this.splitMemberIds,
      splitDetails: splitDetails ?? this.splitDetails,
    );
  }

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
  String? id;
  DateTime date;
  String title;
  int categoryIndex;
  String payerType;
  String? payerId;
  Map<String, dynamic>? paymentDetails;
  double amount;
  String currency;
  double exchangeRate;
  String splitMethod;
  List<String> splitMemberIds;
  Map<String, double>? splitDetails;
  String? memo;
  List<RecordItem> items;
  DateTime? createdAt;
  String? createdBy;

  RecordModel({
    this.id,
    required this.date,
    required this.title,
    this.categoryIndex = 0,
    this.payerType = 'prepay',
    this.payerId,
    this.paymentDetails,
    required this.amount,
    this.currency = 'TWD',
    this.exchangeRate = 1.0,
    this.splitMethod = 'even',
    this.splitMemberIds = const [],
    this.splitDetails,
    this.memo,
    this.items = const [],
    this.createdAt,
    this.createdBy,
  });

  RecordModel copyWith({
    String? id,
    DateTime? date,
    String? title,
    int? categoryIndex,
    String? payerType,
    String? payerId,
    Map<String, dynamic>? paymentDetails,
    double? amount,
    String? currency,
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
      categoryIndex: categoryIndex ?? this.categoryIndex,
      payerType: payerType ?? this.payerType,
      payerId: payerId ?? this.payerId,
      paymentDetails: paymentDetails ?? this.paymentDetails,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
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
      'categoryIndex': categoryIndex,
      'payerType': payerType,
      'payerId': payerId,
      'paymentDetails': paymentDetails,
      'amount': amount,
      'currency': currency,
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
      categoryIndex: data['categoryIndex'] ?? 0,
      payerType: data['payerType'] ?? 'prepay',
      payerId: data['payerId'],
      paymentDetails: data['paymentDetails'],
      amount: (data['amount'] ?? 0).toDouble(),
      currency: data['currency'] ?? 'TWD',
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
}
