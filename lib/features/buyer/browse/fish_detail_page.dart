/// File: lib/features/buyer/browse/fish_detail_page.dart
/// Detail Kualitas Ikan Segar & Rekam Pendaratan Nelayan Padang

import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/currency.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../models/catch_model.dart';
import '../../../routes.dart';

class FishDetailPage extends StatelessWidget {
  const FishDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CatchModel? item = ModalRoute.of(context)?.settings.arguments as CatchModel?;

    if (item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Ikan')),
        body: const Center(child: Text('Data tidak ditemukan.')),
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
            // Image Box
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

            // Card Evaluation Grade
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
                            'Tertangkap pada: ${DateFormatter.formatDateTime(item.catchTime)} (${DateFormatter.formatHoursAgo(item.catchTime)})',
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

            // Detail Specifications
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Spesifikasi Pasokan', style: Theme.of(context).textTheme.titleLarge),
                    const Divider(height: 24),
                    _buildRow('Jenis Ikan', item.fishType),
                    _buildRow('Nama Latin', item.latinName, isItalic: true),
                    _buildRow('Stok Tersedia', '${item.weightKg} kg'),
                    _buildRow('Harga Langsung Nelayan', '${CurrencyFormatter.formatRupiah(item.pricePerKg)} / kg', isBold: true),
                    _buildRow('Metode Tangkap', item.method),
                    _buildRow('Ukuran Ikan', item.size),
                    _buildRow('Pelabuhan Landing', item.landingLocation),
                    _buildRow('Nelayan Penangkap', item.fishermanName),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.createOrder,
                  arguments: item,
                );
              },
              icon: const Icon(Icons.shopping_bag),
              label: const Text('Pesan Ikan Ini Sekarang'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isItalic = false, bool isBold = false}) {
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
