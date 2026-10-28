/// File: lib/models/catch_model.dart
/// Model Data Hasil Tangkapan Nelayan NETLAYAN

class CatchModel {
  final String id;
  final String fishermanId;
  final String fishermanName;
  final String fishermanLocation;
  final String fishType;
  final String latinName;
  final double weightKg;
  final double pricePerKg;
  final String photoUrl;
  final String landingLocation; // Pasir-pasir, Muara, Air Manis, Teluk Bayur
  final DateTime catchTime;
  final String method; // Pancing, Jaring, Pukat
  final String size; // Kecil, Sedang, Besar
  final bool isAvailable;

  CatchModel({
    required this.id,
    required this.fishermanId,
    required this.fishermanName,
    required this.fishermanLocation,
    required this.fishType,
    required this.latinName,
    required this.weightKg,
    required this.pricePerKg,
    required this.photoUrl,
    required this.landingLocation,
    required this.catchTime,
    required this.method,
    required this.size,
    this.isAvailable = true,
  });

  /// Auto-calculate Grade berdasarkan rentang waktu penangkapan:
  /// Grade A: < 6 jam (Langsung dari laut segar)
  /// Grade B: < 12 jam (Sangat baik)
  /// Grade C: < 24 jam (Hanya untuk Pasar Tradisional)
  String get grade {
    final differenceInHours = DateTime.now().difference(catchTime).inHours;
    if (differenceInHours < 6) {
      return 'A';
    } else if (differenceInHours < 12) {
      return 'B';
    } else {
      return 'C';
    }
  }

  /// Label Kriteria Kualifikasi
  String get gradeDescription {
    switch (grade) {
      case 'A':
        return 'Grade A (Segar Laut <6 Jam) - Supermarket & Pasar';
      case 'B':
        return 'Grade B (Segar Laut <12 Jam) - Supermarket & Pasar';
      case 'C':
      default:
        return 'Grade C (<24 Jam) - Hanya Pasar Tradisional';
    }
  }

  double get totalPrice => weightKg * pricePerKg;

  factory CatchModel.fromJson(Map<String, dynamic> json) {
    return CatchModel(
      id: json['id'] ?? '',
      fishermanId: json['fishermanId'] ?? '',
      fishermanName: json['fishermanName'] ?? '',
      fishermanLocation: json['fishermanLocation'] ?? 'Padang',
      fishType: json['fishType'] ?? '',
      latinName: json['latinName'] ?? '',
      weightKg: (json['weightKg'] ?? 0).toDouble(),
      pricePerKg: (json['pricePerKg'] ?? 0).toDouble(),
      photoUrl: json['photoUrl'] ?? '',
      landingLocation: json['landingLocation'] ?? 'Muara Padang',
      catchTime: DateTime.parse(json['catchTime'] ?? DateTime.now().toIso8601String()),
      method: json['method'] ?? 'Pancing',
      size: json['size'] ?? 'Sedang',
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fishermanId': fishermanId,
      'fishermanName': fishermanName,
      'fishermanLocation': fishermanLocation,
      'fishType': fishType,
      'latinName': latinName,
      'weightKg': weightKg,
      'pricePerKg': pricePerKg,
      'photoUrl': photoUrl,
      'landingLocation': landingLocation,
      'catchTime': catchTime.toIso8601String(),
      'method': method,
      'size': size,
      'isAvailable': isAvailable,
      'grade': grade,
    };
  }
}
