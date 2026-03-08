import 'package:flutter/material.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/onboarding/application/onboarding_service.dart';
import 'package:iron_split/features/task/presentation/viewmodels/s19_scan_qr_code_vm.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';

class S19TaskScanQrCodePage extends StatelessWidget {
  const S19TaskScanQrCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => S19TaskScanQrCodeViewModel(),
      child: const _S19Content(),
    );
  }
}

class _S19Content extends StatefulWidget {
  const _S19Content();

  @override
  State<_S19Content> createState() => _S19ContentState();
}

class _S19ContentState extends State<_S19Content> {
  // 防止底層引擎啟動失敗時，Toast 瘋狂彈出的鎖
  bool _hasShownEngineErrorToast = false;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final vm = context.read<S19TaskScanQrCodeViewModel>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(t.s19_task_scan_qr_code.title),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 1. 底層相機畫面
          MobileScanner(
            controller: MobileScannerController(facing: CameraFacing.back),
            errorBuilder: (context, error) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!_hasShownEngineErrorToast) {
                  AppToast.showError(context, t.error.message.scan_failed);
                  _hasShownEngineErrorToast = true;
                }
              });
              return const SizedBox.shrink();
            },
            // 📸 掃描動作攔截
            onDetect: (BarcodeCapture capture) async {
              if (_isProcessing) return;
              for (final barcode in capture.barcodes) {
                if (barcode.rawValue != null) {
                  setState(() => _isProcessing = true);
                  try {
                    // 將字串交給 VM 處理
                    final validCode = vm.processBarcode(barcode.rawValue!);

                    // 如果成功拿到 8 碼，UI 負責導航
                    if (validCode != null) {
                      context.pushReplacementNamed('S11',
                          queryParameters: {'code': validCode},
                          extra: {'inviteMethod': InviteMethod.qr});
                    }
                  } on AppErrorCodes {
                    if (!context.mounted) return;
                    AppToast.showError(context, t.error.message.scan_failed);
                    await Future.delayed(const Duration(seconds: 2));
                  } finally {
                    // 確保在組件還存在時才更新狀態
                    if (!context.mounted) {
                      setState(() => _isProcessing = false);
                    }
                  }
                  break; // 一次只處理一筆條碼
                }
              }
            },
          ),

          Positioned.fill(
            child: CustomPaint(
              painter: ScannerOverlayPainter(
                borderColor: Colors.white,
                borderRadius: 16,
                widthFactor: 0.8,
              ),
            ),
          ),

          // 3. 提示文字
          Positioned(
            bottom: 80,
            child: Text(
              t.s19_task_scan_qr_code.content.scan,
            ),
          ),
        ],
      ),
    );
  }
}

// 繪製遮罩的 Painter
class ScannerOverlayPainter extends CustomPainter {
  final Color borderColor;
  final double borderRadius;
  final double widthFactor;

  ScannerOverlayPainter({
    required this.borderColor,
    required this.borderRadius,
    required this.widthFactor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double scanBoxSize = size.width * widthFactor;
    final double left = (size.width - scanBoxSize) / 2;
    final double top = (size.height - scanBoxSize) / 2;

    final Rect scanRect = Rect.fromLTWH(left, top, scanBoxSize, scanBoxSize);

    // 1. 繪製半透明背景
    final Paint backgroundPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5);

    // 使用 Path.combine 挖洞
    final Path backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final Path holePath = Path()
      ..addRRect(
          RRect.fromRectAndRadius(scanRect, Radius.circular(borderRadius)));

    // 關鍵：使用 difference 模式挖出中間的框
    final Path finalPath =
        Path.combine(PathOperation.difference, backgroundPath, holePath);
    canvas.drawPath(finalPath, backgroundPaint);

    // 2. 繪製框線
    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawRRect(
      RRect.fromRectAndRadius(scanRect, Radius.circular(borderRadius)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
