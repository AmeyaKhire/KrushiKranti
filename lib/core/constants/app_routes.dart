import 'package:flutter/material.dart';

// Screens
import 'package:krushikranti_farmer/features/auth/screens/splash_screen.dart';
import 'package:krushikranti_farmer/features/auth/screens/language_selection_screen.dart';
//import 'package:krushikranti_farmer/features/auth/screens/login_screen.dart';
import 'package:krushikranti_farmer/features/dashboard/screens/home_screen.dart';

class AppRoutes {
  // ================================
  // ROUTE NAMES
  // ================================
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

  // ================================
  // ROUTE MAP
  // ================================
  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        languageSelection: (context) => const LanguageSelectionScreen(),
       // login: (context) => const LoginScreen(),

        // Future onboarding screens will go here...
        // otp: (context) => const OtpScreen(),
        // onboardingPersonal: (context) => const PersonalDetailsScreen(),
        // onboardingAddress: (context) => const AddressDetailsScreen(),
        // bankVerification: (context) => const BankVerificationScreen(),

        dashboard: (context) => const HomeScreen(),
      };
}
