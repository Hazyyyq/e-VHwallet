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
        title: const Text(
          'Scan QR Code',
          style: TextStyle(color: Colors.white),
        ),
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
            onDetect: (capture) => _handleOnDetect(capture),
          ),
          CustomPaint(painter: ScannerOverlay(), child: Container()),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) =>
                ScannerLaser(animation: _animationController),
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

    if (result != null && mounted) {
      if (QrValidator.isBankQr(result)) {
        // STEP 3 FIX: Parse the data from the gallery image too!
        final Map<String, String> data = QrParser.parseEmvco(result);
        // Show the same confirmation dialog we use for the live scanner
        if (mounted){
          _showConfirmationDialog(data, result);

        }
         else {
          // If it's a QR but not a Bank QR
          _showErrorSnackBar();
          controller.start();
          setState(() => isScanned = false);
        }
      }
    } else {
      // If the user cancelled the gallery or no QR was found
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

          // If Static, show the usual confirmation dialog
          _showConfirmationDialog(data, rawValue);
      } else {
        _showErrorSnackBar();
      }
    }
  }

  void _showConfirmationDialog(Map<String, String> data, String rawValue) {
    String merchantName = data['59'] ?? "Unknown Merchant";
    String merchantCity = data['60'] ?? "Unknown City";
    String bankName = QrParser.identifyBank(data);

    // DEBUG: Check what's actually inside the tags
    debugPrint("--- QR DATA DEBUG ---");
    data.forEach((tag, value) => print("Tag $tag: $value"));

    debugPrint("Identified Bank/Provider: $bankName");
    // NEW: Dynamic Amount Handling (Tag 54)
    String? amount = data['54'];
    bool isDynamic = data['01'] == "12";

    // Clean up location if it's just 'MY'
    if (merchantCity.toUpperCase() == "MY") {
      merchantCity = "Malaysia";
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(
          isDynamic ? "Verify Payment" : "Confirm Transfer",
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Amount first if it's a Dynamic QR
            if (isDynamic && amount != null) ...[
              const Text(
                "Amount to Pay:",
                style: TextStyle(color: Colors.white70),
              ),
              Text(
                "RM $amount",
                style: const TextStyle(
                  color: Color(0xFF51FFD6), // Different color for amount
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(color: Colors.white24, height: 20),
            ],

            const Text("Recipient:", style: TextStyle(color: Colors.white70)),
            Text(
              merchantName,
              style: const TextStyle(
                color: Color(0xFFE4FF78),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),
            const Text(
              "Bank / Provider:",
              style: TextStyle(color: Colors.white70),
            ),
            Row(
              children: [
                const Icon(
                  Icons.account_balance_rounded,
                  color: Colors.white54,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  bankName,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),

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
            child: const Text(
              "CANCEL",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE4FF78),
            ),
            onPressed: () {
              // Get the screen context to pop safely
              final screenContext = this.context;
              Navigator.pop(context); // Close Dialog
              Navigator.pop(screenContext, {
      "rawValue": rawValue,
      "isDynamic": isDynamic,
      "amount": amount,
      "data": data,
    }); // Return to Home with QR Data
            },
            child: const Text("PROCEED", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar() {
    setState(() => isErrorShowing = true);
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: const Text(
              'Invalid QR. Please scan a DuitNow or Bank QR code.',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: const Color(0xFF51FFD6),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        )
        .closed
        .then((_) {
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
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
