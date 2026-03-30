import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MyChoiceWidget extends StatelessWidget {
  const MyChoiceWidget({super.key});

  void _showLockedDialog() {
    showCupertinoDialog(
      context: Get.context!,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          "Coming Soon",
          style: TextStyle(color: CupertinoColors.activeBlue),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            "My Choice access will open very soon for Day Scholars.",
            style: TextStyle(fontSize: 16),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text("OK"),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: const Color(0xffE3E3E3), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "My Choice",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 16, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Note:",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              color: Colors.blue.shade900,
                              fontSize: 11,
                            ),
                          ),
                          TextSpan(
                            text:
                                " This service is exclusively for Day Scholars.",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: Colors.blue.shade800,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildMealItem(
              title: "Breakfast",
              time: "8 AM - 9 AM",
              imagePath: "assets/images/breakfast.png",
              bgColor: const Color(0xffE4ADCF),
              onTap: _showLockedDialog,
            ),
            _buildDivider(),
            _buildMealItem(
              title: "Lunch",
              time: "12 PM - 2 PM",
              imagePath: "assets/images/lunch.png",
              bgColor: const Color(0xffB1D8E6),
              onTap: _showLockedDialog,
            ),
            _buildDivider(),
            _buildMealItem(
              title: "Snacks",
              time: "5 PM - 6 PM",
              imagePath: "assets/images/snakes.png",
              bgColor: const Color(0xffFFCBA9),
              onTap: _showLockedDialog,
            ),
            _buildDivider(),
            _buildMealItem(
              title: "Dinner",
              time: "8 PM - 9 PM",
              imagePath: "assets/images/dinner.png",
              bgColor: const Color(0xffFCDC67),
              onTap: _showLockedDialog,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealItem({
    required String title,
    required String time,
    required String imagePath,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            // ✅ INCREASED: Container size and reduced padding for larger image visual
            Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: bgColor,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.all(4), // Reduced padding = Larger image
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                Text(
                  time,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const Spacer(),
            // ✅ INCREASED: Horizontal padding for a wider button
            Container(
              constraints:
                  const BoxConstraints(minWidth: 90), // Ensures minimum width
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
              ),
              child: Center(
                child: Text(
                  "Order Now",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey.shade200, thickness: 1, height: 10);
  }
}
