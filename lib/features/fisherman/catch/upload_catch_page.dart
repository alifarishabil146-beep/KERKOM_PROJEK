/// File: lib/features/fisherman/catch/upload_catch_page.dart
/// Form Upload Tangkapan Ikan Baru + Auto-Calculate Grade Kesegaran

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/token_storage.dart';
import '../../../core/utils/currency.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../models/catch_model.dart';
import '../../../models/fish_model.dart';
import '../../../models/user_model.dart';
import '../../../routes.dart';

class UploadCatchPage extends StatefulWidget {
  const UploadCatchPage({super.key});

  @override
  State<UploadCatchPage> createState() => _UploadCatchPageState();
}

class _UploadCatchPageState extends State<UploadCatchPage> {
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();

  UserModel? _currentUser;
  List<FishModel> _fishMasterList = [];

  FishModel? _selectedFish;
  final _weightController = TextEditingController(text: '30');
  final _priceController = TextEditingController(text: '35000');
  String _landingLocation = 'Pasir-pasir, Padang';
  DateTime _catchTime = DateTime.now().subtract(const Duration(hours: 2));
  String _method = 'Pancing'; // Pancing, Jaring, Pukat
  String _size = 'Sedang'; // Kecil, Sedang, Besar

  XFile? _imageFile;
  bool _isLoading = false;

  final List<String> _landingLocations = [
    'Pasir-pasir, Padang',
    'Muara, Padang',
    'Air Manis, Padang',
    'Teluk Bayur, Padang',
    'Bungus, Padang',
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _currentUser = await TokenStorage.getUser();
    final master = await _apiService.getFishMaster();
    if (mounted) {
      setState(() {
        _fishMasterList = master;
        if (master.isNotEmpty) {
          _selectedFish = master.first;
          _priceController.text = master.first.estimatedMinPrice.toStringAsFixed(0);
        }
      });
    }
  }

  /// Evaluasi Auto-Grade
  String get _calculatedGrade {
    final diffHours = DateTime.now().difference(_catchTime).inHours;
    if (diffHours < 6) return 'A';
    if (diffHours < 12) return 'B';
    return 'C';
  }

  Color get _gradeColor {
    switch (_calculatedGrade) {
      case 'A':
        return AppColors.gradeA;
      case 'B':
        return AppColors.gradeB;
      case 'C':
      default:
        return AppColors.gradeC;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(source: source, imageQuality: 80);
      if (picked != null) {
        setState(() {
          _imageFile = picked;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil foto: $e')),
        );
      }
    }
  }

  Future<void> _selectCatchTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _catchTime,
      firstDate: DateTime.now().subtract(const Duration(days: 3)),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_catchTime),
      );
      if (pickedTime != null) {
        setState(() {
          _catchTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _submitCatch() async {
    if (_selectedFish == null) return;
    final weight = double.tryParse(_weightController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0;

    if (weight <= 0 || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan berat dan harga yang valid.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final newCatch = CatchModel(
        id: 'c_${DateTime.now().millisecondsSinceEpoch}',
        fishermanId: _currentUser?.id ?? 'nelayan1',
        fishermanName: _currentUser?.name ?? 'Uda Buyung',
        fishermanLocation: _currentUser?.location ?? 'Pasir-pasir, Padang',
        fishType: _selectedFish!.localName,
        latinName: _selectedFish!.latinName,
        weightKg: weight,
        pricePerKg: price,
        photoUrl: _imageFile != null ? _imageFile!.path : _selectedFish!.imageUrl,
        landingLocation: _landingLocation,
        catchTime: _catchTime,
        method: _method,
        size: _size,
      );

      await _apiService.createCatch(newCatch);
      setState(() => _isLoading = false);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil upload tangkapan (${newCatch.fishType} Grade ${newCatch.grade})!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, AppRoutes.catchList);
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal upload: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalEstimate = (double.tryParse(_weightController.text) ?? 0) *
        (double.tryParse(_priceController.text) ?? 0);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Upload Tangkapan Baru'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card Indikator Grade Otomatis
            Card(
              color: _gradeColor.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: _gradeColor, width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: _gradeColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Grade $_calculatedGrade',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
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
                            _calculatedGrade == 'A'
                                ? 'Kualitas Segar Laut Super'
                                : (_calculatedGrade == 'B' ? 'Kualitas Baik' : 'Kualitas Standar'),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: _gradeColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _calculatedGrade == 'C'
                                ? 'Hanya layak untuk Pasar Tradisional (Swalayan menolak Grade C).'
                                : 'Layak dijual ke Swalayan (Suzuya) & Pasar Tradisional.',
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

            // Form Upload Container
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Picker Foto Ikan
                    const Text('Foto Tangkapan Ikan', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (ctx) => Wrap(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.camera_alt),
                                title: const Text('Ambil dari Kamera'),
                                onTap: () {
                                  Navigator.pop(ctx);
                                  _pickImage(ImageSource.camera);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.photo_library),
                                title: const Text('Pilih dari Galeri'),
                                onTap: () {
                                  Navigator.pop(ctx);
                                  _pickImage(ImageSource.gallery);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: _imageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(_imageFile!.path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.add_a_photo, size: 40, color: AppColors.primary),
                                  SizedBox(height: 8),
                                  Text(
                                    'Ketuk untuk Ambil / Upload Foto Ikan',
                                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Jenis Ikan Dropdown
                    const Text('Jenis Ikan Padang', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<FishModel>(
                      value: _selectedFish,
                      items: _fishMasterList.map((fish) {
                        return DropdownMenuItem(
                          value: fish,
                          child: Text('${fish.localName} (${fish.latinName})'),
                        );
                      }).toList(),
                      onChanged: (fish) {
                        if (fish != null) {
                          setState(() {
                            _selectedFish = fish;
                            _priceController.text = fish.estimatedMinPrice.toStringAsFixed(0);
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Berat & Harga Per Kg
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Berat Total (kg)', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _weightController,
                                keyboardType: TextInputType.number,
                                onChanged: (val) => setState(() {}),
                                decoration: const InputDecoration(
                                  suffixText: 'kg',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Harga per kg (Rp)', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _priceController,
                                keyboardType: TextInputType.number,
                                onChanged: (val) => setState(() {}),
                                decoration: const InputDecoration(
                                  prefixText: 'Rp ',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Waktu Penangkapan & Landing Location
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Waktu Tangkap', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              OutlinedButton.icon(
                                onPressed: _selectCatchTime,
                                icon: const Icon(Icons.access_time, size: 18),
                                label: Text(
                                  DateFormatter.formatHoursAgo(_catchTime),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Lokasi Landing', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                value: _landingLocation,
                                items: _landingLocations.map((loc) {
                                  return DropdownMenuItem(
                                    value: loc,
                                    child: Text(loc, style: const TextStyle(fontSize: 13)),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _landingLocation = val);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Metode Tangkap
                    const Text('Metode Penangkapan', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Row(
                      children: ['Pancing', 'Jaring', 'Pukat'].map((m) {
                        return Expanded(
                          child: RadioListTile<String>(
                            title: Text(m, style: const TextStyle(fontSize: 12)),
                            value: m,
                            groupValue: _method,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (val) {
                              if (val != null) setState(() => _method = val);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),

                    // Ukuran Ikan
                    const Text('Ukuran Ikan', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Row(
                      children: ['Kecil', 'Sedang', 'Besar'].map((sz) {
                        final isSelected = _size == sz;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(sz),
                            selected: isSelected,
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                            ),
                            onSelected: (val) {
                              if (val) setState(() => _size = sz);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Summary Total Nilai Tangkapan
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Estimasi Nilai Total:', style: TextStyle(fontWeight: FontWeight.w600)),
                          Text(
                            CurrencyFormatter.formatRupiah(totalEstimate),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitCatch,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Publish Tangkapan'),
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
