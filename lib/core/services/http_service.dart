import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  static const String baseUrl = "https://api.krushikranti.com"; 

  // --- GET REQUEST ---
  static Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    
    // TODO: Connect StorageService here on Monday
    // String? token = await StorageService.getToken(); 
    
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          // TODO: Uncomment on Monday
          // if (token != null) "Authorization": "Bearer $token",
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
    
    // TODO: Connect StorageService here on Monday
    // String? token = await StorageService.getToken(); 

    try {
      final response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json",
          // TODO: Uncomment on Monday
          // if (token != null) "Authorization": "Bearer $token",
        },
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}