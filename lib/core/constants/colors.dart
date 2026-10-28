/// File: lib/core/constants/colors.dart
/// Palette Warna Resmi Aplikasi NETLAYAN
/// Mengusung tema modern, clean, premium, dan elegan.

import 'package:flutter/material.dart';

class AppColors {
  // Deep Navy - Warna Utama Brand NETLAYAN
  static const Color primary = Color(0xFF0F2C4D);
  static const Color primaryLight = Color(0xFF1E3A5F);
  
  // Royal Blue - Warna Sekunder & Highlight
  static const Color secondary = Color(0xFF1E40AF);
  static const Color secondaryLight = Color(0xFF3B82F6);

  // Gold / Emas - Aksesories & Sentinel Premium
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color accentGoldLight = Color(0xFFF3E5AB);

  // Background & Surface
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color cardBackground = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);

  // Status & Grade Colors
  static const Color gradeA = Color(0xFF10B981); // Emerald Green (<6 jam)
  static const Color gradeB = Color(0xFFF59E0B); // Amber Yellow (<12 jam)
  static const Color gradeC = Color(0xFFEF4444); // Red (<24 jam)

  static const Color statusPending = Color(0xFFF59E0B);
  static const Color statusConfirmed = Color(0xFF3B82F6);
  static const Color statusShipped = Color(0xFF8B5CF6);
  static const Color statusDelivered = Color(0xFF10B981);
  static const Color statusRejected = Color(0xFFEF4444);

  // Divider & Border
  static const Color border = Color(0xFFE2E8F0);
}
