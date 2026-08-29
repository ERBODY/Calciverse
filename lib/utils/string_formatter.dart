// Utility functions for string formatting

/// Converts snake_case or camelCase strings to Title Case
/// Examples:
///   'length_unit' -> 'Length Unit'
///   'original_value' -> 'Original Value'
///   'birthDate' -> 'Birth Date'
///   'time_units' -> 'Time Units'
String toTitleCase(String input) {
  if (input.isEmpty) return input;

  // Replace underscores with spaces
  String result = input.replaceAll('_', ' ');

  // Insert space before uppercase letters (for camelCase)
  result = result.replaceAllMapped(
    RegExp(r'([a-z])([A-Z])'),
    (match) => '${match.group(1)} ${match.group(2)}',
  );

  // Capitalize each word
  return result
      .split(' ')
      .map((word) => word.isEmpty
          ? ''
          : word[0].toUpperCase() + word.substring(1).toLowerCase())
      .join(' ');
}
