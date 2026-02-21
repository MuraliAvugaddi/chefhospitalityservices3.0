import 'package:chefhospitalityservices/Screens/Navigation_bar/new_main_screen.dart';
import 'package:chefhospitalityservices/Screens/auth/onbording_screen.dart';
import 'package:chefhospitalityservices/Screens/auth/signup_page2_screen.dart';
import 'package:chefhospitalityservices/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:chefhospitalityservices/services/socket_service.dart';

class SignupController extends GetxController {
  final AuthService _authService = AuthService();
  final box = GetStorage();
  var isLoading = false.obs;

  // All text controllers for both signup and signin
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController enrollmentNoController;
  late TextEditingController courseController;
  late TextEditingController yearController;
  late TextEditingController phoneController;
  late TextEditingController hostelBlockController;
  late TextEditingController roomController;

  // Holds the value from the gender selection
  var selectedGender = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    enrollmentNoController = TextEditingController();
    courseController = TextEditingController();
    yearController = TextEditingController();
    phoneController = TextEditingController();
    hostelBlockController = TextEditingController();
    roomController = TextEditingController();
  }

  /// ✅ UPDATED STEP 1: Only validates email availability.
  /// Does not create a database entry yet.
  void registerStep1() async {
    if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all basic details', 
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading(true);
      // Only check if email is free without saving to DB
      await _authService.checkEmailAvailability(emailController.text.trim());
      
      // Move to next page if email is available
      Get.to(() => SignupPage2());
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  /// ✅ UPDATED STEP 2: Sends EVERYTHING to the backend to create the user.
  void registerStep2() async {
    // Validation for gender
    if (selectedGender.value == null || selectedGender.value!.isEmpty) {
      Get.snackbar('Error', 'Please select your gender.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading(true);
      // Send ALL data (Step 1 info + Step 2 info) to create the account in one go
      final response = await _authService.registerUser(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        enrollmentNo: enrollmentNoController.text.trim(),
        course: courseController.text.trim(),
        year: yearController.text.trim(),
        phonenumber: phoneController.text.trim(),
        hostelblock: hostelBlockController.text.trim(),
        room: roomController.text.trim(),
        gender: selectedGender.value!,
      );

      // Save token and the complete user object returned from server
      await box.write('token', response['token']);
      await box.write('user_data', response['user']);

      // Connect real-time socket
      SocketService.instance.connectAndListen();

      // Go to main app
      Get.offAll(() => const MainScreen());
    } catch (e) {
      Get.snackbar('Registration Error', e.toString().replaceAll('Exception: ', ''),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  /// Handles user sign-in
  void signInScreen() async {
    try {
      isLoading.value = true;
      final responseData = await AuthService.signin(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await box.write('token', responseData['token']);
      await box.write('user_data', responseData['user']);

      SocketService.instance.connectAndListen();
      clearController();
      Get.offAll(() => const MainScreen());
    } catch (e) {
      Get.snackbar('Login Failed', e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    SocketService.instance.disconnect();
    box.remove('token');
    box.remove('user_data');
    Get.offAll(() => OnboardingScreen());
  }

  void clearController() {
    emailController.clear();
    passwordController.clear();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    enrollmentNoController.dispose();
    courseController.dispose();
    yearController.dispose();
    phoneController.dispose();
    hostelBlockController.dispose();
    roomController.dispose();
    super.onClose();
  }
}