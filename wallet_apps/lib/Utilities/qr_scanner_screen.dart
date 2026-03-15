import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wallet_apps/Utilities/upload_image.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController controller = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  late AnimationController _animationController;
  bool isScanned = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true, // Cool overlay effect
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Scan QR Code',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [

          // 1. Upload from Gallery Button
          IconButton(
            icon: const Icon(Icons.photo_library_rounded, color: Colors.white),
            onPressed: () async {

              // Stop the camera temporarily to save resources
              setState(() => isScanned = true);
              controller.stop();

                 // Initialize the service
              final uploadService = UploadImageService();
              final String? result = await uploadService.pickAndScan();

              if (result != null && mounted) {
                // If code found, return it to Home Page
                Navigator.pop(context, result);
              } else if (mounted) {
                // If no code found, restart the camera and show a message
                controller.start();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No QR code found in this image'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, child) {
              return IconButton(
                onPressed: () => controller.toggleTorch(),
                icon: Icon(
                  value.torchState == TorchState.on
                      ? Icons.flash_on
                      : Icons.flash_off,
                  color: value.torchState == TorchState.on
                      ? const Color(0xFFE4FF78)
                      : Colors.white,
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (isScanned) return;
              final barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                isScanned = true;
                controller.stop();
                Navigator.pop(context, barcodes.first.rawValue);
              }
            },
          ),

          // Also Design and Animations Below, No Logic

          // 1. Dark Overlay with Cutout
          CustomPaint(painter: ScannerOverlay(), child: Container()),
          // 2. The Animated Laser Line
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Positioned(
                top:
                    (MediaQuery.of(context).size.height / 2 - 125) +
                    (_animationController.value * 250),
                left: MediaQuery.of(context).size.width / 2 - 110,
                child: Container(
                  width: 220,
                  height: 2,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE4FF78).withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                    gradient: const LinearGradient(
                      colors: [
                        Colors.transparent,
                        Color(0xFFE4FF78),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // 3. Instruction Text
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                'Align QR code within the frame',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Just Design Stuff Below, No Logic

class ScannerOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.5);

    // This creates the "dimmed" background
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset(size.width / 2, size.height / 2),
                width: 250,
                height: 250,
              ),
              const Radius.circular(20),
            ),
          )
          ..close(),
      ),
      paint,
    );

    // Draw the white borders (corners only)
    final borderPaint = Paint()
      ..color =
          const Color(0xFFE4FF78) // Your FAB color!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final path = Path();
    double offset = 20.0;
    double centerW = size.width / 2;
    double centerH = size.height / 2;
    Rect rect = Rect.fromCenter(
      center: Offset(centerW, centerH),
      width: 250,
      height: 250,
    );

    // Top Left Corner
    path.moveTo(rect.left, rect.top + offset);
    path.lineTo(rect.left, rect.top);
    path.lineTo(rect.left + offset, rect.top);

    // Top Right Corner
    path.moveTo(rect.right - offset, rect.top);
    path.lineTo(rect.right, rect.top);
    path.lineTo(rect.right, rect.top + offset);

    // Bottom Right Corner
    path.moveTo(rect.right, rect.bottom - offset);
    path.lineTo(rect.right, rect.bottom);
    path.lineTo(rect.right - offset, rect.bottom);

    // Bottom Left Corner
    path.moveTo(rect.left + offset, rect.bottom);
    path.lineTo(rect.left, rect.bottom);
    path.lineTo(rect.left, rect.bottom - offset);

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
