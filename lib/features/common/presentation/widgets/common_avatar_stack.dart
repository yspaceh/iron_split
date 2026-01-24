import 'package:flutter/material.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';

class CommonAvatarStack extends StatelessWidget {
  final List<Map<String, dynamic>> allMembers;
  final List<String> targetMemberIds;
  final double radius;
  final double fontSize;
  final double overlap;

  const CommonAvatarStack({
    super.key,
    required this.allMembers,
    required this.targetMemberIds,
    this.radius = 12,
    this.fontSize = 10,
    this.overlap = 0.6,
  });

  @override
  Widget build(BuildContext context) {
    final activeMembers =
        allMembers.where((m) => targetMemberIds.contains(m['id'])).toList();

    return Container(
      constraints: const BoxConstraints(maxWidth: 220),
      child: Wrap(
        alignment: WrapAlignment.end,
        spacing: 4,
        runSpacing: 4,
        children: activeMembers.map((member) {
          return CommonAvatar(
            avatarId: member['avatar'],
            name: member['name'],
            radius: radius,
            fontSize: fontSize,
          );
        }).toList(),
      ),
    );
  }
}
