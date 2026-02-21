import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// Import your screens
import 'package:chefhospitalityservices/Screens/Navigation_bar/new_main_screen.dart';
import 'package:chefhospitalityservices/Screens/auth/onbording_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      // 1. Check for token/auth inside the timer
      final box = GetStorage();
      final token = box.read('token');

      // 2. Navigate based on authorization
      if (token == null) {
        Get.off(() => const OnboardingScreen());
      } else {
        Get.off(() => const MainScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/ChatGPT Image Oct 14, 2025, 11_55_22 PM.png',
              width: 250,
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              color: Colors.deepPurple, // Matching your app theme
            ),
          ],
        ),
      ),
    );
  }
}
