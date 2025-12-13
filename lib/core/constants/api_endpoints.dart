class ApiEndpoints {
  // ⚠️ IMPORTANT: 
  // - For Windows/Mac/Linux: use 'http://localhost:4004'
  // - For Android Emulator: use 'http://10.0.2.2:4004'
  // - For Real Device: use 'http://YOUR_LOCAL_IP:4004' (e.g., 'http://192.168.1.X:4004')
  static const String baseUrl = "http://localhost:4004";

  // Auth Endpoints
  static const String login = "$baseUrl/auth/login";
  static const String register = "$baseUrl/auth/register";
  static const String verifyOtp = "$baseUrl/auth/verify-otp";
  static const String requestLoginOtp = "$baseUrl/auth/request-login-otp";
  static const String resendOtp = "$baseUrl/auth/resend-otp";
  
  // Farmer Profile Endpoints
  static const String myDetails = "$baseUrl/farmer/profile/my-details";
  static const String addressLookup = "$baseUrl/farmer/profile/address/lookup";
  
  // Farm Endpoints
  static const String farms = "$baseUrl/farmer/profile/farms";
  static String farmById(String farmId) => "$baseUrl/farmer/profile/farms/$farmId";
  static const String farmsCount = "$baseUrl/farmer/profile/farms/count";
  static const String farmsCollateral = "$baseUrl/farmer/profile/farms/collateral";
  
  // Crop Endpoints
  static const String cropTypes = "$baseUrl/farmer/profile/crop-types";
  static const String cropNames = "$baseUrl/farmer/profile/crop-names";
  static const String crops = "$baseUrl/farmer/profile/crops";
  static String cropById(String cropId) => "$baseUrl/farmer/profile/crops/$cropId";
  static String cropsByFarm(String farmId) => "$baseUrl/farmer/profile/crops/farm/$farmId";
  
  // Add other endpoints here as needed
}