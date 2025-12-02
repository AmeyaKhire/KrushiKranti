import 'package:flutter/material.dart';

// ✅ Import existing screens
import '../../features/auth/screens/login_screen.dart';
import '../../features/dashboard/screens/home_screen.dart';

// ✅ NEW IMPORTS: Crop Management & Funds Screens
import '../../features/crop_management/screens/crop_list_screen.dart';
import '../../features/crop_management/screens/add_crop_screen.dart';
import '../../features/funds/screens/request_funds_screen.dart';

class AppRoutes {
  // ===========================================================================
  // 1. ROUTE NAMES (Constants)
  // ===========================================================================
  
  static const String splash = '/';
  static const String languageSelection = '/language';
  static const String login = '/login';
  static const String otp = '/otp';
  
  // Onboarding Flow
  static const String onboardingPersonal = '/onboarding_personal';
  static const String onboardingAddress = '/onboarding_address';
  static const String bankVerification = '/bank_verification';
  
  // Dashboard
  static const String dashboard = '/dashboard';

  // ✅ MISSING ROUTES (Added these back)
  static const String cropList = '/crop_list';
  static const String addCrop = '/add_crop';
  static const String requestFunds = '/request_funds';

  // ===========================================================================
  // 2. ROUTE MAP
  // ===========================================================================
  static Map<String, WidgetBuilder> get routes => {
    // --- Entry Point ---
    splash: (context) => const LoginScreen(),
    
    // --- Partner's Routes (Auth) ---
    login: (context) => const LoginScreen(),
    
    // --- Your Routes (Dashboard) ---
    dashboard: (context) => const HomeScreen(),
    
    // ✅ FEATURE ROUTES (This fixes the errors)
    cropList: (context) => const CropListScreen(),
    addCrop: (context) => const AddCropScreen(),
    requestFunds: (context) => const RequestFundsScreen(),
  };
}