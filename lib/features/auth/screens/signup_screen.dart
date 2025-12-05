import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/services/storage_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // ✅ ADDED: Username Controller
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String appLang = "en"; // default

  String? usernameError; // ✅ ADDED: Username Error
  String? emailError;
  String? passwordError;
  String? phoneError;

  // 🌍 UI TRANSLATIONS
  final Map<String, Map<String, String>> translations = {
    "en": {
      "hey": "Hey,",
      "signupNow": "Sign Up Now !",
      "username": "Username",           // ✅ New
      "usernameHint": "Enter username", // ✅ New
      "email": "E-Mail",
      "emailHint": "Enter e-mail address",
      "password": "Password",
      "passwordHint": "Enter password",
      "phone": "Phone Number",
      "phoneHint": "Enter phone number",
      "getOtp": "Get OTP",
    },
    "hi": {
      "hey": "नमस्ते,",
      "signupNow": "अभी साइन अप करें !",
      "username": "उपयोगकर्ता नाम",           // ✅ New
      "usernameHint": "उपयोगकर्ता नाम दर्ज करें", // ✅ New
      "email": "ई-मेल",
      "emailHint": "ई-मेल दर्ज करें",
      "password": "पासवर्ड",
      "passwordHint": "पासवर्ड दर्ज करें",
      "phone": "फोन नंबर",
      "phoneHint": "फोन नंबर दर्ज करें",
      "getOtp": "OTP प्राप्त करें",
    },
    "mr": {
      "hey": "नमस्कार,",
      "signupNow": "आता साइन अप करा !",
      "username": "वापरकर्तानाव",           // ✅ New
      "usernameHint": "वापरकर्तानाव टाका",   // ✅ New
      "email": "ई-मेल",
      "emailHint": "ई-मेल टाका",
      "password": "पासवर्ड",
      "passwordHint": "पासवर्ड टाका",
      "phone": "फोन नंबर",
      "phoneHint": "फोन नंबर टाका",
      "getOtp": "OTP मिळवा",
    }
  };

  // 🌍 ERROR TRANSLATIONS
  final Map<String, Map<String, String>> translationsErr = {
    "en": {
      "usernameErr": "Please enter a username", // ✅ New
      "emailErr": "Enter a valid email address",
      "passErr": "Password must contain 8+ chars, A-Z, a-z, number & special character",
      "phoneErr": "Enter a valid 10-digit phone number",
    },
    "hi": {
      "usernameErr": "कृपया उपयोगकर्ता नाम दर्ज करें", // ✅ New
      "emailErr": "कृपया मान्य ई-मेल दर्ज करें",
      "passErr": "पासवर्ड में 8+ अक्षर, A-Z, a-z, संख्या और विशेष वर्ण शामिल होने चाहिए",
      "phoneErr": "कृपया 10 अंकों का मान्य फ़ोन नंबर दर्ज करें",
    },
    "mr": {
      "usernameErr": "कृपया वापरकर्तानाव प्रविष्ट करा", // ✅ New
      "emailErr": "कृपया वैध ई-मेल पत्ता प्रविष्ट करा",
      "passErr": "पासवर्डमध्ये 8+ अक्षरे, A-Z, a-z, संख्या व विशेष चिन्ह असणे आवश्यक आहे",
      "phoneErr": "कृपया वैध 10 अंकी मोबाईल नंबर टाका",
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

  // VALIDATIONS
  bool validateUsername(String name) {
    return name.trim().length >= 3; // Simple check
  }

  bool validateEmail(String email) {
    final regex = RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$");
    return regex.hasMatch(email);
  }

  bool validatePhone(String phone) {
    final regex = RegExp(r"^[0-9]{10}$");
    return regex.hasMatch(phone);
  }

  bool validatePassword(String password) {
    final regex = RegExp(r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$%\^&\*\-_]).{8,}$");
    return regex.hasMatch(password);
  }

  // ✅ UPDATED: Async function to save data
  Future<void> validateForm() async {
    setState(() {
      usernameError = validateUsername(usernameController.text)
          ? null
          : translationsErr[appLang]!["usernameErr"];

      emailError = validateEmail(emailController.text.trim())
          ? null
          : translationsErr[appLang]!["emailErr"];

      passwordError = validatePassword(passwordController.text.trim())
          ? null
          : translationsErr[appLang]!["passErr"];

      phoneError = validatePhone(phoneController.text.trim())
          ? null
          : translationsErr[appLang]!["phoneErr"];
    });

    if (usernameError == null && 
        emailError == null && 
        passwordError == null && 
        phoneError == null) {
      
      // 1. Save Auth Details (Email/Phone)
      await StorageService.saveAuthDetails(
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
      );

      // 2. Save Username as First Name initially (so Profile isn't empty)
      // We pass empty strings for DOB/Gender as placeholders
      await StorageService.savePersonalDetails(
        firstName: usernameController.text.trim(),
        lastName: "", 
        dob: "", 
        gender: "",
        profilePicPath: null,
      );

      // 3. Save Mock Token
      await StorageService.saveToken("mock_token_123");

      if (!mounted) return;
      
      // 4. Navigate to OTP (Pass 'false' because this is Signup)
      Navigator.pushNamed(context, AppRoutes.otp, arguments: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () => Navigator.pop(context),
                ),

                const SizedBox(height: 10),

                Text(
                  translations[appLang]!["hey"]!,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  translations[appLang]!["signupNow"]!,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.brandGreen,
                  ),
                ),

                const SizedBox(height: 40),

                // --- 1. USERNAME FIELD (ADDED BACK) ---
                _label(translations[appLang]!["username"]!),
                _inputField(
                  controller: usernameController,
                  hint: translations[appLang]!["usernameHint"]!,
                  icon: Icons.person_outline,
                ),
                if (usernameError != null) _errorText(usernameError!),

                const SizedBox(height: 20),

                // --- 2. EMAIL FIELD ---
                _label(translations[appLang]!["email"]!),
                _inputField(
                  controller: emailController,
                  hint: translations[appLang]!["emailHint"]!,
                  icon: Icons.email_outlined,
                ),
                if (emailError != null) _errorText(emailError!),

                const SizedBox(height: 20),

                // --- 3. PASSWORD FIELD ---
                _label(translations[appLang]!["password"]!),
                _inputField(
                  controller: passwordController,
                  hint: translations[appLang]!["passwordHint"]!,
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                if (passwordError != null) _errorText(passwordError!),

                const SizedBox(height: 20),

                // --- 4. PHONE FIELD ---
                _label(translations[appLang]!["phone"]!),
                _inputField(
                  controller: phoneController,
                  hint: translations[appLang]!["phoneHint"]!,
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                if (phoneError != null) _errorText(phoneError!),

                const SizedBox(height: 40),

                // SUBMIT BUTTON
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
                    onPressed: validateForm, // ✅ Calls updated validation
                    child: Text(
                      translations[appLang]!["getOtp"]!,
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
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _errorText(String msg) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 6),
      child: Text(
        msg,
        style: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.brandGreen, width: 1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.brandGreen),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                hintStyle: const TextStyle(color: AppColors.textSecondary),
              ),
              onChanged: (_) {
                setState(() {
                  usernameError = null;
                  emailError = null;
                  passwordError = null;
                  phoneError = null;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}