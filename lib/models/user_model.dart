/// File: lib/models/user_model.dart
/// Model Data Pengguna NETLAYAN (Nelayan, Pembeli, Admin)

class UserModel {
  final String id;
  final String name;
  final String nikOrUsername;
  final String role; // 'fisherman', 'buyer', 'admin'
  final String phone;
  final String location; // Contoh: "Pasir-pasir, Padang", "Muara Padang", "Padang Barat"
  final String? avatarUrl;
  final List<String> certifications; // KKP, Halal, Higiene
  final String? buyerType; // 'supermarket' (Suzuya) vs 'traditional_market' (Pasar Bawah)
  final String? institutionName; // Contoh: "Suzuya Superstore Padang", "Pasar Bawah"
  final double rating;
  final int totalSalesOrPurchases;
  final bool isVerified;

  UserModel({
    required this.id,
    required this.name,
    required this.nikOrUsername,
    required this.role,
    required this.phone,
    required this.location,
    this.avatarUrl,
    this.certifications = const [],
    this.buyerType,
    this.institutionName,
    this.rating = 5.0,
    this.totalSalesOrPurchases = 0,
    this.isVerified = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      nikOrUsername: json['nikOrUsername'] ?? '',
      role: json['role'] ?? 'fisherman',
      phone: json['phone'] ?? '',
      location: json['location'] ?? 'Padang, Sumatera Barat',
      avatarUrl: json['avatarUrl'],
      certifications: List<String>.from(json['certifications'] ?? []),
      buyerType: json['buyerType'],
      institutionName: json['institutionName'],
      rating: (json['rating'] ?? 5.0).toDouble(),
      totalSalesOrPurchases: json['totalSalesOrPurchases'] ?? 0,
      isVerified: json['isVerified'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nikOrUsername': nikOrUsername,
      'role': role,
      'phone': phone,
      'location': location,
      'avatarUrl': avatarUrl,
      'certifications': certifications,
      'buyerType': buyerType,
      'institutionName': institutionName,
      'rating': rating,
      'totalSalesOrPurchases': totalSalesOrPurchases,
      'isVerified': isVerified,
    };
  }
}
