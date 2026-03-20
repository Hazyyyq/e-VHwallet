class QrParser {
  static Map<String, String> parseEmvco(String rawData) {
    Map<String, String> results = {};
    int index = 0;

    try {
      while (index < rawData.length) {
        // 1. Get Tag 
        String tag = rawData.substring(index, index + 2);
        index += 2;

        // 2. Get Length 
        int length = int.parse(rawData.substring(index, index + 2));
        index += 2;

        // 3. Get Value based on that length 
        String value = rawData.substring(index, index + length);
        index += length;

        results[tag] = value;
      }
    } catch (e) {
      print("Parsing Error: $e");
    }
    return results;
  }
}