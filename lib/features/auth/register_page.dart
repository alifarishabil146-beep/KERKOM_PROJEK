/// File: lib/features/auth/register_page.dart
/// Halaman Pendaftaran Nelayan Baru NETLAYAN

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import 'auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthController _controller = AuthController();
  final _nameController = TextEditingController();
  final _nikController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController(text: 'Pasir-pasir, Padang');
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  final List<String> _padangLocations = [
    'Pasir-pasir, Padang',
    'Muara, Padang',
    'Air Manis, Padang',
    'Teluk Bayur, Padang',
    'Bungus Teluk Kabung, Padang',
    'Pariaman',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _nikController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Registrasi Nelayan Baru'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data Diri Nelayan Padang',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Daftar untuk akses jualan langsung ke pasar & swalayan tanpa perantara.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),

                    // Nama Lengkap
                    const Text('Nama Lengkap', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: 'Contoh: Uda Ajo Buyung',
                      ),
                    ),
                    const SizedBox(height: 14),

                    // NIK
                    const Text('NIK (16 Digit)', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nikController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.badge),
                        hintText: '137101xxxxxxxxx',
                      ),
                    ),
                    const SizedBox(height: 14),

                    // No Handphone
                    const Text('Nomor HP / WhatsApp', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        hintText: '0812xxxxxxxx',
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Lokasi Basis Pendaratan
                    const Text('Lokasi Basis Pendaratan Ikan', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _padangLocations.contains(_locationController.text)
                          ? _locationController.text
                          : _padangLocations.first,
                      items: _padangLocations.map((loc) {
                        return DropdownMenuItem(value: loc, child: Text(loc));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _locationController.text = val;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.location_on),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Password
                    const Text('Password', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        hintText: 'Password akun',
                      ),
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              _controller.handleRegisterNelayan(
                                context: context,
                                name: _nameController.text,
                                nik: _nikController.text,
                                phone: _phoneController.text,
                                location: _locationController.text,
                                password: _passwordController.text,
                                setLoading: (val) {
                                  setState(() {
                                    _isLoading = val;
                                  });
                                },
                              );
                            },
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Daftar Akun Nelayan'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
