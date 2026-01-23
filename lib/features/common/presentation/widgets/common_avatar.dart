import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/avatar_constants.dart';

class CommonAvatar extends StatelessWidget {
  final dynamic avatarId; // 支援 String 或 null
  final String? name;
  final double radius;
  final double? fontSize;

  const CommonAvatar({
    super.key,
    required this.avatarId,
    required this.name,
    this.radius = 20, // 預設半徑
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 1. 處理資料
    final String rawId = avatarId?.toString() ?? '';
    final String assetPath = AvatarConstants.getAssetPath(rawId);
    final bool hasImage = assetPath.isNotEmpty;
    final String displayName = (name != null && name!.isNotEmpty) ? name! : '?';

    // 2. 建構 UI
    return CircleAvatar(
      radius: radius,
      backgroundColor:
          hasImage ? Colors.grey.shade300 : theme.colorScheme.primary, // 沒圖時用主色

      backgroundImage: hasImage ? AssetImage(assetPath) : null,

      onBackgroundImageError: hasImage
          ? (exception, stackTrace) {
              debugPrint("❌ CommonAvatar Error: Failed to load $assetPath");
            }
          : null,

      // 3. Fallback 文字 (首字)
      child: hasImage
          ? null
          : Text(
              displayName[0].toUpperCase(),
              style: TextStyle(
                fontSize: fontSize ?? (radius * 0.9), // 自動依半徑計算字體
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
