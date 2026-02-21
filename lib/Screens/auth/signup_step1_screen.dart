import 'package:chefhospitalityservices/Controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_textfield.dart';

class SignupStep1Screen extends StatelessWidget {
  SignupStep1Screen({super.key});
  final SignupController _authController = Get.find<SignupController>();
  final SignupController _authControllers = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Text(
          "Create Account",
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        backgroundColor: const Color(0xffFFC800),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Get Started Now',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffFFC800),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Step 1 of 2: Basic Details',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: const Color(0xff707070),
                ),
              ),
              const SizedBox(height: 50),
              CustomTextField(
                controller: _authController.nameController,
                hintText: 'Full Name',
                icon: Icons.person_outline,
                labelText: 'Full Name',
                // This line will capitalize the first letter of each word
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _authController.emailController,
                hintText: 'Email Address',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                labelText: 'Email Address',
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _authController.passwordController,
                hintText: 'Create Password',
                icon: Icons.lock_outline,
                isPassword: true,
                labelText: 'Create Password',
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _authControllers.phoneController,
                hintText: 'Phone Number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                labelText: 'Phone Number',
              ),
              const SizedBox(height: 40),
              Obx(
                () => _authController.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xffFFC800),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          _authController.registerStep1();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: const Color(0xffFFC800),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 26,
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
