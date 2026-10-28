/// File: lib/core/constants/api_endpoints.dart
/// Mock API Endpoints untuk NETLAYAN Mobile App

class ApiEndpoints {
  static const String baseUrl = 'https://api.netlayan.padang.go.id/v1';

  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String profile = '$baseUrl/auth/profile';

  static const String fishermanDashboard = '$baseUrl/fisherman/dashboard';
  static const String catches = '$baseUrl/catches';
  static const String fishMaster = '$baseUrl/fish-master';
  static const String orders = '$baseUrl/orders';
  static const String adminVerify = '$baseUrl/admin/verify-fisherman';
}
