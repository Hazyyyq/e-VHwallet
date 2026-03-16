// ================= Others Import ===============
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// ================= Utilities Import ===============
import 'package:wallet_apps/Utilities/upload_image.dart';
import 'package:wallet_apps/Utilities/qr_validator.dart';
import 'package:wallet_apps/Utilities/qr_parser.dart';

// ================= Design Import ===============
import 'package:wallet_apps/Design/scanner_overlay.dart';
import 'package:wallet_apps/Design/scanner_laser.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController controller = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  late AnimationController _animationController;
  bool isScanned = false;
  bool isErrorShowing = false;

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Scan QR Code', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_library_rounded, color: Colors.white),
            onPressed: () => _handleGalleryUpload(),
          ),
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, child) {
              return IconButton(
                onPressed: () => controller.toggleTorch(),
                icon: Icon(
                  value.torchState == TorchState.on ? Icons.flash_on : Icons.flash_off,
                  color: value.torchState == TorchState.on ? const Color(0xFFE4FF78) : Colors.white,
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
            onDetect: (capture) => _handleOnDetect(capture),
          ),
          CustomPaint(painter: ScannerOverlay(), child: Container()),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) => ScannerLaser(animation: _animationController),
          ),
          const InstructionText(),
        ],
      ),
    );
  }

  // --- Logic Extracted to Functions ---

  Future<void> _handleGalleryUpload() async {
    setState(() => isScanned = true);
    controller.stop();

    final uploadService = UploadImageService();
    final String? result = await uploadService.pickAndScan();

    if (result != null && mounted && QrValidator.isBankQr(result)) {
      Navigator.pop(context, result);
    } else {
      _showErrorSnackBar();
      controller.start();
      setState(() => isScanned = false);
    }
  }

  void _handleOnDetect(BarcodeCapture capture) {
    if (isScanned || isErrorShowing) return;

    final barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String rawValue = barcodes.first.rawValue ?? "";
      if (QrValidator.isBankQr(rawValue)) {
        setState(() => isScanned = true);
        controller.stop();

        final Map<String, String> data = QrParser.parseEmvco(rawValue);
        _showConfirmationDialog(data, rawValue);
      } else {
        _showErrorSnackBar();
      }
    }
  }

  void _showConfirmationDialog(Map<String, String> data, String rawValue) {
    String merchantName = data['59'] ?? "Unknown Merchant";
    String merchantCity = data['60'] ?? "Unknown City";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text("Confirm Transfer", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Recipient:", style: TextStyle(color: Colors.white70)),
            Text(merchantName, style: const TextStyle(color: Color(0xFFE4FF78), fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Location:", style: TextStyle(color: Colors.white70)),
            Text(merchantCity, style: const TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.start();
              setState(() => isScanned = false);
            },
            child: const Text("CANCEL", style: TextStyle(color: Colors.redAccent)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE4FF78)),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(this.context, rawValue);
            },
            child: const Text("PROCEED", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar() {
    setState(() => isErrorShowing = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Invalid QR. Please scan a DuitNow or Bank QR code.', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF51FFD6),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    ).closed.then((_) {
      if (mounted) setState(() => isErrorShowing = false);
    });
  }
}

// --- Local Widget for cleaner Stack ---

class InstructionText extends StatelessWidget {
  const InstructionText({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: const Center(
        child: Text(
          'Align QR code within the frame',
          style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}