/// File: lib/features/fisherman/catch/catch_list_page.dart
/// Daftar Tangkapan Nelayan Terdaftar

import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/token_storage.dart';
import '../../../core/utils/currency.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../models/catch_model.dart';
import '../../../models/user_model.dart';
import '../../../routes.dart';

class CatchListPage extends StatefulWidget {
  const CatchListPage({super.key});

  @override
  State<CatchListPage> createState() => _CatchListPageState();
}

class _CatchListPageState extends State<CatchListPage> {
  final ApiService _apiService = ApiService();
  List<CatchModel> _catches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCatches();
  }

  Future<void> _fetchCatches() async {
    setState(() => _isLoading = true);
    final user = await TokenStorage.getUser();
    if (user != null) {
      final list = await _apiService.getFishermanCatches(user.id);
      if (mounted) {
        setState(() {
          _catches = list;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Color _getGradeColor(String grade) {
    if (grade == 'A') return AppColors.gradeA;
    if (grade == 'B') return AppColors.gradeB;
    return AppColors.gradeC;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tangkapanku'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.uploadCatch);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _catches.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.phishing, size: 64, color: AppColors.textMuted),
                      const SizedBox(height: 12),
                      const Text(
                        'Belum ada data tangkapan',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      const Text('Upload hasil tangkapan pertama Anda sekarang'),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.uploadCatch),
                        icon: const Icon(Icons.add),
                        label: const Text('Upload Tangkapan Baru'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchCatches,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _catches.length,
                    itemBuilder: (context, index) {
                      final item = _catches[index];
                      final gradeColor = _getGradeColor(item.grade);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.catchDetail,
                              arguments: item,
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    item.photoUrl,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey.shade300,
                                      child: const Icon(Icons.phishing, color: AppColors.primary),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item.fishType,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: gradeColor.withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(color: gradeColor),
                                            ),
                                            child: Text(
                                              'Grade ${item.grade}',
                                              style: TextStyle(
                                                color: gradeColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item.latinName,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '${item.weightKg} kg • ${CurrencyFormatter.formatRupiah(item.pricePerKg)}/kg',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on, size: 12, color: AppColors.textMuted),
                                          const SizedBox(width: 2),
                                          Text(
                                            item.landingLocation,
                                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(Icons.access_time, size: 12, color: AppColors.textMuted),
                                          const SizedBox(width: 2),
                                          Text(
                                            DateFormatter.formatHoursAgo(item.catchTime),
                                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
