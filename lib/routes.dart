/// File: lib/routes.dart
/// Deklarasi Named Routes Aplikasi NETLAYAN

import 'package:flutter/material.dart';
import 'features/auth/login_page.dart';
import 'features/auth/register_page.dart';
import 'features/fisherman/dashboard/dashboard_page.dart';
import 'features/fisherman/catch/upload_catch_page.dart';
import 'features/fisherman/catch/catch_list_page.dart';
import 'features/fisherman/catch/catch_detail_page.dart';
import 'features/fisherman/orders/my_orders_page.dart';
import 'features/fisherman/profile/profile_page.dart';
import 'features/buyer/dashboard/buyer_dashboard_page.dart';
import 'features/buyer/browse/browse_fish_page.dart';
import 'features/buyer/browse/fish_detail_page.dart';
import 'features/buyer/orders/create_order_page.dart';
import 'features/buyer/orders/my_orders_page.dart';
import 'features/buyer/profile/buyer_profile_page.dart';
import 'features/admin/admin_dashboard_page.dart';
import 'features/admin/verify_fisherman_page.dart';
import 'features/admin/manage_fish_master_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';

  static const String fishermanDashboard = '/fisherman/dashboard';
  static const String uploadCatch = '/fisherman/catch/upload';
  static const String catchList = '/fisherman/catch/list';
  static const String catchDetail = '/fisherman/catch/detail';
  static const String fishermanOrders = '/fisherman/orders';
  static const String fishermanProfile = '/fisherman/profile';

  static const String buyerDashboard = '/buyer/dashboard';
  static const String browseFish = '/buyer/browse';
  static const String fishDetail = '/buyer/fish/detail';
  static const String createOrder = '/buyer/orders/create';
  static const String buyerOrders = '/buyer/orders/my';
  static const String buyerProfile = '/buyer/profile';

  static const String adminDashboard = '/admin/dashboard';
  static const String verifyFisherman = '/admin/verify';
  static const String manageFishMaster = '/admin/master-fish';

  static Map<String, WidgetBuilder> get routes => {
        login: (context) => const LoginPage(),
        register: (context) => const RegisterPage(),
        fishermanDashboard: (context) => const FishermanDashboardPage(),
        uploadCatch: (context) => const UploadCatchPage(),
        catchList: (context) => const CatchListPage(),
        catchDetail: (context) => const CatchDetailPage(),
        fishermanOrders: (context) => const FishermanOrdersPage(),
        fishermanProfile: (context) => const FishermanProfilePage(),
        buyerDashboard: (context) => const BuyerDashboardPage(),
        browseFish: (context) => const BrowseFishPage(),
        fishDetail: (context) => const FishDetailPage(),
        createOrder: (context) => const CreateOrderPage(),
        buyerOrders: (context) => const BuyerOrdersPage(),
        buyerProfile: (context) => const BuyerProfilePage(),
        adminDashboard: (context) => const AdminDashboardPage(),
        verifyFisherman: (context) => const VerifyFishermanPage(),
        manageFishMaster: (context) => const ManageFishMasterPage(),
      };
}
