import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'l10n/app_localizations.dart';
import 'core/constants/app_colors.dart';

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
      
      // --- 🎨 DESIGN SYSTEM FROM FIGMA ---
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        
        // 1. Color Scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.brandGreen, // Use Green for system ripples/focus
          primary: AppColors.primary,      // Yellow for Buttons
          secondary: AppColors.brandGreen, // Green for Accents
          surface: AppColors.surface,
          background: AppColors.background,
        ),
        
        // 2. Fonts (Essential for Marathi/Hindi support)
        // Noto Sans is the best choice for Indian languages.
        textTheme: GoogleFonts.notoSansTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: AppColors.textPrimary,
            displayColor: AppColors.textPrimary,
          ),
        ),
        
        // 3. Button Style (Matches your "Get OTP" button)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary, // Yellow Background
            foregroundColor: AppColors.textOnButton, // Black Text
            elevation: 0, // Flat design
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners like Figma
            ),
            textStyle: const TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // 4. Input Fields (Text Boxes)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF5F5F5), // Light grey fill like Figma
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none, // No border by default (clean look)
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

      // --- HOME ---
      home: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Krushi Kranti Design Ready", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              // This button will now be Yellow with Black text automatically!
              ElevatedButton(
                onPressed: null, 
                child: Text("Save & Continue"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}