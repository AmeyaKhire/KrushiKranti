import 'package:flutter/material.dart';

// ✅ Import the screens you created so we can link them
import '../../features/auth/screens/login_screen.dart';
import '../../features/dashboard/screens/home_screen.dart';

class AppRoutes {
  // ===========================================================================
  // 1. ROUTE NAMES (Constants)
  // Use these names in your code. Example: Navigator.pushNamed(context, AppRoutes.otp);
  // ===========================================================================
  
  static const String splash = '/';
  static const String languageSelection = '/language';
  static const String login = '/login';
  static const String otp = '/otp';
  
  // Onboarding Flow
  static const String onboardingPersonal = '/onboarding_personal'; // Name, etc.
  static const String onboardingAddress = '/onboarding_address';   // Village, Taluka
  static const String bankVerification = '/bank_verification';     // Aadhaar/Bank
  
  // Dashboard (Your Main App)
  static const String dashboard = '/dashboard';

  // ===========================================================================
  // 2. ROUTE MAP (Connections)
  // This tells the app which Screen to show for which Route Name.
  // ===========================================================================
  static Map<String, WidgetBuilder> get routes => {
    // --- Entry Point ---
    // Currently pointing to Login. Your partner will change this to SplashScreen later.
    splash: (context) => const LoginScreen(),
    
    // --- Partner's Routes (Auth) ---
    login: (context) => const LoginScreen(),
    
    // TODO: Partner will uncomment and create these screens as he builds them:
    // languageSelection: (context) => const LanguageSelectionScreen(),
    // otp: (context) => const OtpScreen(),
    // onboardingPersonal: (context) => const PersonalDetailsScreen(),
    // onboardingAddress: (context) => const AddressDetailsScreen(),
    // bankVerification: (context) => const BankVerificationScreen(),

    // --- Your Routes (Dashboard) ---
    dashboard: (context) => const HomeScreen(),
  };
}