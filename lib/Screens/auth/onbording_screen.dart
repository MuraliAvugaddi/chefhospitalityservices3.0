import 'package:chefhospitalityservices/Controllers/auth_controller.dart';
import 'package:chefhospitalityservices/Screens/auth/signin_screen.dart';
import 'package:chefhospitalityservices/Screens/auth/signup_step1_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Keep your critical controller fix
    Get.put(SignupController(), permanent: true);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xffFADD73), // Your brand yellow
        ),
        child: Column(
          children: [
            // --- TOP SECTION: Visual Brand ---
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  // Animated-style floating image
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Image.asset(
                        "assets/images/cheifimage3d.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- BOTTOM SECTION: Interaction Card ---
            // This acts like a "Bottom Sheet" for a modern mobile feel
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, -10),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Left aligned for modern look
                children: [
                  Text(
                    'Welcome to\nChef Hospitality',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xff2D2D2D),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'The smartest way to manage your meals and digital payments in one place.',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.grey[600],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Primary Action Button (Signin)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Get.to(() => SigninScreen()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFFC800),
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Login Now",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Secondary Action (Signup) - Outline Style
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () => Get.to(() => SignupStep1Screen()),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color(0xffFFC800), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Create New Account",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
