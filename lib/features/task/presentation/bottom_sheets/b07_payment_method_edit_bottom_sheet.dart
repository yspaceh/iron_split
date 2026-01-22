import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/gen/strings.g.dart';

class B07PaymentMethodEditBottomSheet extends StatelessWidget {
  final String currentType; // 'prepay' or 'member'
  final String? currentId;
  // ✅ 修正：接收外部傳入的成員資料
  final List<Map<String, dynamic>> members;

  const B07PaymentMethodEditBottomSheet({
    super.key,
    required this.currentType,
    this.currentId,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 將自己 ("me") 與其他成員整理在一起 (如果成員列表裡沒有自己，可以在這裡補)
    // 假設 members 已經包含所有成員

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                t.S15_Record_Edit.label_payment_method,
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),

            // Option 1: 預收
            _buildOptionTile(
              context,
              title: t.S15_Record_Edit.val_prepay,
              icon: Icons.account_balance_wallet,
              isSelected: currentType == 'prepay',
              colorScheme: colorScheme,
              onTap: () => context.pop({'type': 'prepay', 'id': 'prepay'}),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Divider(),
            ),

            // Option 2: 成員列表
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final m = members[index];
                  final isSelected =
                      currentType == 'member' && currentId == m['id'];
                  final name = m['name'] ?? 'Unknown';

                  return _buildOptionTile(
                    context,
                    title: name,
                    icon: Icons.person_outline,
                    isSelected: isSelected,
                    colorScheme: colorScheme,
                    onTap: () => context.pop({'type': 'member', 'id': m['id']}),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool isSelected,
    required ColorScheme colorScheme,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        color:
            isSelected ? colorScheme.primaryContainer.withOpacity(0.3) : null,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color:
                      isSelected ? colorScheme.primary : colorScheme.onSurface,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: colorScheme.primary, size: 24),
          ],
        ),
      ),
    );
  }
}
