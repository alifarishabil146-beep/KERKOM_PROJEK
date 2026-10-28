/// File: lib/models/fish_model.dart
/// Model Master Ikan Khas Padang, Sumatera Barat

class FishModel {
  final String id;
  final String localName;
  final String latinName;
  final String category; // 'Ikan Laut', 'Udang & Moluska'
  final double estimatedMinPrice;
  final double estimatedMaxPrice;
  final String imageUrl;

  FishModel({
    required this.id,
    required this.localName,
    required this.latinName,
    required this.category,
    required this.estimatedMinPrice,
    required this.estimatedMaxPrice,
    required this.imageUrl,
  });

  factory FishModel.fromJson(Map<String, dynamic> json) {
    return FishModel(
      id: json['id'] ?? '',
      localName: json['localName'] ?? '',
      latinName: json['latinName'] ?? '',
      category: json['category'] ?? 'Ikan Laut',
      estimatedMinPrice: (json['estimatedMinPrice'] ?? 0).toDouble(),
      estimatedMaxPrice: (json['estimatedMaxPrice'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'localName': localName,
      'latinName': latinName,
      'category': category,
      'estimatedMinPrice': estimatedMinPrice,
      'estimatedMaxPrice': estimatedMaxPrice,
      'imageUrl': imageUrl,
    };
  }
}
