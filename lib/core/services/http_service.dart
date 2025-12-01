import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart'; // ✅ Import the new service

class HttpService {
  // Base URL (Update when backend is ready)
  static const String baseUrl = "https://api.krushikranti.com"; 

  // --- GET REQUEST ---
  static Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    
    // ✅ ACTION: Fetch Token from Storage
    String? token = await StorageService.getToken(); 
    
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          // ✅ ACTION: Attach Token if it exists
          if (token != null) "Authorization": "Bearer $token",
        },
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  // --- POST REQUEST ---
  static Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    
    // ✅ ACTION: Fetch Token from Storage
    String? token = await StorageService.getToken(); 

    try {
      final response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json",
          // ✅ ACTION: Attach Token if it exists
          if (token != null) "Authorization": "Bearer $token",
        },
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  // --- HELPER: Handle Status Codes ---
  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      // Optional: Auto-logout if token expires
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error: ${response.statusCode} - ${response.body}');
    }
  }
}