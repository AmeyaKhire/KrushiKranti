import 'package:flutter/material.dart';
import 'package:krushikranti_farmer/core/constants/app_colors.dart';
import 'package:krushikranti_farmer/core/constants/app_routes.dart';
import 'package:krushikranti_farmer/core/services/storage_service.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String selectedLang = "en"; // default

  // Translation Map
  final Map<String, Map<String, String>> translations = {
    "en": {
      "title": "Choose Your Preferred Language",
      "subtitle": "Please Select Your Language",
      "btn": "Save & Continue",
    },
    "hi": {
      "title": "अपनी पसंदीदा भाषा चुनें",
      "subtitle": "कृपया अपनी भाषा चुनें",
      "btn": "सेव करें और आगे बढ़ें",
    },
    "mr": {
      "title": "आपली आवडती भाषा निवडा",
      "subtitle": "कृपया आपली भाषा निवडा",
      "btn": "जतन करा आणि पुढे चला",
    }
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),

                // App Logo
                Center(
                  child: Image.asset(
                    "assets/images/logo/krushi_logo.png",
                    height: 240,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 30),

                // Title
                Text(
                  translations[selectedLang]!["title"]!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 6),

                // Subtitle
                Text(
                  translations[selectedLang]!["subtitle"]!,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 25),

                // Language Options
                _langTile("mr", "मराठी"),
                _langTile("hi", "हिंदी"),
                _langTile("en", "English"),

                const SizedBox(height: 40),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await StorageService.saveLanguage(selectedLang);

                      if (!context.mounted) return;

                      Navigator.of(context)
                          .pushReplacementNamed(AppRoutes.login);
                    },
                    child: Text(translations[selectedLang]!["btn"]!),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Modern Radio Button
  Widget _langTile(String code, String title) {
    return RadioMenuButton<String>(
      value: code,
      groupValue: selectedLang,
      onChanged: (value) {
        setState(() {
          selectedLang = value!;
        });
      },
      child: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
