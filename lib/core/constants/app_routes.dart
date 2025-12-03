import 'package:flutter/material.dart';

// --- PARTNER'S SCREENS (Auth) ---
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/language_selection_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart'; // Ensure Signup is here
import '../../features/auth/screens/otp_screen.dart';
import '../../features/auth/screens/onboarding_personal_screen.dart';
import '../../features/auth/screens/onboarding_address_screen.dart';

// --- YOUR SCREENS (Dashboard) ---
import '../../features/dashboard/screens/home_screen.dart';
import '../../features/dashboard/screens/profile_screen.dart'; // ✅ This import is now used below
import '../../features/crop_management/screens/crop_list_screen.dart';
import '../../features/crop_management/screens/add_crop_screen.dart';
import '../../features/funds/screens/request_funds_screen.dart';

class AppRoutes {
  // --- Route Names ---
  static const String splash = '/';
  static const String languageSelection = '/language';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String otp = '/otp';
  static const String onboardingPersonal = '/onboarding_personal';
  static const String onboardingAddress = '/onboarding_address';
  static const String bankVerification = '/bank_verification';

  static const String dashboard = '/dashboard';
  static const String profile = '/profile'; // ✅ ADDED PROFILE ROUTE NAME
  static const String cropList = '/crop_list';
  static const String addCrop = '/add_crop';
  static const String requestFunds = '/request_funds';

  // --- Route Map ---
  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    languageSelection: (context) => const LanguageSelectionScreen(),
    login: (context) => const LoginScreen(),
    signup: (context) => const SignUpScreen(),
    otp: (context) => const OtpScreen(),
    onboardingPersonal: (context) => const OnboardingPersonalScreen(),
    onboardingAddress: (context) => const OnboardingAddressScreen(),

    dashboard: (context) => const HomeScreen(),
    profile: (context) => const ProfileScreen(), // ✅ ADDED PROFILE WIDGET
    cropList: (context) => const CropListScreen(),
    addCrop: (context) => const AddCropScreen(),
    requestFunds: (context) => const RequestFundsScreen(),
  };
}