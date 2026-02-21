import 'package:chefhospitalityservices/api/api_endpoint.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class ApiService {
  static const String _baseUrl = ApiEndpoints.tokenBaseUrl;
  final box = GetStorage();

  String? get token => box.read('token');

  Future<Map<String, dynamic>> submitMealSkip(String date, String mealType) async {
  final response = await http.post(
    Uri.parse('${ApiEndpoints.tokenBaseUrl}/skip'),
    headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    body: json.encode({'date': date, 'mealType': mealType}),
  );
  return json.decode(response.body);
}

Future<Map<String, dynamic>> getMySkips() async {
  final response = await http.get(
    Uri.parse('${ApiEndpoints.tokenBaseUrl}/my-skips'),
    headers: {'Authorization': 'Bearer $token'},
  );
  return json.decode(response.body);
}

  // 1. Get Meal Token History
  Future<Map<String, dynamic>> getUserHistory(int page) async {
    if (token == null) return {'success': false, 'message': 'User not authenticated.'};

    try {
      final response = await http.get(
        Uri.parse('${ApiEndpoints.tokenBaseUrl}/my-history?page=$page'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return response.statusCode == 200 ? json.decode(response.body) : {'success': false, 'message': 'Failed to load history.'};
    } catch (e) {
      return {'success': false, 'message': 'Connection error.'};
    }
  }

  // 2. Generate New Token
  Future<Map<String, dynamic>> generateToken(String mealType) async {
    if (token == null) return {'success': false, 'message': 'User not authenticated.'};

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/generate'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'mealType': mealType}),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error.'};
    }
  }

  // 3. ✅ FIXED: Get User Payment History (REMOVED DUPLICATES)
  Future<Map<String, dynamic>> getUserPaymentHistory() async {
    if (token == null) return {'success': false, 'message': 'Auth missing'};

    try {
      final response = await http.get(
        Uri.parse('${ApiEndpoints.authBaseUrl}/payment-history'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'success': false, 'message': 'Failed to load payment history.'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error.'};
    }
  }

  // 4. Verify Payment Success
  Future<Map<String, dynamic>> verifyOnlinePayment(String paymentId, String orderId) async {
    if (token == null) return {'success': false, 'message': 'Auth missing'};

    try {
      final response = await http.post(
        Uri.parse('${ApiEndpoints.authBaseUrl}/payment-success'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'paymentId': paymentId,
          'orderId': orderId,
        }),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Payment verification failed.'};
    }
  }

  // 5. Admin Stats
  Future<Map<String, dynamic>> getTodayStats() async {
    if (token == null) return {'success': false, 'message': 'User not authenticated.'};

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/stats/today'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return response.statusCode == 200 
          ? json.decode(response.body) 
          : {'breakfast': 0, 'lunch': 0, 'snacks': 0, 'dinner': 0};
    } catch (e) {
      return {'breakfast': 0, 'lunch': 0, 'snacks': 0, 'dinner': 0};
    }
  }
}