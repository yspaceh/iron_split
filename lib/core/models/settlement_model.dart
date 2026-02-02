import 'package:equatable/equatable.dart';

/// 結算成員模型
/// 用於 S30 結算確認頁面及後續寫入 Settlement Record
class SettlementMember extends Equatable {
  final String id;
  final String displayName;
  final String? avatar;
  final bool isLinked;

  // 金額資訊
  final double finalAmount; // 最終顯示金額 (Base + Remainder)
  final double baseAmount; // 換算後的本金 (不含餘額)
  final double remainderAmount; // 分配到的餘額調節金

  // 狀態旗標
  final bool isRemainderAbsorber; // 是否為本次餘額吸收者
  final bool isRemainderHidden; // 是否需要隱藏餘額 (Random 模式用)

  // 合併相關
  final bool isMergedHead; // 是否為代表成員
  final List<SettlementMember> subMembers; // 被合併的成員 (如果是 Head)

  const SettlementMember({
    required this.id,
    required this.displayName,
    this.avatar,
    required this.finalAmount,
    required this.baseAmount,
    required this.remainderAmount,
    required this.isRemainderAbsorber,
    required this.isLinked,
    this.isRemainderHidden = false,
    this.isMergedHead = false,
    this.subMembers = const [],
  });

  @override
  List<Object?> get props => [
        id,
        displayName,
        avatar,
        isLinked,
        finalAmount,
        baseAmount,
        remainderAmount,
        isRemainderAbsorber,
        isRemainderHidden,
        isMergedHead,
        subMembers,
      ];
}
