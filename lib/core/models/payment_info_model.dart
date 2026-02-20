// lib/core/models/payment_info_model.dart
import 'dart:convert';

enum PaymentMode { private, specific }

class PaymentInfoModel {
  final PaymentMode mode;
  final bool acceptCash;
  final String? bankName;
  final String? bankAccount;
  final List<PaymentAppInfo> paymentApps;

  const PaymentInfoModel({
    required this.mode,
    this.acceptCash = false,
    this.bankName,
    this.bankAccount,
    this.paymentApps = const [],
  });

  // 用於比較是否變更 (Deep Compare)
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentInfoModel &&
        other.mode == mode &&
        other.acceptCash == acceptCash &&
        other.bankName == bankName &&
        other.bankAccount == bankAccount &&
        _listEquals(other.paymentApps, paymentApps);
  }

  @override
  int get hashCode =>
      Object.hash(mode, acceptCash, bankName, bankAccount, paymentApps);

  // 用於序列化存入 SecureStorage / Firestore
  Map<String, dynamic> toMap() {
    return {
      'mode': mode.name,
      'acceptCash': acceptCash,
      'bankName': bankName,
      'bankAccount': bankAccount,
      'paymentApps': paymentApps.map((x) => x.toMap()).toList(),
    };
  }

  factory PaymentInfoModel.fromMap(Map<String, dynamic> map) {
    return PaymentInfoModel(
      mode: PaymentMode.values.byName(map['mode'] ?? 'private'),
      acceptCash: map['acceptCash'] ?? false,
      bankName: map['bankName'],
      bankAccount: map['bankAccount'],
      paymentApps: map['paymentApps'] is List
          ? (map['paymentApps'] as List)
              .map((x) =>
                  x is Map<String, dynamic> ? PaymentAppInfo.fromMap(x) : null)
              .whereType<PaymentAppInfo>()
              .toList()
          : [],
    );
  }

  String toJson() => json.encode(toMap());
  factory PaymentInfoModel.fromJson(String source) =>
      PaymentInfoModel.fromMap(json.decode(source));

  // Helper
  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

class PaymentAppInfo {
  final String name;
  final String link; // ID or URL

  const PaymentAppInfo({required this.name, required this.link});

  Map<String, dynamic> toMap() => {'name': name, 'link': link};

  factory PaymentAppInfo.fromMap(Map<String, dynamic> map) {
    return PaymentAppInfo(name: map['name'] ?? '', link: map['link'] ?? '');
  }

  @override
  bool operator ==(Object other) =>
      other is PaymentAppInfo && other.name == name && other.link == link;

  @override
  int get hashCode => Object.hash(name, link);
}
