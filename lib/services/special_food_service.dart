import 'dart:convert';
import 'package:http/http.dart' as http;

class SpecialFoodService {
  // ✅ Ensure this IP matches your actual backend server IP
  static const String _baseUrl = "http://10.13.76.23:5000/api/special-food";

  static Future<List<dynamic>> fetchMenu(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/menu'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['menu'] ?? [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> placeOrder(String token, Map data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/order'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode(data),
    );
    return json.decode(response.body);
  }
}