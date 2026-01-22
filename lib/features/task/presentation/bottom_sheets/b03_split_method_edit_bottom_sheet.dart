import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/gen/strings.g.dart';

class B03SplitMethodEditBottomSheet extends StatelessWidget {
  final String currentMethod;

  const B03SplitMethodEditBottomSheet({super.key, required this.currentMethod});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              t.B03_SplitMethod_Edit.title,
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          _buildOption(context,
              id: 'even',
              title: t.B03_SplitMethod_Edit.method_even,
              desc: t.B03_SplitMethod_Edit.desc_even,
              icon: Icons.call_split),
          _buildOption(context,
              id: 'exact',
              title: t.B03_SplitMethod_Edit.method_exact,
              desc: t.B03_SplitMethod_Edit.desc_exact,
              icon: Icons.edit_note),
          _buildOption(context,
              id: 'percent',
              title: t.B03_SplitMethod_Edit.method_percent,
              desc: t.B03_SplitMethod_Edit.desc_percent,
              icon: Icons.pie_chart_outline),
          _buildOption(context,
              id: 'by_share',
              title: t.B03_SplitMethod_Edit.method_share,
              desc: t.B03_SplitMethod_Edit.desc_share,
              icon: Icons.diversity_3),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context,
      {required String id,
      required String title,
      required String desc,
      required IconData icon}) {
    final isSelected = id == currentMethod;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isSelected
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHighest,
        child: Icon(icon,
            color: isSelected
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurfaceVariant),
      ),
      title: Text(title,
          style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      subtitle: Text(desc),
      trailing:
          isSelected ? Icon(Icons.check, color: colorScheme.primary) : null,
      onTap: () => context.pop(id), // 回傳選擇的 method ID
    );
  }
}
