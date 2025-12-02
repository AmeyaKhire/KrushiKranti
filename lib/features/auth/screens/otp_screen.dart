import 'dart:async';
import 'package:flutter/material.dart';
import 'package:krushikranti_farmer/core/constants/app_colors.dart';
import 'package:krushikranti_farmer/core/constants/app_routes.dart';
import 'package:krushikranti_farmer/core/services/storage_service.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> otpControllers =
      List.generate(4, (_) => TextEditingController());

  int timerSeconds = 30;
  Timer? countdownTimer;

  String appLang = "en"; // default

  final Map<String, String> titleText = {
    "en": "Please Input OTP",
    "hi": "कृपया OTP दर्ज करें",
    "mr": "कृपया OTP प्रविष्ट करा",
  };

  final Map<String, String> enterOtpText = {
    "en": "Enter OTP",
    "hi": "OTP दर्ज करें",
    "mr": "OTP प्रविष्ट करा",
  };

  final Map<String, String> resendText = {
    "en": "Resend OTP",
    "hi": "OTP पुनः भेजें",
    "mr": "OTP पुन्हा पाठवा",
  };

  final Map<String, String> submitButtonText = {
    "en": "Submit OTP",
    "hi": "OTP सबमिट करें",
    "mr": "OTP सबमिट करा",
  };

  @override
  void initState() {
    super.initState();
    loadLanguage();
    startTimer();
  }

  Future<void> loadLanguage() async {
    String? lang = await StorageService.getLanguage();
    setState(() => appLang = lang ?? "en");
  }

  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (timerSeconds > 0) {
        setState(() => timerSeconds--);
      }
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    for (var c in otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // 🔙 FIXED BACK BUTTON
            Positioned(
              top: 10,
              left: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(); // ALWAYS WORKS
                },
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ),

            // MAIN CONTENT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 70),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xFF6EEB6E),
                        shape: BoxShape.circle,
                      ),
                      child:
                          const Icon(Icons.lock, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      titleText[appLang]!,
                      style: const TextStyle(
                        color: AppColors.brandGreen,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      enterOtpText[appLang]!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (i) => _otpBox(i)),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      timerSeconds > 0
                          ? "${resendText[appLang]}: 00:$timerSeconds"
                          : resendText[appLang]!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, AppRoutes.onboardingPersonal);
                        },
                        child: Text(
                          submitButtonText[appLang]!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otpBox(int index) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: otpControllers[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: const InputDecoration(
          counterText: "",
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
