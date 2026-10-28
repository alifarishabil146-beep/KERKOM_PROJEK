/// File: lib/core/utils/date_formatter.dart
/// Utility untuk format tanggal Bahasa Indonesia

import 'package:intl/intl.dart';

class DateFormatter {
  /// Format tanggal lengkap: 28 Oktober 2026
  static String formatFullDate(DateTime dateTime) {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(dateTime);
  }

  /// Format tanggal & jam: 28 Okt 2026, 08:30 WIB
  static String formatDateTime(DateTime dateTime) {
    return '${DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(dateTime)} WIB';
  }

  /// Format estimasi usia hasil tangkapan dalam jam
  static String formatHoursAgo(DateTime catchTime) {
    final difference = DateTime.now().difference(catchTime);
    final hours = difference.inHours;
    if (hours < 1) {
      final minutes = difference.inMinutes;
      return '$minutes Menit yang lalu';
    }
    return '$hours Jam yang lalu';
  }
}
