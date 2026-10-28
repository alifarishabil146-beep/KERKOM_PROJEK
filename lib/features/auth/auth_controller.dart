/// File: lib/features/auth/auth_controller.dart
/// Controller Logic untuk Autentikasi NETLAYAN

import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../../models/user_model.dart';
import '../../routes.dart';

class AuthController {
  final AuthService _authService = AuthService();

  /// Handle Process Login
  Future<void> handleLogin({
    required BuildContext context,
    required String nikOrUsername,
    required String password,
    required String selectedRole,
    required Function(bool) setLoading,
  }) async {
    if (nikOrUsername.trim().isEmpty || password.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan isi NIK/Username dan Password.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setLoading(true);
    try {
      final UserModel user = await _authService.login(
        nikOrUsername: nikOrUsername,
        password: password,
        targetRole: selectedRole,
      );

      setLoading(false);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selamat Datang, ${user.name}!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigasi Sesuai Role
      if (user.role == 'fisherman') {
        Navigator.pushReplacementNamed(context, AppRoutes.fishermanDashboard);
      } else if (user.role == 'buyer') {
        Navigator.pushReplacementNamed(context, AppRoutes.buyerDashboard);
      } else if (user.role == 'admin') {
        Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
      }
    } catch (e) {
      setLoading(false);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Handle Registration Nelayan
  Future<void> handleRegisterNelayan({
    required BuildContext context,
    required String name,
    required String nik,
    required String phone,
    required String location,
    required String password,
    required Function(bool) setLoading,
  }) async {
    if (name.isEmpty || nik.isEmpty || phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap lengkapi semua kolom pendaftaran.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setLoading(true);
    try {
      final user = await _authService.registerNelayan(
        name: name,
        nik: nik,
        phone: phone,
        location: location,
        password: password,
      );

      setLoading(false);
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registrasi berhasil! Selamat Datang, ${user.name}'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacementNamed(context, AppRoutes.fishermanDashboard);
    } catch (e) {
      setLoading(false);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
