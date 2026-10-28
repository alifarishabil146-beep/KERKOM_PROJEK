/// File: lib/core/services/auth_service.dart
/// Service Otentikasi Multi-Role NETLAYAN (Nelayan, Pembeli, Admin)

import 'dart:async';
import '../../models/user_model.dart';
import 'token_storage.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Database User Mock
  final List<UserModel> _users = [
    // Nelayan 1
    UserModel(
      id: 'nelayan1',
      name: 'Uda Buyung',
      nikOrUsername: '1371010101900001',
      role: 'fisherman',
      phone: '081267891234',
      location: 'Pasir-pasir, Padang',
      avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
      certifications: ['KKP Resmi', 'Sertifikasi Halal ID', 'Higiene Sanitasi Perikanan'],
      rating: 4.9,
      totalSalesOrPurchases: 124,
      isVerified: true,
    ),
    // Nelayan 2
    UserModel(
      id: 'nelayan2',
      name: 'Pak Syamsul',
      nikOrUsername: '1371010101900002',
      role: 'fisherman',
      phone: '081377889900',
      location: 'Muara, Padang',
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      certifications: ['KKP Resmi', 'Sertifikasi Higiene'],
      rating: 4.8,
      totalSalesOrPurchases: 89,
      isVerified: true,
    ),
    // Pembeli 1 - Swalayan Suzuya Padang
    UserModel(
      id: 'buyer1',
      name: 'Suzuya Superstore Padang',
      nikOrUsername: 'suzuya',
      role: 'buyer',
      phone: '075134567',
      location: 'Jl. Pemuda No. 1, Padang Barat',
      buyerType: 'supermarket',
      institutionName: 'Suzuya Superstore Padang',
      totalSalesOrPurchases: 340,
      isVerified: true,
    ),
    // Pembeli 2 - Pasar Bawah Padang
    UserModel(
      id: 'buyer2',
      name: 'Koperasi Pasar Bawah Padang',
      nikOrUsername: 'pasarbawah',
      role: 'buyer',
      phone: '075188899',
      location: 'Pasar Bawah, Padang',
      buyerType: 'traditional_market',
      institutionName: 'Pasar Bawah Padang',
      totalSalesOrPurchases: 512,
      isVerified: true,
    ),
    // Admin
    UserModel(
      id: 'admin1',
      name: 'Admin Dinas Perikanan Padang',
      nikOrUsername: 'admin',
      role: 'admin',
      phone: '0751123456',
      location: 'Kantor Wali Kota Padang',
      isVerified: true,
    ),
  ];

  /// Login Function
  Future<UserModel> login({
    required String nikOrUsername,
    required String password,
    required String targetRole,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    // Validasi dummy password
    if (password.length < 4) {
      throw Exception('Password minimal 4 karakter');
    }

    try {
      final user = _users.firstWhere(
        (u) =>
            u.nikOrUsername.toLowerCase() == nikOrUsername.toLowerCase().trim() &&
            u.role == targetRole,
      );

      final token = 'mock_jwt_token_${user.id}_${DateTime.now().millisecondsSinceEpoch}';
      await TokenStorage.saveSession(token: token, user: user);
      return user;
    } catch (_) {
      throw Exception('NIK/Username tidak ditemukan atau Role tidak cocok');
    }
  }

  /// Register Nelayan Baru
  Future<UserModel> registerNelayan({
    required String name,
    required String nik,
    required String phone,
    required String location,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (nik.length < 10) {
      throw Exception('NIK tidak valid');
    }

    final exists = _users.any((u) => u.nikOrUsername == nik);
    if (exists) {
      throw Exception('NIK ini sudah terdaftar di sistem NetLayan');
    }

    final newUser = UserModel(
      id: 'nelayan_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      nikOrUsername: nik,
      role: 'fisherman',
      phone: phone,
      location: location,
      certifications: ['Sertifikasi Higiene Awal'],
      rating: 5.0,
      totalSalesOrPurchases: 0,
      isVerified: true,
    );

    _users.add(newUser);
    final token = 'mock_jwt_token_${newUser.id}';
    await TokenStorage.saveSession(token: token, user: newUser);
    return newUser;
  }

  /// Get Current User
  Future<UserModel?> getCurrentUser() async {
    return await TokenStorage.getUser();
  }

  /// Logout
  Future<void> logout() async {
    await TokenStorage.clearSession();
  }

  /// Get Unverified Fishermen for Admin
  Future<List<UserModel>> getUnverifiedFishermen() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _users.where((u) => u.role == 'fisherman').toList();
  }
}
