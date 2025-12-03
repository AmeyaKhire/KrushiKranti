import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krushikranti_farmer/core/constants/app_colors.dart';
import 'package:krushikranti_farmer/core/constants/app_routes.dart';
import 'package:krushikranti_farmer/core/services/storage_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  String countryCode = "+91";
  String appLang = "en";

  String? phoneErrorText;

  final Map<String, Map<String, String>> translations = {
    "en": {
      "tagline": "Reconnect With Goodness",
      "start": "Let’s get you started",
      "phoneHint": "your phone number",
      "otpInfo": "OTP will be sent on this number",
      "forgot": "Forgot Password?",
      "otpBtn": "Get OTP",
      "terms":
          "By continuing you agree to our Terms & Conditions and Privacy & Legal Policy",
      "signUp": "Sign Up",
      "phoneError": "Please enter a valid 10-digit phone number"
    },
    "hi": {
      "tagline": "भलाई से फिर जुड़ें",
      "start": "चलें शुरू करते हैं",
      "phoneHint": "अपना मोबाइल नंबर",
      "otpInfo": "OTP इस नंबर पर भेजा जाएगा",
      "forgot": "पासवर्ड भूल गए?",
      "otpBtn": "OTP प्राप्त करें",
      "terms": "आगे बढ़ते हुए आप हमारी शर्तों और गोपनीयता नीति से सहमत हैं",
      "signUp": "साइन अप करें",
      "phoneError": "कृपया 10 अंकों का मान्य मोबाइल नंबर दर्ज करें"
    },
    "mr": {
      "tagline": "चांगुलपणाशी पुन्हा जोडले जा",
      "start": "चला सुरुवात करूया",
      "phoneHint": "आपला मोबाईल नंबर",
      "otpInfo": "OTP या नंबरवर पाठविला जाईल",
      "forgot": "पासवर्ड विसरलात?",
      "otpBtn": "OTP मिळवा",
      "terms": "पुढे जाताना आपण आमच्या अटी आणि गोपनीयता धोरणास सहमती देता",
      "signUp": "साइन अप",
      "phoneError": "कृपया वैध 10 अंकी मोबाईल नंबर प्रविष्ट करा"
    }
  };

  @override
  void initState() {
    super.initState();
    loadLanguage();
  }

  Future<void> loadLanguage() async {
    String? lang = await StorageService.getLanguage();
    setState(() {
      appLang = lang ?? "en";
    });
  }

  bool validatePhoneNumber(String phone) {
    final regex = RegExp(r"^[0-9]{10}$");
    return regex.hasMatch(phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Positioned(
              top: 0,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.languageSelection,
                    (route) => false,
                  );
                },
              ),
            ),
            // 🌿 UPDATED SECTION: IMAGE + TAGLINE IN ONE WHITE CONTAINER
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.only(top: 14),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 14),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "assets/images/auth/farmer_logo.jpg",
                        height: 240,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    translations[appLang]!["tagline"]!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.brandGreen,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Remaining content scrollable
            Expanded(
              child: Stack(
                children: [
                  // MAIN CONTENT
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 24),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translations[appLang]!["start"]!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // PHONE FIELD
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: phoneErrorText == null
                                    ? AppColors.border
                                    : Colors.red,
                              ),
                            ),
                            child: Row(
                              children: [
                                DropdownButton<String>(
                                  value: countryCode,
                                  underline: const SizedBox(),
                                  items: const [
                                    DropdownMenuItem(
                                        value: "+91", child: Text("+91")),
                                    DropdownMenuItem(
                                        value: "+92", child: Text("+92")),
                                    DropdownMenuItem(
                                        value: "+1", child: Text("+1")),
                                  ],
                                  onChanged: (value) {
                                    setState(() => countryCode = value!);
                                  },
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: phoneController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 10,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: InputDecoration(
                                      counterText: "",
                                      hintText:
                                          translations[appLang]!["phoneHint"]!,
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      if (value.length == 10) {
                                        setState(() => phoneErrorText = null);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (phoneErrorText != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 10),
                              child: Text(
                                phoneErrorText!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),

                          const SizedBox(height: 8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                translations[appLang]!["otpInfo"]!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                translations[appLang]!["forgot"]!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.brandGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // OTP BUTTON
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: () async {
                                final phone = phoneController.text.trim();

                                if (!validatePhoneNumber(phone)) {
                                  setState(() {
                                    phoneErrorText =
                                        translations[appLang]!["phoneError"];
                                  });
                                  return;
                                }

                                await StorageService.saveLanguage(appLang);

                                if (!mounted) return;

                                Navigator.pushNamed(context, AppRoutes.otp);
                              },
                              child: Text(
                                translations[appLang]!["otpBtn"]!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            translations[appLang]!["terms"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),

                          const SizedBox(height: 15),

                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "or ",
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, AppRoutes.signup);
                                  },
                                  child: Text(
                                    translations[appLang]!["signUp"]!,
                                    style: const TextStyle(
                                      color: AppColors.brandGreen,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
