/// File: lib/models/order_model.dart
/// Model Data Order/Transaksi Pembeli - Nelayan di NETLAYAN

import 'catch_model.dart';

class OrderModel {
  final String id;
  final String buyerId;
  final String buyerName;
  final String buyerType; // 'supermarket' atau 'traditional_market'
  final String destinationName; // Contoh: "Suzuya Superstore Padang", "Pasar Bawah Padang"
  final String destinationAddress;
  final CatchModel catchItem;
  final double orderedWeightKg;
  final double itemPricePerKg;
  final double transportFee;
  final String status; // 'pending', 'confirmed', 'shipped', 'delivered', 'rejected'
  final DateTime orderDate;
  final String? rejectionReason;

  OrderModel({
    required this.id,
    required this.buyerId,
    required this.buyerName,
    required this.buyerType,
    required this.destinationName,
    required this.destinationAddress,
    required this.catchItem,
    required this.orderedWeightKg,
    required this.itemPricePerKg,
    required this.transportFee,
    required this.status,
    required this.orderDate,
    this.rejectionReason,
  });

  double get subtotal => orderedWeightKg * itemPricePerKg;
  double get grandTotal => subtotal + transportFee;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      buyerId: json['buyerId'] ?? '',
      buyerName: json['buyerName'] ?? '',
      buyerType: json['buyerType'] ?? 'traditional_market',
      destinationName: json['destinationName'] ?? '',
      destinationAddress: json['destinationAddress'] ?? '',
      catchItem: CatchModel.fromJson(json['catchItem'] ?? {}),
      orderedWeightKg: (json['orderedWeightKg'] ?? 0).toDouble(),
      itemPricePerKg: (json['itemPricePerKg'] ?? 0).toDouble(),
      transportFee: (json['transportFee'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      orderDate: DateTime.parse(json['orderDate'] ?? DateTime.now().toIso8601String()),
      rejectionReason: json['rejectionReason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'buyerType': buyerType,
      'destinationName': destinationName,
      'destinationAddress': destinationAddress,
      'catchItem': catchItem.toJson(),
      'orderedWeightKg': orderedWeightKg,
      'itemPricePerKg': itemPricePerKg,
      'transportFee': transportFee,
      'status': status,
      'orderDate': orderDate.toIso8601String(),
      'rejectionReason': rejectionReason,
    };
  }
}
