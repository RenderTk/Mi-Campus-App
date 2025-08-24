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

Map<String, DateTime> getSemesterDateRange(int semester, int year) {
  // Validate inputs
  if (semester < 0 || semester > 3) {
    throw ArgumentError(
      'Semester must be 0 (all year), 1 (first semester), 2 (second semester), or 3 (third semester)',
    );
  }

  if (year < 2010 || year > 2025) {
    throw ArgumentError('Year must be a valid integer between 2010 and 2025');
  }

  DateTime fechaInicio;
  DateTime fechaFinal;

  switch (semester) {
    case 0: // All year
      fechaInicio = DateTime(year, 1, 1); // January 1st
      fechaFinal = DateTime(year, 12, 31); // December 31st
      break;

    case 1: // First semester (January - April)
      fechaInicio = DateTime(year, 1, 1); // January 1st
      fechaFinal = DateTime(year, 4, 30); // April 30th
      break;

    case 2: // Second semester (May - August)
      fechaInicio = DateTime(year, 5, 1); // May 1st
      fechaFinal = DateTime(year, 8, 31); // August 31st
      break;

    case 3: // Third semester (September - December)
      fechaInicio = DateTime(year, 9, 1); // September 1st
      fechaFinal = DateTime(year, 12, 31); // December 31st
      break;

    default:
      throw ArgumentError('Invalid semester value');
  }

  return {'fechaInicio': fechaInicio, 'fechaFinal': fechaFinal};
}
