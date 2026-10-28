/// File: lib/features/buyer/orders/create_order_page.dart
/// Form Buat Order Baru Pembeli + Validasi Aturan Swalayan (Grade C Rejected)

import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/token_storage.dart';
import '../../../core/utils/currency.dart';
import '../../../models/catch_model.dart';
import '../../../models/user_model.dart';
import '../../../routes.dart';

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({super.key});

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  final ApiService _apiService = ApiService();
  final _quantityController = TextEditingController(text: '10');
  final _addressController = TextEditingController();
  final _destinationNameController = TextEditingController();

  UserModel? _currentUser;
  CatchModel? _catchItem;
  bool _isLoading = false;
  double _transportFee = 40000;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await TokenStorage.getUser();
    if (mounted) {
      setState(() {
        _currentUser = user;
        if (user != null) {
          _destinationNameController.text = user.institutionName ?? user.name;
          _addressController.text = user.location;
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is CatchModel) {
      _catchItem = args;
    }
  }

  Future<void> _submitOrder() async {
    if (_catchItem == null || _currentUser == null) return;
    final qty = double.tryParse(_quantityController.text) ?? 0;

    if (qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan jumlah kg yang valid.')),
      );
      return;
    }

    if (qty > _catchItem!.weightKg) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Jumlah melebihi stok tersedia (${_catchItem!.weightKg} kg).')),
      );
      return;
    }

    // VALIDASI KHUSUS SWALAYAN (Grade C ditolak)
    if (_currentUser!.buyerType == 'supermarket' && _catchItem!.grade == 'C') {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text('Kualitas Ditolak'),
            ],
          ),
          content: const Text(
            'Kualitas tidak memenuhi kriteria swalayan.\n\nSwalayan HANYA menerima pasokan ikan Grade A (<6 jam) dan Grade B (<12 jam). Ikan Grade C hanya dapat dipesan oleh Pasar Tradisional.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Mengerti'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _apiService.createOrder(
        buyer: _currentUser!,
        catchItem: _catchItem!,
        quantityKg: qty,
        destinationName: _destinationNameController.text,
        destinationAddress: _addressController.text,
      );

      setState(() => _isLoading = false);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order berhasil dibuat! Menunggu konfirmasi nelayan.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, AppRoutes.buyerOrders);
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _addressController.dispose();
    _destinationNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_catchItem == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Buat Order')),
        body: const Center(child: Text('Data ikan tidak ditemukan.')),
      );
    }

    final qty = double.tryParse(_quantityController.text) ?? 0;
    final subtotal = qty * _catchItem!.pricePerKg;
    final grandTotal = subtotal + _transportFee;
    final isSupermarket = _currentUser?.buyerType == 'supermarket';
    final isGradeC = _catchItem!.grade == 'C';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Form Pemesanan Ikan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner Peringatan Kriteria jika Swalayan & Grade C
            if (isSupermarket && isGradeC)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade400),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.block, color: Colors.red),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'PERINGATAN: Ikan ini berkategori Grade C. Swalayan (Suzuya) tidak dapat memesan ikan Grade C.',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

            // Item Order Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        _catchItem!.photoUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.phishing),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _catchItem!.fishType,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Grade ${_catchItem!.grade} • ${CurrencyFormatter.formatRupiah(_catchItem!.pricePerKg)}/kg',
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Stok Maks: ${_catchItem!.weightKg} kg',
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                          Text(
                            'Nelayan: ${_catchItem!.fishermanName}',
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

            // Form Input Order
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Detail Pesanan', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),

                    const Text('Jumlah Pesanan (kg)', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      onChanged: (val) => setState(() {}),
                      decoration: InputDecoration(
                        suffixText: 'kg (Stok: ${_catchItem!.weightKg} kg)',
                      ),
                    ),
                    const SizedBox(height: 14),

                    const Text('Nama Tujuan Pengiriman', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _destinationNameController,
                      decoration: const InputDecoration(
                        hintText: 'Contoh: Suzuya Superstore Padang / Pasar Bawah',
                      ),
                    ),
                    const SizedBox(height: 14),

                    const Text('Alamat Lengkap Tujuan', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _addressController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: 'Alamat tujuan penerimaan ikan',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Cost Summary Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rincian Pembayaran', style: Theme.of(context).textTheme.titleLarge),
                    const Divider(height: 20),
                    _buildCostRow('Harga Ikan (${qty.toStringAsFixed(0)} kg)', CurrencyFormatter.formatRupiah(subtotal)),
                    _buildCostRow('Biaya Transport & Cold Storage', CurrencyFormatter.formatRupiah(_transportFee)),
                    const Divider(height: 20),
                    _buildCostRow('Total Pembayaran', CurrencyFormatter.formatRupiah(grandTotal), isTotal: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _isLoading ? null : _submitOrder,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Konfirmasi & Buat Pesanan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
