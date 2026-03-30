

// import 'package:chefhospitalityservices/Screens/auth/onbording_screen.dart';
// import 'package:chefhospitalityservices/api/api_endpoint.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:get_storage/get_storage.dart';
// import 'package:get/get.dart';

// class ApiService {
//   static const String _baseUrl = ApiEndpoints.tokenBaseUrl;
//   final box = GetStorage();

//   String? get token => box.read('token');

//   // ✅ THE MAGIC FUNCTION: Checks for expired tokens globally
//   void _checkTokenExpiry(int statusCode) {
//     if (statusCode == 401 || statusCode == 403) {
//       box.remove('token'); // 1. Delete the expired token

//       // 2. Force the user back to the login screen
//       Get.offAll(() => const OnboardingScreen());

//       // 3. Show a nice message explaining why
//       Get.snackbar(
//         "Session Expired",
//         "Your session has expired. Please log in again.",
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }

//   // --- API METHODS ---

//   Future<Map<String, dynamic>> submitMealSkip(
//       String date, String mealType) async {
//     if (token == null) return {'success': false, 'message': 'Auth missing'};
//     final response = await http.post(
//       Uri.parse('${ApiEndpoints.tokenBaseUrl}/skip'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token'
//       },
//       body: json.encode({'date': date, 'mealType': mealType}),
//     );
//     _checkTokenExpiry(response.statusCode);
//     return json.decode(response.body);
//   }

//   // ✅ UPDATED: Now correctly appends the ?page= parameter to the URL
//   Future<Map<String, dynamic>> getMySkips({required int page}) async {
//     if (token == null) return {'success': false, 'message': 'Auth missing'};
//     try {
//       final response = await http.get(
//         Uri.parse('${ApiEndpoints.tokenBaseUrl}/my-skips?page=$page'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );
//       _checkTokenExpiry(response.statusCode);
//       return response.statusCode == 200
//           ? json.decode(response.body)
//           : {'success': false, 'message': 'Failed to load skip history.'};
//     } catch (e) {
//       return {'success': false, 'message': 'Connection error.'};
//     }
//   }

//   Future<Map<String, dynamic>> getUserHistory(int page) async {
//     if (token == null)
//       return {'success': false, 'message': 'User not authenticated.'};
//     try {
//       final response = await http.get(
//         Uri.parse('${ApiEndpoints.tokenBaseUrl}/my-history?page=$page'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );
//       _checkTokenExpiry(response.statusCode);
//       return response.statusCode == 200
//           ? json.decode(response.body)
//           : {'success': false, 'message': 'Failed to load history.'};
//     } catch (e) {
//       return {'success': false, 'message': 'Connection error.'};
//     }
//   }

//   Future<Map<String, dynamic>> generateToken(String mealType) async {
//     if (token == null)
//       return {'success': false, 'message': 'User not authenticated.'};
//     try {
//       final response = await http.post(
//         Uri.parse('$_baseUrl/generate'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: json.encode({'mealType': mealType}),
//       );
//       _checkTokenExpiry(response.statusCode);
//       return json.decode(response.body);
//     } catch (e) {
//       return {'success': false, 'message': 'Connection error.'};
//     }
//   }

//   Future<Map<String, dynamic>> getUserPaymentHistory() async {
//     if (token == null) return {'success': false, 'message': 'Auth missing'};
//     try {
//       final response = await http.get(
//         Uri.parse('${ApiEndpoints.authBaseUrl}/payment-history'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );
//       _checkTokenExpiry(response.statusCode);
//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       } else {
//         return {'success': false, 'message': 'Failed to load payment history.'};
//       }
//     } catch (e) {
//       return {'success': false, 'message': 'Connection error.'};
//     }
//   }

//   Future<Map<String, dynamic>> verifyOnlinePayment(
//       String paymentId, String orderId) async {
//     if (token == null) return {'success': false, 'message': 'Auth missing'};
//     try {
//       final response = await http.post(
//         Uri.parse('${ApiEndpoints.authBaseUrl}/payment-success'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: json.encode({
//           'paymentId': paymentId,
//           'orderId': orderId,
//         }),
//       );
//       _checkTokenExpiry(response.statusCode);
//       return json.decode(response.body);
//     } catch (e) {
//       return {'success': false, 'message': 'Payment verification failed.'};
//     }
//   }

//   Future<Map<String, dynamic>> getTodayStats() async {
//     if (token == null)
//       return {'success': false, 'message': 'User not authenticated.'};
//     try {
//       final response = await http.get(
//         Uri.parse('$_baseUrl/stats/today'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );
//       _checkTokenExpiry(response.statusCode);
//       return response.statusCode == 200
//           ? json.decode(response.body)
//           : {'breakfast': 0, 'lunch': 0, 'snacks': 0, 'dinner': 0};
//     } catch (e) {
//       return {'breakfast': 0, 'lunch': 0, 'snacks': 0, 'dinner': 0};
//     }
//   }
// }
