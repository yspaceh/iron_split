import 'package:flutter/material.dart';

class AppSelectField extends StatelessWidget {
  final String text; // 目前選中的內容
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final VoidCallback onTap; // 點擊觸發 BottomSheet
  final String? errorText; // 外部傳入的錯誤訊息 (如果有)

  const AppSelectField({
    super.key,
    required this.text,
    required this.onTap,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 判斷是否顯示 hint (當 text 為空時)
    final bool isEmpty = text.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              labelText!,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: IgnorePointer(
            ignoring: true, // 忽略點擊，讓 InkWell 處理 onTap，但保留 TextFormField 的外觀
            child: TextFormField(
              initialValue: isEmpty ? null : text, // 如果有值就顯示
              readOnly: true, // [關鍵]：唯讀，不跳鍵盤
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: isEmpty ? hintText : null, // 顯示提示文字
                hintStyle: TextStyle(color: colorScheme.outline),

                filled: true,
                // [區隔]：選擇器底色可以比輸入框稍微深一點點，或者一樣
                fillColor: colorScheme.surfaceContainerLow,

                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

                prefixIcon: prefixIcon != null
                    ? Icon(prefixIcon,
                        color: colorScheme.onSurfaceVariant, size: 20)
                    : null,

                // [關鍵]：強制顯示下拉箭頭
                suffixIcon: Icon(
                  Icons.expand_more_rounded, // 圓角下拉箭頭
                  color: colorScheme.onSurfaceVariant,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                // 即使唯讀，若有 errorText 也要變紅
                errorText: errorText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
