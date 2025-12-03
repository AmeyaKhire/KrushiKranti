import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:krushikranti_farmer/core/constants/app_colors.dart';
import 'package:krushikranti_farmer/core/constants/app_routes.dart';
import 'package:krushikranti_farmer/core/services/storage_service.dart';

class OnboardingPersonalScreen extends StatefulWidget {
  const OnboardingPersonalScreen({super.key});

  @override
  State<OnboardingPersonalScreen> createState() =>
      _OnboardingPersonalScreenState();
}

class _OnboardingPersonalScreenState extends State<OnboardingPersonalScreen> {
  File? selectedImageFile; // For mobile
  Uint8List? selectedImageBytes; // For web
  final ImagePicker picker = ImagePicker();

  String appLang = "en";

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadLang();
  }

  Future<void> loadLang() async {
    String? lang = await StorageService.getLanguage();
    setState(() => appLang = lang ?? "en");
  }

  // ------------ LANGUAGE TEXT -------------
  final Map<String, Map<String, String>> text = {
    "en": {
      "title": "Onboarding",
      "firstName": "First Name",
      "lastName": "Last Name",
      "firstNameHint": "Enter First Name",
      "lastNameHint": "Enter Last Name",
      "continue": "Save & Continue",
    },
    "hi": {
      "title": "ऑनबोर्डिंग",
      "firstName": "पहला नाम",
      "lastName": "अंतिम नाम",
      "firstNameHint": "पहला नाम दर्ज करें",
      "lastNameHint": "अंतिम नाम दर्ज करें",
      "continue": "सेव करें और आगे बढ़ें",
    },
    "mr": {
      "title": "ऑनबोर्डिंग",
      "firstName": "पहिले नाव",
      "lastName": "आडनाव",
      "firstNameHint": "पहिले नाव टाका",
      "lastNameHint": "आडनाव टाका",
      "continue": "जतन करा आणि पुढे चला",
    }
  };

  // ---------- CAMERA PICKER (WEB + MOBILE) ----------
  Future<void> pickImage() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      if (kIsWeb) {
        final bytes = await file.readAsBytes();
        setState(() {
          selectedImageBytes = bytes;
        });
      } else {
        setState(() {
          selectedImageFile = File(file.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BACK BUTTON
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () => Navigator.pop(context),
                ),

                // TITLE
                Center(
                  child: Text(
                    text[appLang]!["title"]!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ------------ 2-STEP INDICATOR -------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Step 1 (Active)
                    const CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.green,
                      child:
                          Icon(Icons.check, color: Colors.white, size: 16),
                    ),
                    Container(height: 2, width: 40, color: Colors.green),

                    // Step 2 (Inactive)
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.grey.shade300,
                      child:
                          const Icon(Icons.check, color: Colors.white, size: 16),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // -------- PROFILE IMAGE UPLOADER --------
                Center(
                  child: GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.green, width: 2),
                      ),
                      child: ClipOval(
                        child: selectedImageBytes != null
                            ? Image.memory(selectedImageBytes!,
                                fit: BoxFit.cover)
                            : selectedImageFile != null
                                ? Image.file(selectedImageFile!,
                                    fit: BoxFit.cover)
                                : const Icon(Icons.camera_alt,
                                    color: Colors.green, size: 40),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // -------- FIRST NAME --------
                Text(
                  text[appLang]!["firstName"]!,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 5),
                _inputField(
                  controller: firstNameController,
                  hint: text[appLang]!["firstNameHint"]!,
                ),

                const SizedBox(height: 20),

                // -------- LAST NAME --------
                Text(
                  text[appLang]!["lastName"]!,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 5),
                _inputField(
                  controller: lastNameController,
                  hint: text[appLang]!["lastNameHint"]!,
                ),

                const SizedBox(height: 40),

                // -------- CONTINUE BUTTON --------
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, AppRoutes.onboardingAddress);
                    },
                    child: Text(
                      text[appLang]!["continue"]!,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- REUSABLE TEXT FIELD ----------
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
