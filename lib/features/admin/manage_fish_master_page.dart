/// File: lib/features/admin/manage_fish_master_page.dart
/// Pengelolaan Master Data Jenis Ikan Lokal Padang oleh Admin

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/services/api_service.dart';
import '../../core/utils/currency.dart';
import '../../models/fish_model.dart';

class ManageFishMasterPage extends StatefulWidget {
  const ManageFishMasterPage({super.key});

  @override
  State<ManageFishMasterPage> createState() => _ManageFishMasterPageState();
}

class _ManageFishMasterPageState extends State<ManageFishMasterPage> {
  final ApiService _apiService = ApiService();
  List<FishModel> _fishList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFishMaster();
  }

  Future<void> _fetchFishMaster() async {
    setState(() => _isLoading = true);
    final list = await _apiService.getFishMaster();
    if (mounted) {
      setState(() {
        _fishList = list;
        _isLoading = false;
      });
    }
  }

  void _showAddFishDialog() {
    final nameController = TextEditingController();
    final latinController = TextEditingController();
    final minPriceController = TextEditingController();
    final maxPriceController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Master Jenis Ikan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Lokal (contoh: Ikan Tenggiri)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: latinController,
                decoration: const InputDecoration(labelText: 'Nama Latin (contoh: Scomberomorus commerson)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: minPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Estimasi Harga Min (Rp)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: maxPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Estimasi Harga Max (Rp)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                final newFish = FishModel(
                  id: 'f_${DateTime.now().millisecondsSinceEpoch}',
                  localName: nameController.text,
                  latinName: latinController.text.isEmpty ? 'Species sp.' : latinController.text,
                  category: 'Ikan Laut',
                  estimatedMinPrice: double.tryParse(minPriceController.text) ?? 30000,
                  estimatedMaxPrice: double.tryParse(maxPriceController.text) ?? 45000,
                  imageUrl: 'https://images.unsplash.com/photo-1534483509719-3feaee7c30da?w=500',
                );

                await _apiService.addFishMaster(newFish);
                if (mounted) {
                  Navigator.pop(ctx);
                  _fetchFishMaster();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Jenis ikan baru berhasil ditambahkan!')),
                  );
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Master Data Ikan Padang'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddFishDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _fishList.length,
              itemBuilder: (context, index) {
                final fish = _fishList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: const Icon(Icons.phishing, color: AppColors.primary),
                    ),
                    title: Text(
                      fish.localName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${fish.latinName}\nKisaran: ${CurrencyFormatter.formatRupiah(fish.estimatedMinPrice)} - ${CurrencyFormatter.formatRupiah(fish.estimatedMaxPrice)}',
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFishDialog,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.accentGold),
      ),
    );
  }
}
