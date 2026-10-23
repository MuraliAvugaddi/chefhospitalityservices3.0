import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chefhospitalityservices/Controllers/user_menu_controller.dart';

// ============================================================
// BRAND COLORS
// ============================================================

const Color primaryColor = Color(0xFFFADD73);
const Color primaryDark = Color(0xFFD5A514);

const Color darkTextColor = Color(0xFF252A27);
const Color lightTextColor = Color(0xFF7C837F);

const Color backgroundColor = Color(0xFFFAFAF8);
const Color surfaceColor = Color(0xFFFFFFFF);

const Color borderColor = Color(0xFFEDEDE7);

// ============================================================
// USER MENU SCREEN
// ============================================================

class UserMenuScreen extends StatefulWidget {
  const UserMenuScreen({super.key});

  @override
  State<UserMenuScreen> createState() => _UserMenuScreenState();
}

class _UserMenuScreenState extends State<UserMenuScreen> {
  final UserMenuController controller = Get.put(UserMenuController());

  final ScrollController _dayScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_dayScrollController.hasClients) {
        final double offset = controller.selectedDayIndex.value * 78.0;

        _dayScrollController.animateTo(
          offset.clamp(
            0.0,
            _dayScrollController.position.maxScrollExtent,
          ),
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _dayScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // ======================================================
      // APP BAR
      // ======================================================

      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Mess Menu",
                style: TextStyle(
                  color: darkTextColor,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              if (controller.activeMenu.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    controller.activeMenu['month'] ?? "",
                    style: const TextStyle(
                      color: lightTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.22),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.restaurant_rounded,
              color: primaryDark,
              size: 21,
            ),
          ),
        ],
      ),

      // ======================================================
      // BODY
      // ======================================================

      body: Obx(() {
        // ----------------------------------------------------
        // LOADING
        // ----------------------------------------------------

        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: primaryDark,
              strokeWidth: 2.5,
            ),
          );
        }

        // ----------------------------------------------------
        // ERROR
        // ----------------------------------------------------

        if (controller.errorMessage.value.isNotEmpty) {
          return _buildErrorState();
        }

        // ----------------------------------------------------
        // MENU
        // ----------------------------------------------------

        return Column(
          children: [
            _buildDaySelector(),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  16,
                  14,
                  16,
                  28,
                ),
                children: [
                  _buildSectionHeader(),
                  const SizedBox(height: 14),
                  _buildMealCard(
                    title: "Breakfast",
                    time: "08:00 AM - 10:00 AM",
                    icon: Icons.wb_sunny_outlined,
                    items: controller.getMealItems('breakfast'),
                    cardColor: const Color(0xFFFFFAE8),
                    iconColor: const Color(0xFFE0A900),
                  ),
                  _buildMealCard(
                    title: "Lunch",
                    time: "12:00 PM - 02:00 PM",
                    icon: Icons.wb_sunny_rounded,
                    items: controller.getMealItems('lunch'),
                    cardColor: const Color(0xFFF0F8E8),
                    iconColor: const Color(0xFF63A35C),
                  ),
                  _buildMealCard(
                    title: "Snacks",
                    time: "05:00 PM - 06:00 PM",
                    icon: Icons.bakery_dining_outlined,
                    items: controller.getMealItems('snacks'),
                    cardColor: const Color(0xFFFFF2E7),
                    iconColor: const Color(0xFFE47A25),
                  ),
                  _buildMealCard(
                    title: "Dinner",
                    time: "08:00 PM - 09:00 PM",
                    icon: Icons.nightlight_round,
                    items: controller.getMealItems('dinner'),
                    cardColor: const Color(0xFFF0F0FA),
                    iconColor: const Color(0xFF6969A8),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  // ==========================================================
  // ERROR STATE
  // ==========================================================

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 72,
              width: 72,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.18),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.restaurant_menu_rounded,
                size: 34,
                color: primaryDark,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              "Unable to load menu",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: darkTextColor,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: lightTextColor,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              height: 46,
              child: ElevatedButton.icon(
                onPressed: () => controller.fetchActiveMenu(),
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 19,
                ),
                label: const Text(
                  "Try Again",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryDark,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // DAY SELECTOR
  // ==========================================================

  Widget _buildDaySelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 14,
        bottom: 13,
      ),
      decoration: const BoxDecoration(
        color: surfaceColor,
        border: Border(
          bottom: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
      ),
      child: SizedBox(
        height: 54,
        child: ListView.builder(
          controller: _dayScrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.days.length,
          itemBuilder: (context, index) {
            return Obx(() {
              final bool isSelected =
                  controller.selectedDayIndex.value == index;

              return GestureDetector(
                onTap: () => controller.changeDay(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  margin: const EdgeInsets.only(right: 9),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryDark : const Color(0xFFF5F5F1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isSelected ? primaryDark : const Color(0xFFE9E9E2),
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: primaryDark.withOpacity(0.20),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      controller.days[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : darkTextColor,
                        fontWeight:
                            isSelected ? FontWeight.w800 : FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              );
            });
          },
        ),
      ),
    );
  }

  // ==========================================================
  // SECTION HEADER
  // ==========================================================

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Today's Meals",
                style: TextStyle(
                  color: darkTextColor,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 3),
              Obx(
                () => Text(
                  controller.days.isNotEmpty &&
                          controller.selectedDayIndex.value <
                              controller.days.length
                      ? controller.days[controller.selectedDayIndex.value]
                      : "Select a day",
                  style: const TextStyle(
                    color: lightTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.restaurant_rounded,
                color: primaryDark,
                size: 15,
              ),
              SizedBox(width: 5),
              Text(
                "MENU",
                style: TextStyle(
                  color: primaryDark,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // MEAL CARD
  // ==========================================================

  Widget _buildMealCard({
    required String title,
    required String time,
    required IconData icon,
    required List<String> items,
    required Color cardColor,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------------------------------------
            // MEAL HEADER
            // ------------------------------------------------

            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 23,
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: darkTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 13,
                            color: lightTextColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            time,
                            style: const TextStyle(
                              color: lightTextColor,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ------------------------------------------------
                // MEAL COUNT
                // ------------------------------------------------

                if (items.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Text(
                      "${items.length} items",
                      style: const TextStyle(
                        color: lightTextColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 15),

            // ------------------------------------------------
            // DIVIDER
            // ------------------------------------------------

            Container(
              height: 1,
              color: const Color(0xFFF1F1EC),
            ),

            const SizedBox(height: 14),

            // ------------------------------------------------
            // FOOD ITEMS
            // ------------------------------------------------

            items.isEmpty
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 17,
                          color: lightTextColor,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "No items configured",
                          style: TextStyle(
                            color: lightTextColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: items.map(
                      (item) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(
                              color: const Color(0xFFE8E8E1),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: primaryDark,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 7),
                              Text(
                                item,
                                style: const TextStyle(
                                  color: darkTextColor,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
