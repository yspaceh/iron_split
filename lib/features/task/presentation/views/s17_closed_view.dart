import 'package:flutter/material.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/features/common/presentation/widgets/state_visual.dart';
import 'package:iron_split/gen/strings.g.dart';

class S17ClosedView extends StatelessWidget {
  const S17ClosedView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Column(
      children: [
        const StateVisual(
          assetPath: 'assets/images/iron/iron_image_settlement.png',
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppLayout.spaceL),
              child: Text(t.s32_settlement_result.content),
            ),
          ),
        ),
      ],
    );
  }
}
