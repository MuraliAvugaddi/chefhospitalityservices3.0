import 'package:chefhospitalityservices/Controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_textfield.dart';

class SignupPage2 extends StatelessWidget {
  SignupPage2({super.key});
  final SignupController _authController = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Additional Details',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        backgroundColor: const Color(0xffFFC800),
        iconTheme: const IconThemeData(color: Colors.white),
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Almost There!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffFFC800),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Step 2 of 2: Your Details',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 16, color: const Color(0xff707070)),
              ),
              const SizedBox(height: 50),
              CustomTextField(
                controller: _authController.enrollmentNoController,
                hintText: 'Enrollment No.',
                icon: Icons.school_outlined,
                labelText: 'Enrollment No.',
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _authController.courseController,
                hintText: 'Course (e.g., B.Tech)',
                icon: Icons.book_outlined,
                labelText: 'Course (e.g., B.Tech)',
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _authController.yearController,
                hintText: 'Year (e.g., 2)',
                icon: Icons.calendar_today_outlined,
                keyboardType: TextInputType.number,
                labelText: 'Year (e.g., 2)',
              ),
              const SizedBox(height: 20),
              // CustomTextField(
              //   controller: _authController.phoneController,
              //   hintText: 'Phone Number',
              //   icon: Icons.phone_outlined,
              //   keyboardType: TextInputType.phone,
              //   labelText: 'Phone Number',
              // ),
              // const SizedBox(height: 20),
              CustomTextField(
                controller: _authController.hostelBlockController,
                hintText: 'Hostel Block (e.g., A)',
                icon: Icons.home_work_outlined,
                labelText: 'Hostel Block (e.g., A)',
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _authController.roomController,
                hintText: 'Room No.',
                icon: Icons.meeting_room_outlined,
                keyboardType: TextInputType.number,
                labelText: 'Room No.',
              ),
              const SizedBox(height: 20),

              // --- ✅ ADDED GENDER DROPDOWN WIDGET ---
              // --- ✅ MODERN GENDER SELECTION UI ---
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gender',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff707070),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: ['Male', 'Female', 'Other'].map((gender) {
                        bool isSelected =
                            _authController.selectedGender.value == gender;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                _authController.selectedGender.value = gender,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xffFFC800)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xffFFC800)
                                      : const Color(0xffCCCCCC),
                                  width: 1.5,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xffFFC800)
                                              .withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        )
                                      ]
                                    : [],
                              ),
                              child: Center(
                                child: Text(
                                  gender,
                                  style: GoogleFonts.poppins(
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xff707070),
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
// --- END OF MODERN UI ---

              const SizedBox(height: 40),
              Obx(
                () => _authController.isLoading.value
                    ? const Center(
                        child:
                            CircularProgressIndicator(color: Color(0xffFFC800)),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          _authController.registerStep2();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          backgroundColor: const Color(0xffFFC800),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white),
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
