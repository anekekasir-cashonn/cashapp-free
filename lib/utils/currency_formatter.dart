import 'package:intl/intl.dart';

class CurrencyFormatter {
  /// Format number to Indonesian Rupiah currency
  static String formatRupiah(double amount) {
    return 'Rp ${NumberFormat('#,###').format(amount)}';
  }

  /// Format number with thousands separator
  static String formatNumber(int number) {
    return NumberFormat('#,###').format(number);
  }

  /// Format date and time
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, yyyy • HH:mm').format(dateTime);
  }

  /// Format date only
  static String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  /// Parse string to double
  static double parseDouble(String value) {
    try {
      return double.parse(value.replaceAll(',', ''));
    } catch (e) {
      return 0.0;
    }
  }
}
