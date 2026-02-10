import 'package:flutter/material.dart';
import 'package:iron_split/features/common/presentation/widgets/state_visual.dart';
import 'package:iron_split/gen/strings.g.dart';

class S17ClosedView extends StatelessWidget {
  const S17ClosedView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          //TODO: 要準備放在這的圖片
          const StateVisual(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(t.S32_settlement_result.content),
          ),
        ],
      ),
    );
  }
}
