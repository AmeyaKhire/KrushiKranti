import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'l10n/app_localizations.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_routes.dart';

void main() {
  runApp(const KrushiKrantiApp());
}

class KrushiKrantiApp extends StatelessWidget {
  const KrushiKrantiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Krushi Kranti',
      debugShowCheckedModeBanner: false,
      
      // --- 🎨 DESIGN SYSTEM ---
      theme: ThemeData(
        useMaterial3: true,
        // We set the Scaffold background here, which is perfectly valid.
        scaffoldBackgroundColor: AppColors.background,
        
        // 1. Color Scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.brandGreen, 
          primary: AppColors.primary,      
          secondary: AppColors.brandGreen, 
          surface: AppColors.surface, 
          // ❌ REMOVED: background: AppColors.background (Deprecated)
          // Material 3 uses 'surface' for backgrounds now.
        ),
        
        // 2. Fonts (Noto Sans)
        textTheme: GoogleFonts.notoSansTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: AppColors.textPrimary,
            displayColor: AppColors.textPrimary,
          ),
        ),
        
        // 3. Button Style (Yellow with Black Text)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary, 
            foregroundColor: AppColors.textOnButton, 
            elevation: 0, 
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), 
            ),
            textStyle: const TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // 4. Input Fields
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF5F5F5), 
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none, 
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.brandGreen, width: 2),
          ),
          hintStyle: const TextStyle(color: AppColors.textSecondary),
        ),
      ),

      // --- LOCALIZATION ---
      supportedLocales: const [
        Locale('en'), 
        Locale('hi'), 
        Locale('mr'), 
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // --- 🚀 NAVIGATION SETUP ---
      initialRoute: AppRoutes.splash, 
      routes: AppRoutes.routes,
    );
  }
}