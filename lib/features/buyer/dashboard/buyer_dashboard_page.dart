/// File: lib/features/buyer/dashboard/buyer_dashboard_page.dart
/// Dashboard Pembeli (Swalayan Suzuya / Pasar Bawah Padang)

import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/token_storage.dart';
import '../../../core/utils/currency.dart';
import '../../../models/catch_model.dart';
import '../../../models/user_model.dart';
import '../../../routes.dart';

class BuyerDashboardPage extends StatefulWidget {
  const BuyerDashboardPage({super.key});

  @override
  State<BuyerDashboardPage> createState() => _BuyerDashboardPageState();
}

class _BuyerDashboardPageState extends State<BuyerDashboardPage> {
  final ApiService _apiService = ApiService();
  UserModel? _currentUser;
  List<CatchModel> _recommendedCatches = [];
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    final user = await TokenStorage.getUser();
    _currentUser = user;

    final catches = await _apiService.getCatches(
      buyerType: user?.buyerType,
    );

    if (mounted) {
      setState(() {
        _recommendedCatches = catches;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSupermarket = _currentUser?.buyerType == 'supermarket';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(Icons.storefront, color: AppColors.accentGold),
            const SizedBox(width: 8),
            Text(
              'NETLAYAN Pasar & Swalayan',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.browseFish);
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.buyerProfile);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner Info Header Pembeli
                    Card(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _currentUser?.institutionName ?? _currentUser?.name ?? 'Suzuya Superstore Padang',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isSupermarket
                                        ? AppColors.accentGold
                                        : Colors.amber.shade700,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    isSupermarket ? 'SWALAYAN' : 'PASAR TRADISIONAL',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isSupermarket
                                  ? 'Kriteria Akses: Hanya Ikan Segar Laut Grade A & B'
                                  : 'Kriteria Akses: Semua Grade (Grade A, B, C)',
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.browseFish);
                              },
                              icon: const Icon(Icons.shopping_cart_checkout, color: AppColors.primary),
                              label: const Text('Cari & Pesan Ikan Langsung'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Quick Action Category Chips
                    Text('Kategori Populer Padang', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildCategoryChip('Tuna Laut', Icons.phishing),
                          _buildCategoryChip('Tongkol Segar', Icons.phishing),
                          _buildCategoryChip('Kerapu Karang', Icons.phishing),
                          _buildCategoryChip('Kembung', Icons.phishing),
                          _buildCategoryChip('Udang Laut', Icons.set_meal),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Rekomendasi Tangkapan Segar Terbaru
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Ikan Tangkapan Segar Terbaru', style: Theme.of(context).textTheme.titleMedium),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.browseFish),
                          child: const Text('Lihat Semua'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    _recommendedCatches.isEmpty
                        ? const Card(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text('Belum ada pasokan ikan segar saat ini.'),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _recommendedCatches.length,
                            itemBuilder: (context, index) {
                              final fish = _recommendedCatches[index];
                              return _buildFishCard(fish);
                            },
                          ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 1) {
            Navigator.pushNamed(context, AppRoutes.browseFish);
          } else if (index == 2) {
            Navigator.pushNamed(context, AppRoutes.buyerOrders);
          } else if (index == 3) {
            Navigator.pushNamed(context, AppRoutes.buyerProfile);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Browse Ikan'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Pesanan Saya'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ActionChip(
        avatar: Icon(icon, size: 16, color: AppColors.primary),
        label: Text(label, style: const TextStyle(fontSize: 12)),
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.browseFish);
        },
      ),
    );
  }

  Widget _buildFishCard(CatchModel item) {
    final gradeColor = item.grade == 'A'
        ? AppColors.gradeA
        : (item.grade == 'B' ? AppColors.gradeB : AppColors.gradeC);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.photoUrl,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 90,
                  height: 90,
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
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                    'Nelayan: ${item.fishermanName} (${item.landingLocation})',
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${CurrencyFormatter.formatRupiah(item.pricePerKg)} / kg • Stok: ${item.weightKg} kg',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.createOrder,
                          arguments: item,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: const Text('Buat Order', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
