import 'package:flutter/material.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/core/theme/app_theme.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrCode extends StatelessWidget {
  final String link;
  final bool isExpired;

  const QrCode({
    super.key,
    required this.link,
    required this.isExpired,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Center(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          padding: const EdgeInsets.all(AppLayout.spaceL),
          decoration: BoxDecoration(
            color: Colors.white, // 強制白底保證掃描成功率
            borderRadius: BorderRadius.circular(AppLayout.radiusL),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 繪製高質感 QR Code
              PrettyQrView.data(
                data: link,
                decoration: const PrettyQrDecoration(
                  image: PrettyQrDecorationImage(
                      image:
                          AssetImage('assets/images/icon/iron_split_200.png'),
                      padding: EdgeInsets.all(AppLayout.spaceM),
                      scale: 0.25),
                  shape: PrettyQrSmoothSymbol(
                    color: AppTheme.darkGray,
                  ),
                ),
              ),

              // 過期遮罩
              if (isExpired)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppLayout.spaceL,
                          vertical: AppLayout.spaceS),
                      decoration: ShapeDecoration(
                        color: colorScheme.error,
                        shape: StadiumBorder(),
                      ),
                      child: Text(
                        t.S54_TaskSettings_Invite.label.invite_expired,
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.onError,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
