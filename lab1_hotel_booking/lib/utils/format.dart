// R8: свои названия месяцев — без пакетов
const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

// 25 Oct
String formatDate(DateTime d) => '${d.day} ${_months[d.month - 1]}';

// 14:05 — R8: padLeft добавляет ноль слева
String formatTime(DateTime d) {
  final h = d.hour.toString().padLeft(2, '0');
  final m = d.minute.toString().padLeft(2, '0');
  return '$h:$m';
}
// 25 Oct, 14:05
String formatDateTime(DateTime d) => '${formatDate(d)}, ${formatTime(d)}';

// 4 d 6 h · 3 h 20 min · 12 min — для обратного отсчёта
String formatDuration(Duration d) {
  if (d.inDays > 0) return '${d.inDays} d ${d.inHours % 24} h';
  if (d.inHours > 0) return '${d.inHours} h ${d.inMinutes % 60} min';
  return '${d.inMinutes} min';
}