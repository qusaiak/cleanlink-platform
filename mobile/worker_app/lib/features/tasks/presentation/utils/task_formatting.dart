// Lightweight date/time formatting for the tasks feature.
//
// Kept dependency-free (no `intl`) and shared so the task card and the
// task-detail screen format times/dates identically.

/// Formats a 24-hour [DateTime] as a 12-hour "h:mm AM/PM" string,
/// e.g. 13:30 → "1:30 PM".
String formatTaskTime(DateTime dt) {
  final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final minute = dt.minute.toString().padLeft(2, '0');
  final period = dt.hour < 12 ? 'AM' : 'PM';
  return '$hour12:$minute $period';
}

const List<String> _enMonths = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

const List<String> _arMonths = [
  'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
  'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
];

/// Formats a [DateTime] as `day month-name year` using localized month names,
/// e.g. (2024-05-24, 'ar') → "24 مايو 2024", (…, 'en') → "24 May 2024".
String formatTaskDate(DateTime dt, String localeCode) {
  final months = localeCode == 'ar' ? _arMonths : _enMonths;
  return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
}

/// Formats a booking [price] with its [currency] symbol, dropping a trailing
/// ".0" so whole amounts read "$75" rather than "$75.0".
String formatTaskPrice(double price, String currency) {
  final amount =
      price == price.roundToDouble() ? price.toStringAsFixed(0) : price.toString();
  return '$currency$amount';
}
