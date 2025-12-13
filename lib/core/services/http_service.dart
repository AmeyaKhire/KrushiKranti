import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart'; // ✅ Import the new service

class HttpService {
  // Base URL - API Gateway
  // ⚠️ IMPORTANT: 
  // - For Windows/Mac/Linux: use 'http://localhost:4004'
  // - For Android Emulator: use 'http://10.0.2.2:4004'
  // - For Real Device: use 'http://YOUR_LOCAL_IP:4004' (e.g., 'http://192.168.1.X:4004')
  static const String baseUrl = "http://localhost:4004"; 

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

  // --- PUT REQUEST ---
  static Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    
    // ✅ ACTION: Fetch Token from Storage
    String? token = await StorageService.getToken();

    try {
      final response = await http.put(
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
    } else {
      // Try to extract error message from ApiResponse format
      try {
        final errorBody = jsonDecode(response.body);
        if (errorBody is Map && errorBody.containsKey('message')) {
          throw Exception(errorBody['message'] ?? 'An error occurred');
        }
      } catch (_) {
        // If parsing fails, use the raw response
      }
      
      if (response.statusCode == 401) {
        throw Exception('Unauthorized - Please login again');
      } else {
        throw Exception('Error: ${response.statusCode} - ${response.body}');
      }
    }
  }
}