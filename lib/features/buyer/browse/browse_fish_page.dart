/// File: lib/features/buyer/browse/browse_fish_page.dart
/// Katalog Search & Filter Ikan Berdasarkan Kriteria Kualitas

import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/token_storage.dart';
import '../../../core/utils/currency.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../models/catch_model.dart';
import '../../../models/user_model.dart';
import '../../../routes.dart';

class BrowseFishPage extends StatefulWidget {
  const BrowseFishPage({super.key});

  @override
  State<BrowseFishPage> createState() => _BrowseFishPageState();
}

class _BrowseFishPageState extends State<BrowseFishPage> {
  final ApiService _apiService = ApiService();
  final _searchController = TextEditingController();

  UserModel? _currentUser;
  List<CatchModel> _catches = [];
  bool _isLoading = true;

  String _selectedGrade = 'Semua';
  String _selectedLocation = 'Semua';

  final List<String> _gradeOptions = ['Semua', 'A', 'B', 'C'];
  final List<String> _locationOptions = [
    'Semua',
    'Pasir-pasir',
    'Muara',
    'Air Manis',
    'Teluk Bayur'
  ];

  @override
  void initState() {
    super.initState();
    _fetchCatches();
  }

  Future<void> _fetchCatches() async {
    setState(() => _isLoading = true);
    final user = await TokenStorage.getUser();
    _currentUser = user;

    final list = await _apiService.getCatches(
      grade: _selectedGrade,
      location: _selectedLocation,
      fishType: _searchController.text,
      buyerType: user?.buyerType,
    );

    if (mounted) {
      setState(() {
        _catches = list;
        _isLoading = false;
      });
    }
  }

  Color _getGradeColor(String grade) {
    if (grade == 'A') return AppColors.gradeA;
    if (grade == 'B') return AppColors.gradeB;
    return AppColors.gradeC;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSupermarket = _currentUser?.buyerType == 'supermarket';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Katalog Ikan Segar Padang'),
      ),
      body: Column(
        children: [
          // Header Search & Filter
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Search Field
                TextField(
                  controller: _searchController,
                  onChanged: (val) => _fetchCatches(),
                  decoration: InputDecoration(
                    hintText: 'Cari nama ikan (Tongkol, Tuna, Kerapu...)',
                    prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _fetchCatches();
                            },
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 12),

                // Rule Note Swalayan jika berlaku
                if (isSupermarket)
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accentGold.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.accentGold),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Modus Swalayan (Suzuya): Menampilkan HANYA Grade A & Grade B.',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Filters Grade & Lokasi
                Row(
                  children: [
                    const Text('Grade: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _gradeOptions.map((g) {
                            if (isSupermarket && g == 'C') return const SizedBox.shrink();
                            final isSelected = _selectedGrade == g;
                            return Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: ChoiceChip(
                                label: Text(g == 'Semua' ? 'Semua Grade' : 'Grade $g'),
                                selected: isSelected,
                                selectedColor: AppColors.primary,
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
                                  fontSize: 12,
                                ),
                                onSelected: (val) {
                                  if (val) {
                                    setState(() => _selectedGrade = g);
                                    _fetchCatches();
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Text('Lokasi: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _locationOptions.map((loc) {
                            final isSelected = _selectedLocation == loc;
                            return Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: ChoiceChip(
                                label: Text(loc),
                                selected: isSelected,
                                selectedColor: AppColors.secondary,
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
                                  fontSize: 12,
                                ),
                                onSelected: (val) {
                                  if (val) {
                                    setState(() => _selectedLocation = loc);
                                    _fetchCatches();
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Catalog Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _catches.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.search_off, size: 60, color: AppColors.textMuted),
                            SizedBox(height: 12),
                            Text(
                              'Tidak ada ikan yang memenuhi kriteria filter',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                              margin: const EdgeInsets.only(bottom: 14),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.network(
                                            item.photoUrl,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Container(
                                              width: 100,
                                              height: 100,
                                              color: Colors.grey.shade300,
                                              child: const Icon(Icons.phishing, color: AppColors.primary),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      item.fishType,
                                                      style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight: FontWeight.bold,
                                                        color: AppColors.textPrimary,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                                                        fontSize: 12,
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
                                                '${CurrencyFormatter.formatRupiah(item.pricePerKg)} / kg',
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Tersedia: ${item.weightKg} kg • ${item.method}',
                                                style: const TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(height: 20),

                                    Row(
                                      children: [
                                        const Icon(Icons.sailing, size: 14, color: AppColors.textMuted),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            '${item.fishermanName} (${item.landingLocation})',
                                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                                          ),
                                        ),
                                        const Icon(Icons.access_time, size: 14, color: AppColors.textMuted),
                                        const SizedBox(width: 4),
                                        Text(
                                          DateFormatter.formatHoursAgo(item.catchTime),
                                          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),

                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                context,
                                                AppRoutes.fishDetail,
                                                arguments: item,
                                              );
                                            },
                                            child: const Text('Detail Ikan'),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                context,
                                                AppRoutes.createOrder,
                                                arguments: item,
                                              );
                                            },
                                            child: const Text('Buat Order'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
