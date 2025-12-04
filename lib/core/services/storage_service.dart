import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _languageKey = 'app_language';
  
  // ✅ SPLIT KEYS
  static const String _emailKey = 'user_email';
  static const String _phoneKey = 'user_phone';
  static const String _firstNameKey = 'user_first_name';
  static const String _lastNameKey = 'user_last_name';
  static const String _profilePicKey = 'user_profile_pic';

  // --- 1. AUTH DATA (From Signup) ---
  static Future<void> saveAuthDetails({required String email, required String phone}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
    await prefs.setString(_phoneKey, phone);
  }

  // --- 2. PERSONAL DATA (From Onboarding) ---
  static Future<void> savePersonalDetails({
    required String firstName, 
    required String lastName,
    String? profilePicPath
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_firstNameKey, firstName);
    await prefs.setString(_lastNameKey, lastName);
    if (profilePicPath != null) {
      await prefs.setString(_profilePicKey, profilePicPath);
    }
  }

  // --- 3. GET ALL DATA (For Profile) ---
  static Future<Map<String, String>> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "firstName": prefs.getString(_firstNameKey) ?? "Guest",
      "lastName": prefs.getString(_lastNameKey) ?? "Farmer",
      "email": prefs.getString(_emailKey) ?? "No Email",
      "phone": prefs.getString(_phoneKey) ?? "",
      "pic": prefs.getString(_profilePicKey) ?? "",
    };
  }

  // ... (Keep saveToken, getToken, saveLanguage, clearSession as they were) ...
    // --- AUTH TOKEN ---
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Wipes everything
  }

  static Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  static Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey);
  }
}