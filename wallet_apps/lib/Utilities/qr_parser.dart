import 'package:flutter/material.dart';

class QrParser {
  static Map<String, String> parseEmvco(String rawData) {
    Map<String, String> results = {};
    int index = 0;

    try {
      while (index < rawData.length) {
        String tag = rawData.substring(index, index + 2);
        index += 2;

        int length = int.parse(rawData.substring(index, index + 2));
        index += 2;

        String value = rawData.substring(index, index + length);
        index += length;

        results[tag] = value;
      }
    } catch (e) {
      debugPrint("Parsing Error: $e");
    }
    return results;
  }

  // Helper to check if it's dynamic
  static bool isDynamic(Map<String, String> data) {
    return data['01'] == '12';
  }

  // Helper to get the amount (if any)
  static String? getAmount(Map<String, String> data) {
    return data['54']; // Tag 54 is the Transaction Amount
  }

  static String identifyBank(Map<String, String> data) {
    String merchantInfo = (data['26'] ?? "").toUpperCase();
    String merchantName = (data['59'] ?? "").toUpperCase();

    // Added Bank Rakyat check since we confirmed it earlier
    if (merchantInfo.contains("602325") || merchantInfo.contains("BKRM") || merchantName.contains("RAKYAT")) {
      return "Bank Rakyat";
    }

    if (merchantInfo.contains("589267") || merchantInfo.contains("BKRM")) return "Bank Rakyat";
    if (merchantInfo.contains("CIMB")) return "CIMB Bank";
    if (merchantInfo.contains("TNGD") || merchantInfo.contains("TNG")) return "Touch 'n Go eWallet";
    // ... rest of your bank checks
    
    return "DuitNow / Bank Transfer";
  }
}