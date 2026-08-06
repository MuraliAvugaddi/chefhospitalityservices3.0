import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:chefhospitalityservices/Controllers/auth_controller.dart';
import 'package:chefhospitalityservices/Controllers/profile_controller.dart';
import 'package:chefhospitalityservices/Screens/history_screen.dart';

// ============================================================
// CHEF APP BRAND COLORS
// ============================================================

const Color primaryColor = Color(0xFFFADD73);
const Color primaryDark = Color(0xFFD5A514);
const Color primaryLight = Color(0xFFFFF8DC);

const Color secondaryColor = Color(0xFFC6E4AD);
const Color secondaryLight = Color(0xFFF1F8EB);
const Color secondaryDark = Color(0xFF669447);

const Color darkTextColor = Color(0xFF252A27);
const Color lightTextColor = Color(0xFF7C837F);

const Color backgroundColor = Color(0xFFFAFAF8);
const Color cardColor = Colors.white;

// ============================================================
// SUPPORT DETAILS
// ============================================================

// Your visible phone number
const String supportPhoneNumber = '9398315945';

// WhatsApp requires:
// Country code + phone number
// No "+" symbol, spaces or dashes.
//
// India country code = 91
// Your WhatsApp number = 91 + 9398315945
const String supportWhatsAppNumber = '919398315945';

// Google Site Policy Link for Cashfree & Play Store Compliance
const String policyWebLink =
    'https://sites.google.com/view/chef-hospitality-policies/home';

// ============================================================
// PROFILE AD CONTROLLER
// ============================================================

class ProfileAdController extends GetxController {
  NativeAd? _nativeAd;

  final isAdLoaded = false.obs;

  final String _androidAdUnitId = 'ca-app-pub-6236176751859838/9454234093';

  final String _iosAdUnitId = 'ca-app-pub-6236176751859838/9597704324';

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

    if (!kIsWeb) {
      _loadAd();
    }
  }

  @override
  void onClose() {
    _nativeAd?.dispose();
    super.onClose();
  }

  void _loadAd() {
    if (kIsWeb) {
      isAdLoaded.value = false;
      return;
    }

    _nativeAd = NativeAd(
      adUnitId: _nativeAdUnitId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('Ad loaded for ProfileScreen.');

          _nativeAd = ad as NativeAd;
          isAdLoaded.value = true;
        },
        onAdFailedToLoad: (
          Ad ad,
          LoadAdError error,
        ) {
          debugPrint('Ad failed to load: $error');

          isAdLoaded.value = false;
          ad.dispose();
        },
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: Colors.white,
        cornerRadius: 18,
      ),
    )..load();
  }
}

// ============================================================
// PROFILE SCREEN
// ============================================================

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // ============================================================
  // OPEN WHATSAPP
  // ============================================================

  Future<void> _openWhatsApp() async {
    const String message =
        'Hi Chef Hospitality Support, I need help with my account.';

    final String encodedMessage = Uri.encodeComponent(message);

    // ============================================================
    // WHATSAPP APP DIRECT LINK
    // ============================================================

    final Uri whatsappApp = Uri.parse(
      'whatsapp://send?phone=$supportWhatsAppNumber&text=$encodedMessage',
    );

    // ============================================================
    // WHATSAPP WEB FALLBACK
    // ============================================================

    final Uri whatsappWeb = Uri.parse(
      'https://wa.me/$supportWhatsAppNumber?text=$encodedMessage',
    );

    try {
      // ----------------------------------------------------------
      // FIRST TRY: Open installed WhatsApp application
      // ----------------------------------------------------------

      if (await canLaunchUrl(whatsappApp)) {
        final bool opened = await launchUrl(
          whatsappApp,
          mode: LaunchMode.externalApplication,
        );

        if (opened) {
          return;
        }
      }

      // ----------------------------------------------------------
      // SECOND TRY: Open official WhatsApp wa.me link
      // ----------------------------------------------------------

      final bool webOpened = await launchUrl(
        whatsappWeb,
        mode: LaunchMode.externalApplication,
      );

      if (!webOpened) {
        _showWhatsAppError();
      }
    } catch (e) {
      debugPrint(
        'WhatsApp opening error: $e',
      );

      _showWhatsAppError();
    }
  }

  // ============================================================
  // OPEN POLICY WEB LINK
  // ============================================================

  Future<void> _openPolicyLink() async {
    final Uri url = Uri.parse(policyWebLink);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        Get.snackbar(
          'Unable to open link',
          'Please visit $policyWebLink',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error launching policy link: $e');
    }
  }

  // ============================================================
  // OPEN PHONE CALL
  // ============================================================

  Future<void> _callSupport() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: supportPhoneNumber,
    );

    try {
      final bool opened = await launchUrl(
        phoneUri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened) {
        Get.snackbar(
          'Unable to make call',
          'Please call us at +91 $supportPhoneNumber',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 15,
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Unable to make call',
        'Please call us at +91 $supportPhoneNumber',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 15,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    }
  }

  // ============================================================
  // WHATSAPP ERROR
  // ============================================================

  void _showWhatsAppError() {
    Get.snackbar(
      'Unable to open WhatsApp',
      'Please contact support at +91 $supportPhoneNumber',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 15,
      backgroundColor: Colors.red.shade400,
      colorText: Colors.white,
      icon: const Icon(
        Icons.error_outline_rounded,
        color: Colors.white,
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();

    final SignupController authController = Get.find<SignupController>();

    final ProfileAdController adController = Get.put(ProfileAdController());

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Obx(() {
          // ==================================================
          // LOADING
          // ==================================================

          if (controller.isLoading.value &&
              controller.user.value.name == 'Guest') {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryDark,
              ),
            );
          }

          // ==================================================
          // ERROR
          // ==================================================

          if (controller.errorMessage.value.isNotEmpty) {
            return _buildErrorState(controller);
          }

          // ==================================================
          // MAIN PROFILE UI
          // ==================================================

          return RefreshIndicator(
            color: primaryDark,
            backgroundColor: Colors.white,
            onRefresh: () => controller.fetchUserProfile(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // HEADER
                SliverToBoxAdapter(
                  child: _buildHeader(controller),
                ),

                // CONTENT
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    18,
                    0,
                    18,
                    30,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        // ======================================
                        // PERSONAL INFORMATION
                        // ======================================

                        _buildSectionTitle(
                          title: "Personal Information",
                          icon: Icons.person_outline_rounded,
                          color: primaryDark,
                          background: primaryLight,
                        ),

                        const SizedBox(height: 12),

                        _buildInformationCard(
                          children: [
                            _buildInfoItem(
                              icon: Icons.badge_outlined,
                              title: "Enrollment",
                              value: controller.user.value.enrollmentNo,
                              iconColor: primaryDark,
                              iconBackground: primaryLight,
                            ),
                            _divider(),
                            _buildInfoItem(
                              icon: Icons.phone_outlined,
                              title: "Phone Number",
                              value: controller.user.value.phonenumber,
                              iconColor: primaryDark,
                              iconBackground: primaryLight,
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // ======================================
                        // ACADEMIC DETAILS
                        // ======================================

                        _buildSectionTitle(
                          title: "Academic Details",
                          icon: Icons.school_outlined,
                          color: secondaryDark,
                          background: secondaryLight,
                        ),

                        const SizedBox(height: 12),

                        _buildInformationCard(
                          children: [
                            _buildInfoItem(
                              icon: Icons.menu_book_rounded,
                              title: "Course",
                              value: controller.user.value.course,
                              iconColor: secondaryDark,
                              iconBackground: secondaryLight,
                            ),
                            _divider(),
                            _buildInfoItem(
                              icon: Icons.calendar_month_outlined,
                              title: "Year",
                              value: controller.user.value.year,
                              iconColor: secondaryDark,
                              iconBackground: secondaryLight,
                            ),
                            _divider(),
                            _buildInfoItem(
                              icon: Icons.meeting_room_outlined,
                              title: "Room Number",
                              value: controller.user.value.room,
                              iconColor: secondaryDark,
                              iconBackground: secondaryLight,
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // ======================================
                        // ACTIVITY
                        // ======================================

                        _buildSectionTitle(
                          title: "Activity",
                          icon: Icons.history_rounded,
                          color: primaryDark,
                          background: primaryLight,
                        ),

                        const SizedBox(height: 12),

                        _buildHistoryCard(),

                        const SizedBox(height: 28),

                        // ======================================
                        // HELP & SUPPORT
                        // ======================================

                        _buildSectionTitle(
                          title: "Help & Support",
                          icon: Icons.support_agent_rounded,
                          color: secondaryDark,
                          background: secondaryLight,
                        ),

                        const SizedBox(height: 12),

                        _buildSupportCard(),

                        const SizedBox(height: 28),

                        // ======================================
                        // LEGAL & POLICIES (Added for Cashfree/Play Store)
                        // ======================================

                        _buildSectionTitle(
                          title: "Policies & Terms",
                          icon: Icons.privacy_tip_outlined,
                          color: primaryDark,
                          background: primaryLight,
                        ),

                        const SizedBox(height: 12),

                        _buildPolicyCard(),

                        const SizedBox(height: 28),

                        // ======================================
                        // ADVERTISEMENT
                        // ======================================

                        if (!kIsWeb) _buildAdvertisement(adController),

                        if (!kIsWeb) const SizedBox(height: 28),

                        // ======================================
                        // LOGOUT
                        // ======================================

                        _buildLogoutButton(authController),

                        const SizedBox(height: 24),

                        // APP NAME
                        Center(
                          child: Text(
                            "from",
                            style: TextStyle(
                              fontSize: 15,
                              color: const Color.fromARGB(255, 2, 176, 245)
                                  .withOpacity(0.70),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        // APP NAME
                        Center(
                          child: Text(
                            "Avugaddi Software Systems",
                            style: TextStyle(
                              fontSize: 12,
                              color: lightTextColor.withOpacity(0.70),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ============================================================
  // PROFILE HEADER
  // ============================================================

  Widget _buildHeader(
    ProfileController controller,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        18,
        14,
        18,
        28,
      ),
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        26,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFADD73),
            Color(0xFFFFE99A),
            Color(0xFFFFF3C4),
          ],
          stops: [
            0.0,
            0.55,
            1.0,
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.30),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // ==================================================
          // HEADER TOP ROW
          // ==================================================

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _headerIcon(
                Icons.person_outline_rounded,
              ),
              const Text(
                "My Profile",
                style: TextStyle(
                  color: darkTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              _headerIcon(
                Icons.verified_user_outlined,
              ),
            ],
          ),

          const SizedBox(height: 26),

          // ==================================================
          // PROFILE AVATAR
          // ==================================================

          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.60),
            ),
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_rounded,
                size: 58,
                color: primaryDark,
              ),
            ),
          ),

          const SizedBox(height: 18),

          // ==================================================
          // STUDENT NAME
          // ==================================================

          Text(
            controller.user.value.name.isEmpty
                ? "Student"
                : controller.user.value.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: darkTextColor,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),

          const SizedBox(height: 8),

          // ==================================================
          // EMAIL
          // ==================================================

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.mail_outline_rounded,
                color: darkTextColor.withOpacity(0.65),
                size: 16,
              ),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  controller.user.value.email.isEmpty
                      ? "No email available"
                      : controller.user.value.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: darkTextColor.withOpacity(0.68),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ==================================================
          // ACTIVE STUDENT BADGE
          // ==================================================

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: secondaryLight,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: secondaryColor,
                width: 1,
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: secondaryDark,
                  size: 17,
                ),
                SizedBox(width: 7),
                Text(
                  "Active Student",
                  style: TextStyle(
                    color: secondaryDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
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
  // HEADER ICON
  // ============================================================

  Widget _headerIcon(
    IconData icon,
  ) {
    return Container(
      height: 42,
      width: 42,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.58),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.75),
        ),
      ),
      child: Icon(
        icon,
        color: darkTextColor,
        size: 22,
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle({
    required String title,
    required IconData icon,
    required Color color,
    required Color background,
  }) {
    return Row(
      children: [
        Container(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 11),
        Text(
          title,
          style: const TextStyle(
            color: darkTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // INFORMATION CARD
  // ============================================================

  Widget _buildInformationCard({
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFF0F0EA),
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
        children: children,
      ),
    );
  }

  // ============================================================
  // INFORMATION ITEM
  // ============================================================

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
    required Color iconBackground,
  }) {
    final String displayValue = value.trim().isEmpty ? "Not available" : value;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: lightTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  displayValue,
                  style: const TextStyle(
                    color: darkTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
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
  // DIVIDER
  // ============================================================

  Widget _divider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFF0F1ED),
    );
  }

  // ============================================================
  // HISTORY CARD
  // ============================================================

  Widget _buildHistoryCard() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Get.to(
            () => HistoryScreen(),
          );
        },
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFFF0F0EA),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: primaryLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.history_rounded,
                  color: primaryDark,
                  size: 26,
                ),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Meal History",
                      style: TextStyle(
                        color: darkTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "View your previous activity",
                      style: TextStyle(
                        color: lightTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: primaryDark,
                  size: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // POLICY & TERMS CARD (Clickable Link for Cashfree/Google Play)
  // ============================================================

  Widget _buildPolicyCard() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _openPolicyLink,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFFF0F0EA),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: primaryLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.policy_rounded,
                  color: primaryDark,
                  size: 26,
                ),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Privacy Policy & Terms",
                      style: TextStyle(
                        color: darkTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "View our policies, terms, and menu pricing",
                      style: TextStyle(
                        color: lightTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.open_in_new_rounded,
                  color: primaryDark,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HELP & SUPPORT CARD
  // ============================================================

  Widget _buildSupportCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFF0F0EA),
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
          // ================================================
          // SUPPORT TOP
          // ================================================

          Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: secondaryLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.headset_mic_rounded,
                  color: secondaryDark,
                  size: 25,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Need some help?",
                      style: TextStyle(
                        color: darkTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "We're here to help with any issue.",
                      style: TextStyle(
                        color: lightTextColor,
                        fontSize: 11,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 17),

          // ================================================
          // WHATSAPP BUTTON
          // ================================================

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _openWhatsApp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_rounded,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Chat on WhatsApp",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 7),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 17,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ================================================
          // CALL BUTTON
          // ================================================

          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: _callSupport,
              style: OutlinedButton.styleFrom(
                foregroundColor: darkTextColor,
                side: const BorderSide(
                  color: Color(0xFFEAEAE5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.phone_outlined,
                    size: 18,
                    color: darkTextColor,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "+91 93983 15945",
                    style: TextStyle(
                      color: darkTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ================================================
          // SUPPORT INFO
          // ================================================

          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.verified_outlined,
                size: 13,
                color: lightTextColor,
              ),
              SizedBox(width: 5),
              Text(
                "Chef Hospitality Support",
                style: TextStyle(
                  color: lightTextColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ADVERTISEMENT
  // ============================================================

  Widget _buildAdvertisement(
    ProfileAdController adController,
  ) {
    return Obx(() {
      if (adController.isAdLoaded.value && adController.nativeAd != null) {
        return Container(
          width: double.infinity,
          height: 340,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFFF0F0EA),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: AdWidget(
            key: ValueKey(
              adController.nativeAd.hashCode,
            ),
            ad: adController.nativeAd!,
          ),
        );
      }

      return Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFF0F0EA),
          ),
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 17,
                width: 17,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: primaryDark,
                ),
              ),
              SizedBox(width: 12),
              Text(
                "Loading advertisement...",
                style: TextStyle(
                  color: lightTextColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // ============================================================
  // LOGOUT BUTTON
  // ============================================================

  Widget _buildLogoutButton(
    SignupController authController,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          _showLogoutDialog(
            authController,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFEEEE),
          foregroundColor: Colors.red.shade500,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(
              color: Colors.red.withOpacity(0.08),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout_rounded,
              color: Colors.red.shade500,
              size: 21,
            ),
            const SizedBox(width: 9),
            Text(
              "Logout",
              style: TextStyle(
                color: Colors.red.shade500,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LOGOUT DIALOG
  // ============================================================

  void _showLogoutDialog(
    SignupController authController,
  ) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.logout_rounded,
              color: Colors.red,
            ),
            SizedBox(width: 10),
            Text(
              "Logout?",
              style: TextStyle(
                color: darkTextColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: const Text(
          "Are you sure you want to logout from your account?",
          style: TextStyle(
            color: lightTextColor,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: lightTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();

              authController.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Logout",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ERROR SCREEN
  // ============================================================

  Widget _buildErrorState(
    ProfileController controller,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: const BoxDecoration(
                color: primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: primaryDark,
                size: 38,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Something went wrong",
              style: TextStyle(
                color: darkTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: lightTextColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 22),
            ElevatedButton.icon(
              onPressed: () {
                controller.fetchUserProfile();
              },
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text(
                "Try Again",
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: darkTextColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
