/// File: lib/core/utils/currency.dart
/// Utility untuk format mata uang Rupiah Indonesia (Rp)

import 'package:intl/intl.dart';

class CurrencyFormatter {
  /// Format angka ke bentuk Rp 25.000
  static String formatRupiah(num amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Format tanpa simbol Rp (contoh: 25.000)
  static String formatNumber(num amount) {
    final formatter = NumberFormat.decimalPattern('id_ID');
    return formatter.format(amount);
  }
}
