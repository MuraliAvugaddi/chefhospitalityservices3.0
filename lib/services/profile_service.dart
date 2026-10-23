import 'dart:convert';
import 'package:chefhospitalityservices/Models/user_model.dart';
import 'package:chefhospitalityservices/api/api_endpoint.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class UserService {
  Future<User> fetchUserProfile() async {
    final box = GetStorage();
    final token = box.read('token');
    if (token == null) {
      throw Exception('Authentication token not found. Please log in again.');
    }

    final response = await http.get(
      Uri.parse(ApiEndpoints.userProfile),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      try {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to load user profile');
      } catch (e) {
        throw Exception('Failed to load profile. Status code: ${response.statusCode}');
      }
    }
  }

  // ============================================================
  // SUBMIT FEEDBACK API CALL
  // ============================================================
  Future<bool> submitFeedback(int rating, String message) async {
    final box = GetStorage();
    final token = box.read('token');
    if (token == null) {
      throw Exception('Authentication token not found.');
    }

    final response = await http.post(
      Uri.parse(ApiEndpoints.feedbackSubmit),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'rating': rating, 'message': message}),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      try {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to submit feedback');
      } catch (e) {
        throw Exception('Failed to submit feedback. Status code: ${response.statusCode}');
      }
    }
  }

  // ============================================================
  // DELETE ACCOUNT API CALL
  // ============================================================
  Future<bool> deleteAccount() async {
    final box = GetStorage();
    final token = box.read('token');
    if (token == null) {
      throw Exception('Authentication token not found.');
    }

    final response = await http.delete(
      Uri.parse(ApiEndpoints.userProfile),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      try {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to delete account');
      } catch (e) {
        throw Exception('Failed to delete account. Status code: ${response.statusCode}');
      }
    }
  }
}