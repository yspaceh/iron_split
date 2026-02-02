import 'package:flutter/material.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';

enum AvatarStackType {
  stack, // 疊加模式 (Google Style, S30/S17 使用)
  wrap, // 換行平鋪模式 (舊版 B02 使用)
}

class CommonAvatarStack extends StatelessWidget {
  final List<Map<String, dynamic>> allMembers;
  final List<String> targetMemberIds;
  final double radius;
  final double? fontSize;

  // --- Stack 模式專用參數 ---
  final double overlapRatio;
  final int? limit;
  final Color? borderColor;

  // --- 模式控制 ---
  final AvatarStackType type;

  const CommonAvatarStack(
      {super.key,
      required this.allMembers,
      required this.targetMemberIds,
      this.radius = 12,
      this.fontSize,
      this.overlapRatio = 0.75,
      this.limit,
      this.borderColor,
      this.type = AvatarStackType.wrap});

  @override
  Widget build(BuildContext context) {
    // 1. 篩選有效成員
    final activeMembers =
        allMembers.where((m) => targetMemberIds.contains(m['id'])).toList();

    if (activeMembers.isEmpty) return const SizedBox();

    // 根據模式回傳不同 UI
    if (type == AvatarStackType.wrap) {
      return _buildWrap(activeMembers);
    } else {
      return _buildStack(context, activeMembers);
    }
  }

  // --- 舊有的 Wrap 模式 (B02 之前的行為) ---
  Widget _buildWrap(List<Map<String, dynamic>> members) {
    // 如果想要完全保留舊行為，這裡不應該有 limit 邏輯，或者依需求加上
    return Container(
      constraints: const BoxConstraints(maxWidth: 220),
      child: Wrap(
        alignment: WrapAlignment.end,
        spacing: 4,
        runSpacing: 4,
        children: members.map((member) {
          return CommonAvatar(
            avatarId: member['avatar'],
            name: member['displayName'],
            radius: radius,
            fontSize: fontSize,
            isLinked: member['isLinked'] ?? false,
          );
        }).toList(),
      ),
    );
  }

  // --- 新的 Stack 模式 (S30/S17 使用) ---
  Widget _buildStack(BuildContext context, List<Map<String, dynamic>> members) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 處理 Limit
    List<Map<String, dynamic>> displayMembers = members;
    int remainder = 0;

    if (limit != null && members.length > limit!) {
      displayMembers = members.take(limit!).toList();
      remainder = members.length - limit!;
    }

    final double avatarSize = radius * 2;
    final double shiftAmount = avatarSize * overlapRatio;

    // 計算總寬度
    final int totalItems = displayMembers.length + (remainder > 0 ? 1 : 0);
    // 總寬 = 第一個頭像全寬 + (剩下頭像 * 位移量)
    // 修正公式：Stack 寬度 = Size + (N-1)*Shift
    final double totalWidth = avatarSize + (totalItems - 1) * shiftAmount;

    List<Widget> stackChildren = [];

    // Layer 1: 餘額 (+N)
    if (remainder > 0) {
      final double leftPos = (displayMembers.length) * shiftAmount;
      stackChildren.add(
        Positioned(
          left: leftPos,
          top: 0,
          bottom: 0,
          child: Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '+$remainder',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      );
    }

    // Layer 2: 成員 (倒序加入，讓 index 0 在最上層)
    for (int i = displayMembers.length - 1; i >= 0; i--) {
      final member = displayMembers[i];
      final double leftPos = i * shiftAmount;
      stackChildren.add(
        Positioned(
          left: leftPos,
          top: 0,
          bottom: 0,
          child: CommonAvatar(
            avatarId: member['avatar'],
            name: member['displayName'],
            radius: radius,
            fontSize: fontSize,
            isLinked: member['isLinked'] ?? false,
          ),
        ),
      );
    }

    return SizedBox(
      width: totalWidth,
      height: avatarSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: stackChildren,
      ),
    );
  }
}
