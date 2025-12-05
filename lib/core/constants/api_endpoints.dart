class ApiEndpoints {
  // ⚠️ IMPORTANT: If testing on Android Emulator, use '10.0.2.2' instead of 'localhost'
  // If testing on Real Device, use the Backend Dev's IP: 'http://192.168.1.X:8080'
  static const String baseUrl = "http://192.168.1.5:8080/api/v1"; // Replace with actual IP

  static const String login = "$baseUrl/auth/login";
  static const String verifyOtp = "$baseUrl/auth/verify-otp";
  // Add other endpoints here
}