import 'package:chefhospitalityservices/Controllers/notwork_controller.dart';
import 'package:chefhospitalityservices/Controllers/profile_controller.dart';
import 'package:chefhospitalityservices/Screens/meal_skippingscreen.dart';
import 'package:chefhospitalityservices/Screens/subscription_screen.dart';
import 'package:chefhospitalityservices/Screens/scanner_screen.dart';
import 'package:chefhospitalityservices/widgets/my_Choice_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ProfileController controller = Get.find<ProfileController>();
  final NetworkController networkController = Get.put(NetworkController());

  // ✅ NEW: Logic to check if the current time matches the meal type
  bool _isWithinTimeSlot(String mealType) {
    final now = DateTime.now();
    final currentTime =
        now.hour * 60 + now.minute; // Total minutes from midnight

    switch (mealType) {
      case "Breakfast":
        return currentTime >= (7 * 60 + 50) && currentTime <= (10 * 60 + 10);
      case "Lunch":
        return currentTime >= (11 * 60 + 50) && currentTime <= (14 * 60);
      case "Snacks":
        return currentTime >= (16 * 60 + 50) && currentTime <= (18 * 60);
      case "Dinner":
        return currentTime >= (19 * 60 + 50) && currentTime <= (21 * 60 + 30);
      default:
        return false;
    }
  }

  // ✅ NEW: Beautiful UI Dialog for time restriction
  void _showTimeRestrictionDialog(String mealType, String allowedTime) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.access_time_filled_rounded,
                    size: 50, color: Colors.orange),
              ),
              const SizedBox(height: 20),
              Text(
                "Not Time for $mealType",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const SizedBox(height: 12),
              Text(
                "You can only generate this token during the designated service time:",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xffFADD73),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  allowedTime,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700, color: Colors.black),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1F2726),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("GOT IT"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNavigation(String mealType) {
    if (networkController.isOffline.value) {
      Get.snackbar(
        "No Internet",
        "Please check your internet connection.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // ✅ FIXED: First check if it is the correct time for this meal
    String allowedTime = "";
    if (mealType == "Breakfast") allowedTime = "8:00 AM - 9:00 AM";
    if (mealType == "Lunch") allowedTime = "12:00 PM - 2:00 PM";
    if (mealType == "Snacks") allowedTime = "5:00 PM - 6:00 PM";
    if (mealType == "Dinner") allowedTime = "8:00 PM - 9:00 PM";

    if (!_isWithinTimeSlot(mealType)) {
      _showTimeRestrictionDialog(mealType, allowedTime);
      return; // Stop here if it's the wrong time
    }

    // ✅ Subscription check logic
    if (controller.isSubscriptionActive) {
      Get.to(() => ScannerScreen(mealType: mealType));
    } else {
      Get.snackbar(
        "Subscription Expired",
        "Please pay your mess fees to access tokens for this month.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
        colorText: Colors.white,
        duration: const Duration(seconds: 6),
        mainButton: TextButton(
          onPressed: () => Get.to(() => SubscriptionScreen()),
          child: const Text("PAY NOW",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Obx(
          () => Text(
            'Hello ${controller.user.value.name}',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
        backgroundColor: const Color(0xffFADD73),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: GestureDetector(
              onTap: () => Get.to(() => const MealSkippingscreen()),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: const Color(0xffFADD73),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                child: const Icon(
                  Icons.event_busy_rounded,
                  color: Color.fromARGB(255, 0, 0, 0),
                  size: 22,
                ),
              ),
            ),
          ),
          Obx(() => Container(
                margin: const EdgeInsets.only(right: 15),
                child: Icon(
                  controller.isSubscriptionActive
                      ? Icons.verified
                      : Icons.error_outline,
                  color: controller.isSubscriptionActive
                      ? Colors.green
                      : Colors.red,
                ),
              )),
        ],
      ),
      body: Column(
        children: [
          Obx(() {
            if (networkController.isOffline.value) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.red,
                child: const Text(
                  'Could not Connect to internet',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return Container();
            }
          }),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          "Welcome to Chef Hospitality!",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 18),
                        MealCard(
                          mealType: "Breakfast",
                          time: "8:00 AM - 9:00 AM",
                          imagePath: "assets/images/breakfast.png",
                          cardColor: const Color(0xffFADD73),
                          onTap: () => _handleNavigation("Breakfast"),
                        ),
                        const SizedBox(height: 12),
                        MealCard(
                          mealType: "Lunch",
                          time: "12:00 PM - 2:00 PM",
                          imagePath: "assets/images/lunch.png",
                          cardColor: const Color(0xffC6E4AD),
                          onTap: () => _handleNavigation("Lunch"),
                        ),
                        const SizedBox(height: 12),
                        MealCard(
                          mealType: "Snacks",
                          time: "5:00 PM - 6:00 PM",
                          imagePath: "assets/images/snakes.png",
                          cardColor: const Color(0xffFADD73),
                          onTap: () => _handleNavigation("Snacks"),
                        ),
                        const SizedBox(height: 12),
                        MealCard(
                          mealType: "Dinner",
                          time: "8:00 PM - 9:00 PM",
                          imagePath: "assets/images/dinner.png",
                          cardColor: const Color(0xffC6E4AD),
                          onTap: () => _handleNavigation("Dinner"),
                        ),
                        const SizedBox(height: 26),
                        MyChoiceWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------- (MealCard Widget Remains the Same) -------------------
class MealCard extends StatelessWidget {
  final String mealType;
  final String time;
  final String imagePath;
  final Color cardColor;
  final VoidCallback onTap;

  const MealCard({
    super.key,
    required this.mealType,
    required this.time,
    required this.imagePath,
    required this.cardColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: cardColor,
          boxShadow: [
            BoxShadow(
              color: cardColor.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    mealType,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 16, color: Colors.black54),
                      const SizedBox(width: 5),
                      Text(
                        time,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 2,
              height: 60,
              color: Colors.black.withOpacity(0.2),
              margin: const EdgeInsets.symmetric(horizontal: 10),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 70,
                  height: 70,
                  color: Colors.grey,
                  child: const Icon(Icons.image_not_supported,
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff1F2726),
              ),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.arrow_forward_ios,
                    size: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
