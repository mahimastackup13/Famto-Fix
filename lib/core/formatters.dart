import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final NumberFormat _currency =
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  static String price(double value) => _currency.format(value);

  static String duration(int minutes) {
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final rest = minutes % 60;
    return rest == 0 ? '$hours hr' : '$hours hr $rest min';
  }

  static String date(DateTime date) =>
      DateFormat('EEE, d MMM yyyy').format(date);
}
