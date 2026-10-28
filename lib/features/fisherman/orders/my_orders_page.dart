/// File: lib/features/fisherman/orders/my_orders_page.dart
/// Kelola Pesanan Masuk Nelayan (Konfirmasi/Tolak Order dari Swalayan & Pasar)

import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/token_storage.dart';
import '../../../core/utils/currency.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../models/order_model.dart';
import '../../../models/user_model.dart';

class FishermanOrdersPage extends StatefulWidget {
  const FishermanOrdersPage({super.key});

  @override
  State<FishermanOrdersPage> createState() => _FishermanOrdersPageState();
}

class _FishermanOrdersPageState extends State<FishermanOrdersPage> {
  final ApiService _apiService = ApiService();
  List<OrderModel> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() => _isLoading = true);
    final user = await TokenStorage.getUser();
    if (user != null) {
      final list = await _apiService.getOrders(role: 'fisherman', userId: user.id);
      if (mounted) {
        setState(() {
          _orders = list;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateStatus(String orderId, String newStatus, {String? reason}) async {
    try {
      await _apiService.updateOrderStatus(orderId, newStatus, reason: reason);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status order berhasil diperbarui ke $newStatus!'),
            backgroundColor: Colors.green,
          ),
        );
      }
      _fetchOrders();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return AppColors.statusConfirmed;
      case 'shipped':
        return AppColors.statusShipped;
      case 'delivered':
        return AppColors.statusDelivered;
      case 'rejected':
        return AppColors.statusRejected;
      case 'pending':
      default:
        return AppColors.statusPending;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Order Masuk Nelayan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchOrders,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? const Center(
                  child: Text('Belum ada order masuk dari pembeli.'),
                )
              : RefreshIndicator(
                  onRefresh: _fetchOrders,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _orders.length,
                    itemBuilder: (context, index) {
                      final order = _orders[index];
                      final statusColor = _getStatusColor(order.status);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      order.destinationName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: statusColor),
                                    ),
                                    child: Text(
                                      order.status.toUpperCase(),
                                      style: TextStyle(
                                        color: statusColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                order.buyerType == 'supermarket'
                                    ? 'Kategori Pembeli: Swalayan (Suzuya)'
                                    : 'Kategori Pembeli: Pasar Tradisional',
                                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                              ),
                              const Divider(height: 20),

                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      order.catchItem.photoUrl,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 60,
                                        height: 60,
                                        color: Colors.grey.shade300,
                                        child: const Icon(Icons.phishing),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${order.catchItem.fishType} (Grade ${order.catchItem.grade})',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Pesanan: ${order.orderedWeightKg} kg @ ${CurrencyFormatter.formatRupiah(order.itemPricePerKg)}',
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Tanggal: ${DateFormatter.formatDateTime(order.orderDate)}',
                                          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total Pembayaran:', style: TextStyle(color: AppColors.textMuted)),
                                  Text(
                                    CurrencyFormatter.formatRupiah(order.grandTotal),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Tombol Aksi Konfirmasi / Tolak / Kirim
                              if (order.status == 'pending') ...[
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          _updateStatus(order.id, 'rejected', reason: 'Stok habis');
                                        },
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.red,
                                          side: const BorderSide(color: Colors.red),
                                        ),
                                        child: const Text('Tolak Order'),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _updateStatus(order.id, 'confirmed');
                                        },
                                        child: const Text('Terima Order'),
                                      ),
                                    ),
                                  ],
                                ),
                              ] else if (order.status == 'confirmed') ...[
                                ElevatedButton.icon(
                                  onPressed: () {
                                    _updateStatus(order.id, 'shipped');
                                  },
                                  icon: const Icon(Icons.local_shipping),
                                  label: const Text('Kirim Barang (Dalam Pengiriman)'),
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.statusShipped),
                                ),
                              ] else if (order.status == 'shipped') ...[
                                ElevatedButton.icon(
                                  onPressed: () {
                                    _updateStatus(order.id, 'delivered');
                                  },
                                  icon: const Icon(Icons.check_circle),
                                  label: const Text('Konfirmasi Diterima Pembeli'),
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.statusDelivered),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
