import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MyChoiceWidget extends StatelessWidget {
  const MyChoiceWidget({super.key});

  // ============================================================
  // BRAND COLORS
  // ============================================================

  static const Color primaryColor = Color(0xFFFADD73);
  static const Color primaryDark = Color(0xFFD5A514);
  static const Color primaryLight = Color(0xFFFFF8DC);

  static const Color darkText = Color(0xFF252A27);
  static const Color bodyText = Color(0xFF7C837F);

  static const Color borderColor = Color(0xFFECECE7);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // ============================================================
  // COMING SOON DIALOG
  // ============================================================

  void _showLockedDialog() {
    showCupertinoDialog(
      context: Get.context!,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text(
            "Coming Soon",
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              "My Choice ordering will be available soon for Day Scholars.",
              style: GoogleFonts.poppins(
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Get.back(),
              child: const Text(
                "Got it",
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====================================================
          // HEADER
          // ====================================================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              15,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryLight,
                  Color(0xFFFFFCF0),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
              ),
            ),
            child: Row(
              children: [
                // ICON
                Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.room_service_rounded,
                    color: darkText,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 12),

                // TITLE
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              "My Choice",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: darkText,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 7),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "COMING SOON",
                              style: GoogleFonts.poppins(
                                color: primaryDark,
                                fontSize: 6.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Choose meals based on your schedule",
                        style: GoogleFonts.poppins(
                          color: bodyText,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ====================================================
          // CONTENT
          // ====================================================

          Padding(
            padding: const EdgeInsets.fromLTRB(
              14,
              14,
              14,
              16,
            ),
            child: Column(
              children: [
                // =================================================
                // DAY SCHOLAR NOTICE
                // =================================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: primaryLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.55),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 34,
                        width: 34,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.school_rounded,
                          color: darkText,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "For Day Scholars",
                              style: GoogleFonts.poppins(
                                color: darkText,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              "This service is exclusively available for Day Scholars.",
                              style: GoogleFonts.poppins(
                                color: bodyText,
                                fontSize: 8,
                                height: 1.35,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // =================================================
                // BREAKFAST
                // =================================================

                _buildMealItem(
                  title: "Breakfast",
                  time: "8:00 AM - 9:00 AM",
                  imagePath: "assets/images/breakfast.png",
                  backgroundColor: const Color(0xFFFFF1F7),
                  onTap: _showLockedDialog,
                ),

                _buildDivider(),

                // =================================================
                // LUNCH
                // =================================================

                _buildMealItem(
                  title: "Lunch",
                  time: "12:00 PM - 2:00 PM",
                  imagePath: "assets/images/lunch.png",
                  backgroundColor: const Color(0xFFF0F8FB),
                  onTap: _showLockedDialog,
                ),

                _buildDivider(),

                // =================================================
                // SNACKS
                // =================================================

                _buildMealItem(
                  title: "Snacks",
                  time: "5:00 PM - 6:00 PM",
                  imagePath: "assets/images/snakes.png",
                  backgroundColor: const Color(0xFFFFF4EC),
                  onTap: _showLockedDialog,
                ),

                _buildDivider(),

                // =================================================
                // DINNER
                // =================================================

                _buildMealItem(
                  title: "Dinner",
                  time: "8:00 PM - 9:00 PM",
                  imagePath: "assets/images/dinner.png",
                  backgroundColor: primaryLight,
                  onTap: _showLockedDialog,
                ),

                const SizedBox(height: 14),

                // =================================================
                // COMING SOON BOTTOM MESSAGE
                // =================================================

                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _showLockedDialog,
                    borderRadius: BorderRadius.circular(14),
                    child: Ink(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: darkText,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                            size: 17,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            "My Choice • Coming Soon",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MEAL ITEM
  // ============================================================

  Widget _buildMealItem({
    required String title,
    required String time,
    required String imagePath,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 2,
          ),
          child: Row(
            children: [
              // =================================================
              // FOOD IMAGE
              // =================================================

              Container(
                height: 58,
                width: 58,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return const Icon(
                        Icons.restaurant_rounded,
                        color: bodyText,
                        size: 25,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // =================================================
              // DETAILS
              // =================================================

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        color: darkText,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          color: bodyText,
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            time,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: bodyText,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // =================================================
              // COMING SOON STATUS
              // =================================================

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.lock_clock_rounded,
                      color: primaryDark,
                      size: 15,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Soon",
                      style: GoogleFonts.poppins(
                        color: primaryDark,
                        fontSize: 7,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DIVIDER
  // ============================================================

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(
        left: 72,
      ),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Color(0xFFF0F0EC),
      ),
    );
  }
}
