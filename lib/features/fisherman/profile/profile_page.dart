/// File: lib/features/fisherman/profile/profile_page.dart
/// Profil Nelayan Padang, Sertifikasi KKP, & Logout

import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/token_storage.dart';
import '../../../models/user_model.dart';
import '../../../routes.dart';

class FishermanProfilePage extends StatefulWidget {
  const FishermanProfilePage({super.key});

  @override
  State<FishermanProfilePage> createState() => _FishermanProfilePageState();
}

class _FishermanProfilePageState extends State<FishermanProfilePage> {
  final AuthService _authService = AuthService();
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = await TokenStorage.getUser();
    if (mounted) {
      setState(() {
        _user = user;
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profil Nelayan'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profil Card Header
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 46,
                            backgroundColor: AppColors.accentGold,
                            child: CircleAvatar(
                              radius: 42,
                              backgroundImage: NetworkImage(
                                _user?.avatarUrl ??
                                    'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _user?.name ?? 'Uda Buyung',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.verified, color: AppColors.accentGold),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'NIK: ${_user?.nikOrUsername ?? "1371010101900001"}',
                            style: const TextStyle(color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on, size: 16, color: AppColors.textMuted),
                              const SizedBox(width: 4),
                              Text(
                                _user?.location ?? 'Pasir-pasir, Padang',
                                style: const TextStyle(color: AppColors.textMuted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatBadge('Rating', '⭐ ${_user?.rating ?? 4.9}'),
                              _buildStatBadge('Total Transaksi', '${_user?.totalSalesOrPurchases ?? 124}x'),
                              _buildStatBadge('Status KKP', 'Terverifikasi'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sertifikasi Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.workspace_premium, color: AppColors.accentGold),
                              SizedBox(width: 8),
                              Text(
                                'Sertifikasi Kelayakan',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: (_user?.certifications ??
                                    ['KKP Resmi', 'Sertifikasi Halal ID', 'Higiene Sanitasi Perikanan'])
                                .map((cert) {
                              return Chip(
                                avatar: const Icon(Icons.check_circle, color: Colors.green, size: 18),
                                label: Text(cert, style: const TextStyle(fontSize: 12)),
                                backgroundColor: Colors.green.withOpacity(0.08),
                                side: BorderSide(color: Colors.green.shade300),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Menu Actions
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.edit, color: AppColors.primary),
                          title: const Text('Edit Profil'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Fitur Edit Profil diaktifkan.')),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.contact_support, color: AppColors.primary),
                          title: const Text('Bantuan & Syarat KKP'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title: const Text('Keluar / Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                          onTap: _logout,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatBadge(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
      ],
    );
  }
}
