//Qr Code Validation 

class QrValidator {
  static bool isBankQr(String code) {
    return code.startsWith('00020') && code.contains('5802MY');
  }
}