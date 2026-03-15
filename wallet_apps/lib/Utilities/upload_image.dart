import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class UploadImageService {
  final ImagePicker _picker = ImagePicker();
  final MobileScannerController _scannerController = MobileScannerController();

  Future<String?> pickAndScan() async {
try {
      // 1. Open Gallery
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100, // Keep quality high for dense QRs like TnG
      );

      if (image == null) return null;

      // 2. Scan the picked image file
      final BarcodeCapture? capture = await _scannerController.analyzeImage(image.path);
      _scannerController.dispose(); // Clean up the controller

      if (capture != null && capture.barcodes.isNotEmpty) {
        return capture.barcodes.first.rawValue;
      } else {
        return null; // No QR found
      }
    } catch (e) {
      debugPrint("Error picking/scanning image: $e");
      return null;
    }
  }
}