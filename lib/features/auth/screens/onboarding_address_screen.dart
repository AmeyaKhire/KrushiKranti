import 'package:flutter/material.dart';
import 'package:krushikranti_farmer/core/constants/app_colors.dart';
import 'package:krushikranti_farmer/core/constants/app_routes.dart';
import 'package:krushikranti_farmer/core/services/storage_service.dart';

class OnboardingAddressScreen extends StatefulWidget {
  const OnboardingAddressScreen({super.key});

  @override
  State<OnboardingAddressScreen> createState() =>
      _OnboardingAddressScreenState();
}

class _OnboardingAddressScreenState extends State<OnboardingAddressScreen> {
  String appLang = "en";

  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController talukaController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController stateController = TextEditingController();

  String? selectedVillage;

  final List<String> villageList = [
    "Pune",
    "Lohegaon",
    "Wakad",
    "Kolhapur",
    "Baner",
  ];

  final Map<String, Map<String, String>> t = {
    "en": {
      "title": "Select Your Location",
      "subtitle":
          "Switch on your location to stay in tune with what's happening in your area",
      "pincode": "Pincode",
      "village": "Village",
      "taluka": "Taluka",
      "district": "District",
      "state": "State",
      "done": "Done",
    },
    "hi": {
      "title": "अपना स्थान चुनें",
      "subtitle":
          "अपने क्षेत्र में क्या हो रहा है, इसके लिए अपना लोकेशन ऑन रखें",
      "pincode": "पिनकोड",
      "village": "गांव",
      "taluka": "तहसील",
      "district": "ज़िला",
      "state": "राज्य",
      "done": "हो गया",
    },
    "mr": {
      "title": "आपले स्थान निवडा",
      "subtitle":
          "आपल्या परिसरात काय चालले आहे हे समजण्यासाठी लोकेशन ऑन ठेवा",
      "pincode": "पिनकोड",
      "village": "गाव",
      "taluka": "तालुका",
      "district": "जिल्हा",
      "state": "राज्य",
      "done": "पूर्ण",
    }
  };

  @override
  void initState() {
    super.initState();
    loadLanguage();
  }

  Future<void> loadLanguage() async {
    String? lang = await StorageService.getLanguage();
    setState(() => appLang = lang ?? "en");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 10),

              // Title
              Center(
                child: Text(
                  t[appLang]!["title"]!,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              Center(
                child: Text(
                  t[appLang]!["subtitle"]!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: Image.asset(
                  "assets/images/auth/location.png",
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20),

              _label(t[appLang]!["pincode"]!),
              _textField(pincodeController, t[appLang]!["pincode"]!),

              const SizedBox(height: 16),

              _label(t[appLang]!["village"]!),
              _villageDropdown(),

              const SizedBox(height: 16),

              _label(t[appLang]!["taluka"]!),
              _textField(talukaController, t[appLang]!["taluka"]!),

              const SizedBox(height: 16),

              _label(t[appLang]!["district"]!),
              _textField(districtController, t[appLang]!["district"]!),

              const SizedBox(height: 16),

              _label(t[appLang]!["state"]!),
              _textField(stateController, t[appLang]!["state"]!),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.dashboard);
                  },
                  child: Text(
                    t[appLang]!["done"]!,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField(TextEditingController controller, String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
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

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary),
      ),
    );
  }

  Widget _villageDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(t[appLang]!["village"]!),
          value: selectedVillage,
          isExpanded: true,
          items: villageList.map((v) {
            return DropdownMenuItem(
              value: v,
              child: Text(v),
            );
          }).toList(),
          onChanged: (v) {
            setState(() => selectedVillage = v);
          },
        ),
      ),
    );
  }
}
