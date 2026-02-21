import 'dart:io' show Platform; // For platform checks
import 'package:chefhospitalityservices/Controllers/auth_controller.dart';
import 'package:chefhospitalityservices/Controllers/profile_controller.dart';
import 'package:chefhospitalityservices/Screens/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// --- ✅ 1. Import Google Mobile Ads ---
import 'package:google_mobile_ads/google_mobile_ads.dart';

// --- ✨ NEW & IMPROVED COLORS from your design ---
const Color primaryColor = Color(0xFFC6E4AD); // Soft Green
const Color accentColor = Color(0xFFFADD73); // Vibrant Yellow
const Color darkTextColor = Color(0xFF2C3E50);
const Color lightTextColor = Color(0xFF7F8C8D);
const Color backgroundColor =
    Color.fromARGB(255, 255, 255, 255); // Off-white background

// --- ✅ 2. Create a GetX Controller for the Ad ---
// This moves the ad state out of the UI, allowing the screen to be Stateless.
class ProfileAdController extends GetxController {
  // --- Ad State Variables ---
  NativeAd? _nativeAd;
  // Use .obs to make this variable "reactive"
  final isAdLoaded = false.obs;

  //               --- Ad Unit IDs ---
  final String _androidAdUnitId = 'ca-app-pub-6236176751859838/9454234093';
  final String _iosAdUnitId = 'ca-app-pub-6236176751859838/9597704324';

  String get _nativeAdUnitId =>
      Platform.isAndroid ? _androidAdUnitId : _iosAdUnitId;

  NativeAd? get nativeAd => _nativeAd;

  @override
  void onInit() {
    super.onInit();
    _loadAd(); // Load the ad when the controller is initialized
  }

  @override
  void onClose() {
    _nativeAd?.dispose(); // Dispose the ad when the controller is closed
    super.onClose();
  }

  // --- Ad Loading Logic ---
  void _loadAd() {
    isAdLoaded.value = false;

    _nativeAd = NativeAd(
      adUnitId: _nativeAdUnitId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          print('✅ Ad loaded for ProfileScreen.');
          _nativeAd = ad as NativeAd; // Store the ad
          isAdLoaded.value = true; // Update the reactive variable
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('❌ Ad failed to load: $error');
          ad.dispose();
        },
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: Colors.white,
        cornerRadius: 10.0,
      ),
    )..load();
  }
}

// --- ✅ 3. Revert ProfileScreen to a StatelessWidget ---
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- ✅ 4. Find your controllers ---
    final ProfileController controller = Get.find<ProfileController>();
    final SignupController authController = Get.find<SignupController>();
    // --- ✅ 5. Initialize (put) the new Ad Controller ---
    // This makes the controller available to the Obx widget below
    final ProfileAdController adController = Get.put(ProfileAdController());

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Obx(() {
        // This Obx now listens to ProfileController's state
        if (controller.isLoading.value &&
            controller.user.value.name == 'Guest') {
          return const Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        } else if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text('Error: ${controller.errorMessage.value}'));
        } else {
          // --- ✨ UI RENDER ---
          return RefreshIndicator(
            onRefresh: () => controller.fetchUserProfile(),
            color: darkTextColor,
            backgroundColor: backgroundColor,
            child: CustomScrollView(
              slivers: [
                _buildProfileAppBar(controller),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 24.0,
                    ),
                    child: Column(
                      children: [
                        // --- New Info Section Widget ---
                        _buildInfoSection(
                          context: context,
                          title: 'Personal Information',
                          color: accentColor, // Yellow card
                          icon: Icons.person_outline,
                          children: [
                            _buildInfoTile(
                              icon: Icons.confirmation_number_outlined,
                              title: 'Enrollment',
                              subtitle: controller.user.value.enrollmentNo,
                            ),
                            _buildInfoTile(
                              icon: Icons.phone_outlined,
                              title: 'Phone Number',
                              subtitle: controller.user.value.phonenumber,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // --- New Info Section Widget ---
                        _buildInfoSection(
                          context: context,
                          title: 'Academic Details',
                          color: primaryColor, // Green card
                          icon: Icons.school_outlined,
                          children: [
                            _buildInfoTile(
                              icon: Icons.menu_book_outlined,
                              title: 'Course',
                              subtitle: controller.user.value.course,
                            ),
                            _buildInfoTile(
                              icon: Icons.calendar_today_outlined,
                              title: 'Year',
                              subtitle: controller.user.value.year,
                            ),
                            _buildInfoTile(
                              icon: Icons.door_front_door_outlined,
                              title: 'Room No',
                              subtitle: controller.user.value.room,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 18,
                        ),
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        GestureDetector(
                          onTap: () {
                            Get.to(() => HistoryScreen());
                          },
                          child: Container(
                            height: 86,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                color: Color(0xffF2F3F5),
                                border: Border.all(
                                    color: Color(0xffF2F3F5), width: 3)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.history_rounded,
                                      color:
                                          darkTextColor.withValues(alpha: 0.8)),
                                  SizedBox(
                                    width: 18,
                                  ),
                                  Text(
                                    "History",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: darkTextColor.withValues(
                                            alpha: 0.8)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        _buildLogoutButton(authController),
                        const SizedBox(height: 20),

                        // --- ✅ 6. WRAP AD WIDGET in Obx ---
                        // This Obx listens to the adController's state
                        Obx(() {
                          if (adController.isAdLoaded.value &&
                              adController.nativeAd != null) {
                            return Container(
                              key: ValueKey(adController.nativeAd.hashCode),
                              width: double.infinity,
                              height: 340,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              child: AdWidget(ad: adController.nativeAd!),
                            );
                          } else {
                            // Placeholder while ad loads
                            return Container(
                              height: 340,
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              child: const Center(child: Text("Loading ad...")),
                            );
                          }
                        }),
                        // --- End Ad Widget Container ---
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  // --- ✨ WIDGET 1: A more modern AppBar-like header [FIXED] ---
  SliverAppBar _buildProfileAppBar(ProfileController controller) {
    return SliverAppBar(
      expandedHeight: 240.0,
      floating: false,
      pinned: true,
      backgroundColor: backgroundColor,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        // Added horizontal padding to prevent text from touching the edges
        titlePadding: const EdgeInsets.only(bottom: 16, left: 24, right: 24),
        title: Text(
          controller.user.value.name,
          maxLines: 1, // <-- FIX 1: Force to one line
          overflow: TextOverflow.ellipsis, // <-- FIX 2: Add '...' if too long
          style: const TextStyle(
            color: darkTextColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 40),
            const CircleAvatar(
              radius: 55,
              backgroundColor: darkTextColor,
              child: CircleAvatar(
                radius: 52,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 60, color: darkTextColor),
              ),
            ),
            const SizedBox(height: 12),
            // Added padding and text controls to the email as well
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                controller.user.value.email,
                maxLines: 1, // <-- FIX 3: Force to one line
                overflow:
                    TextOverflow.ellipsis, // <-- FIX 4: Add '...' if too long
                textAlign: TextAlign.center, // <-- FIX 5: Ensure it's centered
                style: TextStyle(fontSize: 16, color: lightTextColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- ✨ WIDGET 2: The new colorful info card section ---
  Widget _buildInfoSection({
    required BuildContext context,
    required String title,
    required Color color,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: darkTextColor.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: darkTextColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: backgroundColor.withValues(
                  alpha: 0.8), // Slightly transparent white
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xffFFC800), width: 1.5),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  // --- ✨ WIDGET 3: The info tile, styled for the new cards ---
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      leading: Icon(
        icon,
        size: 28,
        color: darkTextColor.withValues(alpha: 0.7),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: lightTextColor,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle.isEmpty ? 'N/A' : subtitle,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: darkTextColor,
        ),
      ),
    );
  }

  // --- ✨ WIDGET 4: A cleaner, more modern logout button ---
  Widget _buildLogoutButton(SignupController authController) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => authController.logout(),
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text('Logout', style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade400,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          elevation: 4,
          shadowColor: Colors.red.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
