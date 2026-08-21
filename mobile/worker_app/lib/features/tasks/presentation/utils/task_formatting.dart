String formatTaskTime(DateTime dt) {
  final local = dt.toLocal();
  final hour12 = local.hour % 12 == 0 ? 12 : local.hour % 12;
  final minute = local.minute.toString().padLeft(2, '0');
  final period = local.hour < 12 ? 'AM' : 'PM';
  return '$hour12:$minute $period';
}

const List<String> _enMonths = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

const List<String> _arMonths = [
  'يناير',
  'فبراير',
  'مارس',
  'أبريل',
  'مايو',
  'يونيو',
  'يوليو',
  'أغسطس',
  'سبتمبر',
  'أكتوبر',
  'نوفمبر',
  'ديسمبر',
];

String formatTaskDate(DateTime dt, String localeCode) {
  final local = dt.toLocal();
  final months = localeCode == 'ar' ? _arMonths : _enMonths;
  return '${local.day} ${months[local.month - 1]} ${local.year}';
}

String formatTaskPrice(double price, String currency) {
  final amount = price == price.roundToDouble()
      ? price.toStringAsFixed(0)
      : price.toString();
  return '$currency$amount';
}
