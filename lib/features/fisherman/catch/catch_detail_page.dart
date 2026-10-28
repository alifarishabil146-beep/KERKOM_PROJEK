/// File: lib/features/fisherman/catch/catch_detail_page.dart
/// Detail Tangkapan Ikan Nelayan NETLAYAN

import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/currency.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../models/catch_model.dart';

class CatchDetailPage extends StatelessWidget {
  const CatchDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CatchModel? item = ModalRoute.of(context)?.settings.arguments as CatchModel?;

    if (item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Tangkapan')),
        body: const Center(child: Text('Data tangkapan tidak ditemukan.')),
      );
    }

    final gradeColor = item.grade == 'A'
        ? AppColors.gradeA
        : (item.grade == 'B' ? AppColors.gradeB : AppColors.gradeC);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(item.fishType),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gambar Ikan
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                item.photoUrl,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 220,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.phishing, size: 64, color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Card Grade & Distribusi Pasar
            Card(
              color: gradeColor.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: gradeColor),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: gradeColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Grade ${item.grade}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.gradeDescription,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: gradeColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Waktu Tangkap: ${DateFormatter.formatDateTime(item.catchTime)} (${DateFormatter.formatHoursAgo(item.catchTime)})',
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Information Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Informasi Tangkapan', style: Theme.of(context).textTheme.titleLarge),
                    const Divider(height: 24),

                    _buildDetailRow('Nama Lokal', item.fishType),
                    _buildDetailRow('Nama Latin', item.latinName, isItalic: true),
                    _buildDetailRow('Berat Total', '${item.weightKg} kg'),
                    _buildDetailRow('Harga / kg', CurrencyFormatter.formatRupiah(item.pricePerKg)),
                    _buildDetailRow('Total Estimasi', CurrencyFormatter.formatRupiah(item.totalPrice), isBold: true),
                    _buildDetailRow('Metode Tangkap', item.method),
                    _buildDetailRow('Ukuran Ikan', item.size),
                    _buildDetailRow('Lokasi Landing', item.landingLocation),
                    _buildDetailRow('Nelayan', '${item.fishermanName} (${item.fishermanLocation})'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isItalic = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 14)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 14,
                fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: isBold ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
