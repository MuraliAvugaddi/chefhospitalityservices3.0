import 'package:chefhospitalityservices/Controllers/auth_controller.dart';
import 'package:chefhospitalityservices/Screens/auth/signup_step1_screen.dart';
import 'package:chefhospitalityservices/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// Replace these with your actual paths
// import 'package:chefhospitalityservices/Controllers/auth_controller.dart';
// import 'package:chefhospitalityservices/widgets/custom_textfield.dart';

class SigninScreen extends StatelessWidget {
  SigninScreen({super.key});

  // Note: Ensure your controller is named correctly (SignupController vs AuthController)
  // I'm using Get.find if it's already initialized, or Get.put if not.
  final _authController = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Decorative Element (Optional - adds a premium feel)
          Positioned(
            top: -100,
            right: -100,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: const Color(0xffFFC800).withOpacity(0.1),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),

                  // Brand/Logo Area
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xffFFC800),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.restaurant_menu,
                        size: 40, color: Colors.black),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    'Welcome Back',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff1A1A1A),
                      letterSpacing: -0.5,
                    ),
                  ),

                  Text(
                    'Sign in to your hospitality account',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Form Fields
                  _buildLabel("Email Address"),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _authController.emailController,
                    hintText: 'name@example.com',
                    icon: Icons.alternate_email_rounded,
                    keyboardType: TextInputType.emailAddress,
                    labelText: 'name@example.com',
                  ),

                  const SizedBox(height: 24),

                  _buildLabel("Password"),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _authController.passwordController,
                    hintText: 'Enter your password',
                    icon: Icons.lock_outline_rounded,
                    isPassword: true,
                    labelText: 'Enter your password',
                  ),

                  // Forgot Password
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: TextButton(
                  //     onPressed: () {/* Navigate to forgot password */},
                  //     child: Text(
                  //       'Forgot Password?',
                  //       style: GoogleFonts.poppins(
                  //         color: const Color(0xffFFC800),
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  const SizedBox(height: 28),

                  // Sign In Button
                  Obx(() => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _authController.isLoading.value
                              ? null
                              : () => _authController.signInScreen(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffFFC800),
                            foregroundColor: Colors.black,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _authController.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.black),
                                )
                              : Text(
                                  'Sign In',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      )),

                  const SizedBox(height: 30),

                  // Footer: Toggle to Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: GoogleFonts.poppins(color: Colors.grey[600]),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Get.to(SignupStep1Screen()), // Adjust route name
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.poppins(
                            color: const Color(0xffFFC800),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xff1A1A1A),
      ),
    );
  }
}
