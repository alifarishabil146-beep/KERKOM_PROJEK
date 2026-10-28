/// File: lib/features/auth/login_page.dart
/// Halaman Login Multi-Role (Nelayan, Pembeli, Admin) NETLAYAN Padang

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../routes.dart';
import 'auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController _controller = AuthController();
  final _nikController = TextEditingController(text: '1371010101900001');
  final _passwordController = TextEditingController(text: '123456');

  String _selectedRole = 'fisherman'; // 'fisherman', 'buyer', 'admin'
  bool _isLoading = false;

  void _fillPresetCredentials(String role) {
    setState(() {
      _selectedRole = role;
      if (role == 'fisherman') {
        _nikController.text = '1371010101900001';
        _passwordController.text = '123456';
      } else if (role == 'buyer') {
        _nikController.text = 'suzuya';
        _passwordController.text = '123456';
      } else if (role == 'admin') {
        _nikController.text = 'admin';
        _passwordController.text = '123456';
      }
    });
  }

  @override
  void dispose() {
    _nikController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo & Header Brand
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.phishing,
                    size: 48,
                    color: AppColors.accentGold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'NETLAYAN',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppColors.primary,
                        letterSpacing: 1.5,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Menghubungkan Nelayan Padang Langsung ke Pasar & Swalayan',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMuted,
                      ),
                ),
                const SizedBox(height: 32),

                // Card Container Form
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pilih Peran Masuk',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),

                        // Role Segmented Buttons
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              _buildRoleTab('fisherman', 'Nelayan', Icons.sailing),
                              _buildRoleTab('buyer', 'Pembeli', Icons.storefront),
                              _buildRoleTab('admin', 'Admin', Icons.admin_panel_settings),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Form Inputs
                        Text(
                          _selectedRole == 'fisherman'
                              ? 'NIK Nelayan'
                              : (_selectedRole == 'buyer' ? 'Username Pembeli' : 'Username Admin'),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _nikController,
                          keyboardType: _selectedRole == 'fisherman'
                              ? TextInputType.number
                              : TextInputType.text,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
                            hintText: _selectedRole == 'fisherman'
                                ? 'Masukkan 16 digit NIK'
                                : 'Masukkan username',
                          ),
                        ),
                        const SizedBox(height: 16),

                        Text(
                          'Password',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
                            hintText: 'Masukkan password',
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Quick Test Presets Shortcut
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.flash_on, size: 16, color: AppColors.accentGold),
                                  SizedBox(width: 4),
                                  Text(
                                    'Demo Quick Login (Padang Preset):',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 8,
                                children: [
                                  ActionChip(
                                    label: const Text('Nelayan Uda Buyung', style: TextStyle(fontSize: 11)),
                                    onPressed: () => _fillPresetCredentials('fisherman'),
                                  ),
                                  ActionChip(
                                    label: const Text('Suzuya Supermarket', style: TextStyle(fontSize: 11)),
                                    onPressed: () => _fillPresetCredentials('buyer'),
                                  ),
                                  ActionChip(
                                    label: const Text('Pasar Bawah', style: TextStyle(fontSize: 11)),
                                    onPressed: () {
                                      _fillPresetCredentials('buyer');
                                      _nikController.text = 'pasarbawah';
                                    },
                                  ),
                                  ActionChip(
                                    label: const Text('Admin Dinas', style: TextStyle(fontSize: 11)),
                                    onPressed: () => _fillPresetCredentials('admin'),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Login Action Button
                        ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  _controller.handleLogin(
                                    context: context,
                                    nikOrUsername: _nikController.text,
                                    password: _passwordController.text,
                                    selectedRole: _selectedRole,
                                    setLoading: (val) {
                                      setState(() {
                                        _isLoading = val;
                                      });
                                    },
                                  );
                                },
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  _selectedRole == 'fisherman'
                                      ? 'Masuk sebagai Nelayan'
                                      : (_selectedRole == 'buyer'
                                          ? 'Masuk sebagai Pembeli'
                                          : 'Masuk sebagai Admin'),
                                ),
                        ),
                        const SizedBox(height: 16),

                        // Register Option for Fishermen
                        if (_selectedRole == 'fisherman')
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.register);
                            },
                            child: const Text('Register Nelayan Baru'),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleTab(String role, String label, IconData icon) {
    final isSelected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => _fillPresetCredentials(role),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? AppColors.accentGold : AppColors.textMuted,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
