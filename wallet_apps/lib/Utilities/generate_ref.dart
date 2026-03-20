class GenerateRef {
  static String generate() {
    final now = DateTime.now();
    final random = now.millisecondsSinceEpoch % 10000;
    return 'REF${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}$random';
  }
}
