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
      print("Parsing Error: $e");
    }
    return results;
  }

  static String identifyBank(Map<String, String> data) {
    String? psi = data['01'];
    if (psi != null) {
      if (psi.startsWith('12')) return 'DuitNow';
      if (psi.startsWith('22')) return 'PayNet';
    }
    String? merchantCity = data['60'];
    if (merchantCity != null && merchantCity.toUpperCase() == 'MY') {
      return 'Bank Malaysia';
    }
    return 'Unknown Bank';
  }
}