import 'package:flutter/services.dart';

/// Formats numeric input with dot separators for VND currency display.
///
/// Example: user types "1500000" → displayed as "1.500.000"
/// Use [getUnformattedValue] to retrieve the raw numeric string.
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    final rawDigits = newValue.text.replaceAll('.', '');

    // Only allow digits
    if (rawDigits.contains(RegExp(r'[^0-9]'))) {
      return oldValue;
    }

    final formatted = _formatWithDots(rawDigits);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _formatWithDots(String digits) {
    if (digits.isEmpty) return '';

    final buffer = StringBuffer();
    final length = digits.length;

    for (var i = 0; i < length; i++) {
      // Insert dot before every group of 3 from the right
      if (i > 0 && (length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digits[i]);
    }

    return buffer.toString();
  }

  /// Strips formatting dots and returns the raw numeric string.
  static String getUnformattedValue(String formattedText) =>
      formattedText.replaceAll('.', '');
}
