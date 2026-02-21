import 'dart:convert';
import 'package:chefhospitalityservices/api/api_endpoint.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // ✅ Updated Step 1: Only checks if the email is free.
  // Does NOT create a user in the database yet.
  Future<bool> checkEmailAvailability(String email) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.signupStep1),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return true; // Email is available
      } else {
        final data = jsonDecode(response.body);
        throw Exception(
            data['message'] ?? 'An account with this email already exists.');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // ✅ Updated Step 2: Sends ALL data (Step 1 + Step 2 info) to create the account.
  // This ensures the database is only updated when the user finished everything.
  // lib/services/auth_services.dart

  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    required String enrollmentNo,
    required String course,
    required String year,
    required String phonenumber,
    required String hostelblock,
    required String room,
    required String gender,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.signupStep2),
        headers: {
          'Content-Type': 'application/json'
        }, // ✅ NO AUTHORIZATION HEADER NEEDED
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'enrollmentNo': enrollmentNo,
          'course': course,
          'year': year,
          'phonenumber': phonenumber,
          'hostelblock': hostelblock,
          'room': room,
          'gender': gender,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception('Error during registration: ${e.toString()}');
    }
  }

  // ✅ Keep your existing Sign In logic
  static Future<Map<String, dynamic>> signin(
      {required String email, required String password}) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.signinpage),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, 'password': password}),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw Exception(responseData['message'] ?? 'Failed to sign in.');
      }
    } catch (e) {
      throw Exception('Error during sign-in: ${e.toString()}');
    }
  }
}
