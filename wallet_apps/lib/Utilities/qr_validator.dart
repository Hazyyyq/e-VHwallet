<<<<<<< HEAD
//Qr Code Validation 

class QrValidator {
  static bool isBankQr(String code) {
    return code.startsWith('00020') && code.contains('5802MY');
=======
import 'package:crclib/catalog.dart';

class QrValidator {
  static bool isBankQr(String code) {
    // 1. Structural Check
    // EMVCo QRs must start with '00' (Payload Indicator)
    // and must contain '6304' (The CRC Tag and Length)
    if (!code.startsWith('00') || !code.contains('6304')) {
      return false;
    }

    // 2. Length Check
    // A valid EMVCo string usually needs to be at least 20-30 chars 
    // to contain a Merchant Name and Account Info.
    if (code.length < 20) {
      return false;
    }

    // 3. Mathematical Integrity Check (The Universal Standard)
    // This verifies the CRC regardless of which country the QR is from.
    return _verifyChecksum(code);
  }

  static bool _verifyChecksum(String code) {
    try {
      // Find the position of '6304'
      int crcTagIndex = code.lastIndexOf("6304");
      if (crcTagIndex == -1) return false;

      // The data to calculate includes everything UP TO and INCLUDING '6304'
      String dataToVerify = code.substring(0, crcTagIndex + 4);
      
      // The expected CRC is the 4 hex characters following '6304'
      String providedCrc = code.substring(crcTagIndex + 4, crcTagIndex + 8).toUpperCase();

      // Perform CRC-16/CCITT-FALSE calculation
      final crcValue = Crc16CcittFalse().convert(dataToVerify.codeUnits);
      
      // Convert result to 4-digit uppercase Hex
      final String calculatedCrc = crcValue.toRadixString(16).toUpperCase().padLeft(4, '0');

      return calculatedCrc == providedCrc;
    } catch (e) {
      return false;
    }
>>>>>>> origin/main
  }
}