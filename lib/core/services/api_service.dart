/// File: lib/core/services/api_service.dart
/// Service Layer & Backend Simulator (Mock API) untuk NetLayan Padang

import 'dart:async';
import '../../models/fish_model.dart';
import '../../models/catch_model.dart';
import '../../models/order_model.dart';
import '../../models/user_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Master Ikan Padang
  final List<FishModel> _fishMasterList = [
    FishModel(
      id: 'f1',
      localName: 'Ikan Tongkol',
      latinName: 'Euthynnus affinis',
      category: 'Ikan Laut',
      estimatedMinPrice: 25000,
      estimatedMaxPrice: 35000,
      imageUrl: 'https://images.unsplash.com/photo-1534483509719-3feaee7c30da?w=500',
    ),
    FishModel(
      id: 'f2',
      localName: 'Ikan Kembung',
      latinName: 'Rastrelliger kanagurta',
      category: 'Ikan Laut',
      estimatedMinPrice: 30000,
      estimatedMaxPrice: 42000,
      imageUrl: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=500',
    ),
    FishModel(
      id: 'f3',
      localName: 'Ikan Tuna',
      latinName: 'Thunnus sp.',
      category: 'Ikan Laut',
      estimatedMinPrice: 65000,
      estimatedMaxPrice: 85000,
      imageUrl: 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=500',
    ),
    FishModel(
      id: 'f4',
      localName: 'Ikan Layang',
      latinName: 'Decapterus sp.',
      category: 'Ikan Laut',
      estimatedMinPrice: 22000,
      estimatedMaxPrice: 30000,
      imageUrl: 'https://images.unsplash.com/photo-1535591273668-578e31182c4f?w=500',
    ),
    FishModel(
      id: 'f5',
      localName: 'Ikan Selar',
      latinName: 'Selaroides leptolepis',
      category: 'Ikan Laut',
      estimatedMinPrice: 28000,
      estimatedMaxPrice: 38000,
      imageUrl: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=500',
    ),
    FishModel(
      id: 'f6',
      localName: 'Ikan Kerapu',
      latinName: 'Epinephelus sp.',
      category: 'Ikan Laut',
      estimatedMinPrice: 75000,
      estimatedMaxPrice: 110000,
      imageUrl: 'https://images.unsplash.com/photo-1534483509719-3feaee7c30da?w=500',
    ),
    FishModel(
      id: 'f7',
      localName: 'Ikan Kakak Merah',
      latinName: 'Lutjanus sp.',
      category: 'Ikan Laut',
      estimatedMinPrice: 70000,
      estimatedMaxPrice: 95000,
      imageUrl: 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=500',
    ),
    FishModel(
      id: 'f8',
      localName: 'Udang Laut',
      latinName: 'Penaeus sp.',
      category: 'Udang & Moluska',
      estimatedMinPrice: 85000,
      estimatedMaxPrice: 130000,
      imageUrl: 'https://images.unsplash.com/photo-1565680018434-b513d5e5fd47?w=500',
    ),
    FishModel(
      id: 'f9',
      localName: 'Cumi-cumi',
      latinName: 'Loligo sp.',
      category: 'Udang & Moluska',
      estimatedMinPrice: 60000,
      estimatedMaxPrice: 85000,
      imageUrl: 'https://images.unsplash.com/photo-1565680018434-b513d5e5fd47?w=500',
    ),
    FishModel(
      id: 'f10',
      localName: 'Kepiting Bakau',
      latinName: 'Scylla serrata',
      category: 'Udang & Moluska',
      estimatedMinPrice: 90000,
      estimatedMaxPrice: 140000,
      imageUrl: 'https://images.unsplash.com/photo-1535591273668-578e31182c4f?w=500',
    ),
  ];

  // List Tangkapan Mock
  final List<CatchModel> _catchList = [
    CatchModel(
      id: 'c1',
      fishermanId: 'nelayan1',
      fishermanName: 'Uda Buyung',
      fishermanLocation: 'Pasir-pasir, Padang',
      fishType: 'Ikan Tuna',
      latinName: 'Thunnus sp.',
      weightKg: 45.0,
      pricePerKg: 70000,
      photoUrl: 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=500',
      landingLocation: 'Muara Padang',
      catchTime: DateTime.now().subtract(const Duration(hours: 3)), // Grade A
      method: 'Pancing',
      size: 'Besar',
    ),
    CatchModel(
      id: 'c2',
      fishermanId: 'nelayan1',
      fishermanName: 'Uda Buyung',
      fishermanLocation: 'Pasir-pasir, Padang',
      fishType: 'Ikan Kerapu',
      latinName: 'Epinephelus sp.',
      weightKg: 20.0,
      pricePerKg: 85000,
      photoUrl: 'https://images.unsplash.com/photo-1534483509719-3feaee7c30da?w=500',
      landingLocation: 'Pasir-pasir, Padang',
      catchTime: DateTime.now().subtract(const Duration(hours: 4)), // Grade A
      method: 'Pancing',
      size: 'Sedang',
    ),
    CatchModel(
      id: 'c3',
      fishermanId: 'nelayan2',
      fishermanName: 'Pak Syamsul',
      fishermanLocation: 'Muara, Padang',
      fishType: 'Ikan Tongkol',
      latinName: 'Euthynnus affinis',
      weightKg: 60.0,
      pricePerKg: 28000,
      photoUrl: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=500',
      landingLocation: 'Air Manis, Padang',
      catchTime: DateTime.now().subtract(const Duration(hours: 8)), // Grade B
      method: 'Jaring',
      size: 'Sedang',
    ),
    CatchModel(
      id: 'c4',
      fishermanId: 'nelayan2',
      fishermanName: 'Pak Syamsul',
      fishermanLocation: 'Muara, Padang',
      fishType: 'Ikan Kembung',
      latinName: 'Rastrelliger kanagurta',
      weightKg: 35.0,
      pricePerKg: 32000,
      photoUrl: 'https://images.unsplash.com/photo-1535591273668-578e31182c4f?w=500',
      landingLocation: 'Teluk Bayur, Padang',
      catchTime: DateTime.now().subtract(const Duration(hours: 10)), // Grade B
      method: 'Jaring',
      size: 'Sedang',
    ),
    CatchModel(
      id: 'c5',
      fishermanId: 'nelayan1',
      fishermanName: 'Uda Buyung',
      fishermanLocation: 'Pasir-pasir, Padang',
      fishType: 'Ikan Layang',
      latinName: 'Decapterus sp.',
      weightKg: 80.0,
      pricePerKg: 22000,
      photoUrl: 'https://images.unsplash.com/photo-1534483509719-3feaee7c30da?w=500',
      landingLocation: 'Muara Padang',
      catchTime: DateTime.now().subtract(const Duration(hours: 18)), // Grade C
      method: 'Pukat',
      size: 'Kecil',
    ),
  ];

  // List Order Mock
  final List<OrderModel> _orderList = [
    OrderModel(
      id: 'ord1',
      buyerId: 'buyer1',
      buyerName: 'Suzuya Superstore Padang',
      buyerType: 'supermarket',
      destinationName: 'Suzuya Superstore Padang',
      destinationAddress: 'Jl. Pemuda No. 1, Padang Barat',
      catchItem: CatchModel(
        id: 'c1',
        fishermanId: 'nelayan1',
        fishermanName: 'Uda Buyung',
        fishermanLocation: 'Pasir-pasir, Padang',
        fishType: 'Ikan Tuna',
        latinName: 'Thunnus sp.',
        weightKg: 45.0,
        pricePerKg: 70000,
        photoUrl: 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=500',
        landingLocation: 'Muara Padang',
        catchTime: DateTime.now().subtract(const Duration(hours: 3)),
        method: 'Pancing',
        size: 'Besar',
      ),
      orderedWeightKg: 20.0,
      itemPricePerKg: 70000,
      transportFee: 50000,
      status: 'pending',
      orderDate: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  /// Get Master Ikan
  Future<List<FishModel>> getFishMaster() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_fishMasterList);
  }

  /// Tambah Master Ikan (Admin)
  Future<void> addFishMaster(FishModel fish) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _fishMasterList.add(fish);
  }

  /// Get All Catches (dapat diontrol filter grade, lokasi, & nama ikan)
  Future<List<CatchModel>> getCatches({
    String? grade,
    String? location,
    String? fishType,
    String? buyerType, // If supermarket, reject Grade C!
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _catchList.where((item) {
      if (!item.isAvailable) return false;

      // Rule Swalayan: HANYA Grade A & B
      if (buyerType == 'supermarket' && item.grade == 'C') {
        return false;
      }

      if (grade != null && grade.isNotEmpty && grade != 'Semua') {
        if (item.grade != grade) return false;
      }
      if (location != null && location.isNotEmpty && location != 'Semua') {
        if (!item.landingLocation.toLowerCase().contains(location.toLowerCase())) return false;
      }
      if (fishType != null && fishType.isNotEmpty) {
        final query = fishType.toLowerCase();
        if (!item.fishType.toLowerCase().contains(query) &&
            !item.latinName.toLowerCase().contains(query)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  /// Get Detail Catch
  Future<CatchModel?> getCatchById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _catchList.firstWhere((element) => element.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Upload Catch Baru (Nelayan)
  Future<CatchModel> createCatch(CatchModel catchData) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _catchList.insert(0, catchData);
    return catchData;
  }

  /// Get Catches by Fisherman ID
  Future<List<CatchModel>> getFishermanCatches(String fishermanId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _catchList.where((c) => c.fishermanId == fishermanId).toList();
  }

  /// Create Order Baru (Pembeli)
  Future<OrderModel> createOrder({
    required UserModel buyer,
    required CatchModel catchItem,
    required double quantityKg,
    required String destinationName,
    required String destinationAddress,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    // Validasi aturan Swalayan
    if (buyer.buyerType == 'supermarket' && catchItem.grade == 'C') {
      throw Exception('Kualitas tidak memenuhi kriteria swalayan. Swalayan hanya menerima Grade A & B.');
    }

    if (quantityKg > catchItem.weightKg) {
      throw Exception('Jumlah pesanan melebihi stok yang tersedia (${catchItem.weightKg} kg).');
    }

    final newOrder = OrderModel(
      id: 'ord_${DateTime.now().millisecondsSinceEpoch}',
      buyerId: buyer.id,
      buyerName: buyer.name,
      buyerType: buyer.buyerType ?? 'traditional_market',
      destinationName: destinationName,
      destinationAddress: destinationAddress,
      catchItem: catchItem,
      orderedWeightKg: quantityKg,
      itemPricePerKg: catchItem.pricePerKg,
      transportFee: 40000,
      status: 'pending',
      orderDate: DateTime.now(),
    );

    _orderList.insert(0, newOrder);
    return newOrder;
  }

  /// Get Orders
  Future<List<OrderModel>> getOrders({String? role, String? userId}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (role == 'fisherman' && userId != null) {
      return _orderList.where((o) => o.catchItem.fishermanId == userId).toList();
    } else if (role == 'buyer' && userId != null) {
      return _orderList.where((o) => o.buyerId == userId).toList();
    }
    return List.from(_orderList);
  }

  /// Update Status Order (Nelayan / Admin)
  Future<OrderModel> updateOrderStatus(String orderId, String newStatus, {String? reason}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _orderList.indexWhere((o) => o.id == orderId);
    if (index == -1) throw Exception('Order tidak ditemukan');

    final existing = _orderList[index];
    final updated = OrderModel(
      id: existing.id,
      buyerId: existing.buyerId,
      buyerName: existing.buyerName,
      buyerType: existing.buyerType,
      destinationName: existing.destinationName,
      destinationAddress: existing.destinationAddress,
      catchItem: existing.catchItem,
      orderedWeightKg: existing.orderedWeightKg,
      itemPricePerKg: existing.itemPricePerKg,
      transportFee: existing.transportFee,
      status: newStatus,
      orderDate: existing.orderDate,
      rejectionReason: reason ?? existing.rejectionReason,
    );

    _orderList[index] = updated;
    return updated;
  }

  /// Statistic Data Nelayan Dashboard
  Future<Map<String, dynamic>> getFishermanDashboardStats(String fishermanId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final catches = _catchList.where((c) => c.fishermanId == fishermanId).toList();
    final orders = _orderList.where((o) => o.catchItem.fishermanId == fishermanId).toList();

    double totalWeightThisMonth = catches.fold(0.0, (sum, item) => sum + item.weightKg);
    double totalIncomeThisMonth = orders
        .where((o) => o.status == 'delivered' || o.status == 'confirmed' || o.status == 'shipped')
        .fold(0.0, (sum, item) => sum + item.grandTotal);

    int pendingOrders = orders.where((o) => o.status == 'pending').length;
    int completedOrders = orders.where((o) => o.status == 'delivered').length;

    return {
      'totalWeightThisMonth': totalWeightThisMonth,
      'totalIncomeThisMonth': totalIncomeThisMonth,
      'pendingOrders': pendingOrders,
      'completedOrders': completedOrders,
      'monthlyEarnings': [12500000.0, 14200000.0, 16800000.0, 15000000.0, 18500000.0, 21000000.0],
      'monthLabels': ['Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt'],
    };
  }

  /// Admin Verify Fisherman
  Future<void> verifyFisherman(String fishermanId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
