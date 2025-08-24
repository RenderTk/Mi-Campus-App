String capitalize(String? text) {
  if (text == null || text.isEmpty) return '';
  text = text.toLowerCase();
  return text[0].toUpperCase() + text.substring(1);
}

String customCapitalize(String? text) {
  if (text == null || text.isEmpty) return '';
  text = text.toLowerCase();

  // Capitalize first letter
  String result = text[0].toUpperCase() + text.substring(1);

  // Detect if it's a subject name ending with a roman numeral (I, II, III, IV...)
  final romanNumeralPattern = RegExp(
    r'\b(i{1,3}|iv|v|vi{0,3}|ix|x)\b',
    caseSensitive: false,
  );

  if (romanNumeralPattern.hasMatch(result)) {
    // Replace only roman numeral matches with uppercase
    result = result.replaceAllMapped(romanNumeralPattern, (match) {
      return match.group(0)!.toUpperCase();
    });
  }

  return result;
}

String formatNumber(num value) {
  if (value % 1 == 0) {
    // If it's an integer, show without decimals
    return value.toInt().toString();
  } else {
    // If it has decimals, format with 2 decimal places
    return value.toStringAsFixed(2);
  }
}
