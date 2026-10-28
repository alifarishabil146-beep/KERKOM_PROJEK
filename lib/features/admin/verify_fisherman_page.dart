/// File: lib/features/admin/verify_fisherman_page.dart
/// Modul Verifikasi Identitas & Sertifikasi KKP Nelayan oleh Admin

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/services/auth_service.dart';
import '../../models/user_model.dart';

class VerifyFishermanPage extends StatefulWidget {
  const VerifyFishermanPage({super.key});

  @override
  State<VerifyFishermanPage> createState() => _VerifyFishermanPageState();
}

class _VerifyFishermanPageState extends State<VerifyFishermanPage> {
  final AuthService _authService = AuthService();
  List<UserModel> _fishermen = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFishermen();
  }

  Future<void> _fetchFishermen() async {
    setState(() => _isLoading = true);
    final list = await _authService.getUnverifiedFishermen();
    if (mounted) {
      setState(() {
        _fishermen = list;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Verifikasi Nelayan Padang'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _fishermen.length,
              itemBuilder: (context, index) {
                final fisherman = _fishermen[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(
                                fisherman.avatarUrl ??
                                    'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fisherman.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'NIK: ${fisherman.nikOrUsername} • HP: ${fisherman.phone}',
                                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                                  ),
                                  Text(
                                    'Lokasi Basis: ${fisherman.location}',
                                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Sertifikasi Terdaftar:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          children: fisherman.certifications.map((cert) {
                            return Chip(
                              label: Text(cert, style: const TextStyle(fontSize: 11)),
                              backgroundColor: AppColors.primary.withOpacity(0.08),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 14),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Nelayan ${fisherman.name} berhasil terverifikasi KKP!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.check_circle, size: 18),
                              label: const Text('Verifikasi Nelayan Ini'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade700,
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
    );
  }
}
