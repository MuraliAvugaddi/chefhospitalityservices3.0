import 'package:flutter/foundation.dart'; // ✅ Web safe imports
import 'package:chefhospitalityservices/Controllers/auth_controller.dart';
import 'package:chefhospitalityservices/Controllers/profile_controller.dart';
import 'package:chefhospitalityservices/Screens/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

const Color primaryColor = Color(0xFFC6E4AD);
const Color accentColor = Color(0xFFFADD73);
const Color darkTextColor = Color(0xFF2C3E50);
const Color lightTextColor = Color(0xFF7F8C8D);
const Color backgroundColor = Color.fromARGB(255, 255, 255, 255);

class ProfileAdController extends GetxController {
  NativeAd? _nativeAd;
  final isAdLoaded = false.obs;

  final String _androidAdUnitId = 'ca-app-pub-6236176751859838/9454234093';
  final String _iosAdUnitId = 'ca-app-pub-6236176751859838/9597704324';

  // ✅ Web-safe platform check
  String get _nativeAdUnitId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _androidAdUnitId;
    }
    return _iosAdUnitId;
  }

  NativeAd? get nativeAd => _nativeAd;

  @override
  void onInit() {
    super.onInit();
    _loadAd();
  }

  @override
  void onClose() {
    _nativeAd?.dispose();
    super.onClose();
  }

  void _loadAd() {
    // ✅ Completely skip ad loading if running on the Web
    if (kIsWeb) {
      isAdLoaded.value = false;
      return;
    }

    _nativeAd = NativeAd(
      adUnitId: _nativeAdUnitId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('✅ Ad loaded for ProfileScreen.');
          _nativeAd = ad as NativeAd;
          isAdLoaded.value = true;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('❌ Ad failed to load: $error');
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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();
    final SignupController authController = Get.find<SignupController>();
    final ProfileAdController adController = Get.put(ProfileAdController());

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.user.value.name == 'Guest') {
          return const Center(
              child: CircularProgressIndicator(color: primaryColor));
        } else if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text('Error: ${controller.errorMessage.value}'));
        } else {
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
                        horizontal: 16.0, vertical: 24.0),
                    child: Column(
                      children: [
                        _buildInfoSection(
                          context: context,
                          title: 'Personal Information',
                          color: accentColor,
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
                        _buildInfoSection(
                          context: context,
                          title: 'Academic Details',
                          color: primaryColor,
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
                        const SizedBox(height: 18),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => HistoryScreen());
                          },
                          child: Container(
                            height: 86,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                color: const Color(0xffF2F3F5),
                                border: Border.all(
                                    color: const Color(0xffF2F3F5), width: 3)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: [
                                  Icon(Icons.history_rounded,
                                      color: darkTextColor.withOpacity(0.8)),
                                  const SizedBox(width: 18),
                                  Text(
                                    "History",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: darkTextColor.withOpacity(0.8)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        _buildLogoutButton(authController),
                        const SizedBox(height: 20),

                        // ✅ Hide Ad Widget entirely if on Web
                        if (!kIsWeb)
                          Obx(() {
                            if (adController.isAdLoaded.value &&
                                adController.nativeAd != null) {
                              return Container(
                                key: ValueKey(adController.nativeAd.hashCode),
                                width: double.infinity,
                                height: 340,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.center,
                                child: AdWidget(ad: adController.nativeAd!),
                              );
                            } else {
                              return Container(
                                height: 340,
                                width: double.infinity,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.center,
                                child:
                                    const Center(child: Text("Loading ad...")),
                              );
                            }
                          }),
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

  // ✅ FIXED: UI Overlap issue resolved by stacking elements perfectly in the background
  SliverAppBar _buildProfileAppBar(ProfileController controller) {
    return SliverAppBar(
      expandedHeight:
          260.0, // Increased slightly to give elements room to breathe
      floating: false,
      pinned: true,
      backgroundColor: backgroundColor,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 10),
              const CircleAvatar(
                radius: 55,
                backgroundColor: darkTextColor,
                child: CircleAvatar(
                  radius: 52,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 60, color: darkTextColor),
                ),
              ),
              const SizedBox(height: 16), // Space between Avatar and Name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  controller.user.value.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: darkTextColor,
                    fontSize: 24.0, // Larger size to stand out as a title
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 6), // Space between Name and Email
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  controller.user.value.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: lightTextColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
            color: Colors.grey.withOpacity(0.2),
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
                Icon(icon, color: darkTextColor.withOpacity(0.8)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: darkTextColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: backgroundColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xffFFC800), width: 1.5),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      leading: Icon(icon, size: 28, color: darkTextColor.withOpacity(0.7)),
      title: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.w500, color: lightTextColor, fontSize: 14),
      ),
      subtitle: Text(
        subtitle.isEmpty ? 'N/A' : subtitle,
        style: const TextStyle(
            fontSize: 17, fontWeight: FontWeight.bold, color: darkTextColor),
      ),
    );
  }

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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          elevation: 4,
          shadowColor: Colors.red.withOpacity(0.4),
        ),
      ),
    );
  }
}
