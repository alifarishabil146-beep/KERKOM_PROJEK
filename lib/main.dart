/// File: lib/main.dart
/// Entry Point Utama Aplikasi NETLAYAN

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/services/token_storage.dart';
import 'core/theme/app_theme.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  final user = await TokenStorage.getUser();
  runApp(NetLayanApp(initialUserRole: user?.role));
}

class NetLayanApp extends StatelessWidget {
  final String? initialUserRole;
  const NetLayanApp({super.key, this.initialUserRole});

  @override
  Widget build(BuildContext context) {
    String initialRoute = AppRoutes.login;
    if (initialUserRole != null) {
      if (initialUserRole == 'fisherman') {
        initialRoute = AppRoutes.fishermanDashboard;
      } else if (initialUserRole == 'buyer') {
        initialRoute = AppRoutes.buyerDashboard;
      } else if (initialUserRole == 'admin') {
        initialRoute = AppRoutes.adminDashboard;
      }
    }

    return MaterialApp(
      title: 'NETLAYAN Padang',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: initialRoute,
      routes: AppRoutes.routes,
    );
  }
}
