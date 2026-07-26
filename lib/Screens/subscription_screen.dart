import 'package:flutter/foundation.dart';
import 'package:chefhospitalityservices/Controllers/profile_controller.dart';
import 'package:chefhospitalityservices/Screens/Payment_HistoryScreen.dart';
import 'package:chefhospitalityservices/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:audioplayers/audioplayers.dart';

// ============================================================
// CHEF BRAND COLORS
// ============================================================

const Color primaryColor = Color(0xFFFADD73);
const Color primaryDark = Color(0xFFD5A514);
const Color primaryLight = Color(0xFFFFF8DC);

const Color secondaryColor = Color(0xFFC6E4AD);
const Color secondaryDark = Color(0xFF669447);
const Color secondaryLight = Color(0xFFF1F8EB);

const Color darkTextColor = Color(0xFF252A27);
const Color lightTextColor = Color(0xFF7C837F);

const Color backgroundColor = Color(0xFFFAFAF8);
const Color cardColor = Colors.white;

// ============================================================
// SUBSCRIPTION PRICE
// ============================================================

// Base monthly fee
const double basePrice = 4000;

// GST
const double gstPercentage = 2;
const double gstAmount = 80;

// Final amount
const double totalPrice = 4080;

// Razorpay accepts amount in paise.
// ₹4,080 = 408000 paise.
const int razorpayAmount = 408000;

// ============================================================
// SUBSCRIPTION SCREEN
// ============================================================

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final ProfileController controller = Get.find<ProfileController>();

  final ApiService _apiService = ApiService();

  final AudioPlayer _audioPlayer = AudioPlayer();

  late Razorpay _razorpay;

  BannerAd? _bannerAd;

  bool _isBannerAdLoaded = false;

  // ============================================================
  // ADMOB
  // ============================================================

  final String _androidBannerAdUnitId =
      'ca-app-pub-6236176751859838/9488589732';

  final String _iosBannerAdUnitId = 'ca-app-pub-3940256099942544/2934735716';

  String get _bannerAdUnitId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _androidBannerAdUnitId;
    }

    return _iosBannerAdUnitId;
  }

  // ============================================================
  // INIT STATE
  // ============================================================

  @override
  void initState() {
    super.initState();

    _loadBannerAd();

    _razorpay = Razorpay();

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_SUCCESS,
      _handlePaymentSuccess,
    );

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_ERROR,
      _handlePaymentError,
    );

    _razorpay.on(
      Razorpay.EVENT_EXTERNAL_WALLET,
      _handleExternalWallet,
    );

    if (controller.isSubscriptionActive) {
      _playSuccessSound();
    }
  }

  // ============================================================
  // SUCCESS SOUND
  // ============================================================

  void _playSuccessSound() async {
    try {
      // If you want success sound later:
      //
      // await _audioPlayer.play(
      //   AssetSource('audio/success-221935.mp3'),
      // );
    } catch (e) {
      debugPrint(
        "Error playing success sound: $e",
      );
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _bannerAd?.dispose();

    _razorpay.clear();

    _audioPlayer.dispose();

    super.dispose();
  }

  // ============================================================
  // PAYMENT SUCCESS
  // ============================================================

  void _handlePaymentSuccess(
    PaymentSuccessResponse response,
  ) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(
          color: primaryDark,
        ),
      ),
      barrierDismissible: false,
    );

    try {
      final result = await _apiService.verifyOnlinePayment(
        response.paymentId!,
        response.orderId ?? "online_${DateTime.now().millisecondsSinceEpoch}",
      );

      if (Get.isDialogOpen == true) {
        Get.back();
      }

      if (result['success'] == true) {
        _playSuccessSound();

        await controller.fetchUserProfile();

        Get.snackbar(
          "Payment Successful",
          "Your mess subscription is now active.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: secondaryDark,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 16,
          icon: const Icon(
            Icons.check_circle_rounded,
            color: Colors.white,
          ),
        );
      } else {
        Get.snackbar(
          "Account Update Failed",
          "Payment was successful, but we could not update your subscription. Please contact the administrator.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade500,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 16,
        );
      }
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      Get.snackbar(
        "Verification Failed",
        "We could not verify your payment. Please contact the administrator.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade500,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
      );
    }
  }

  // ============================================================
  // PAYMENT ERROR
  // ============================================================

  void _handlePaymentError(
    PaymentFailureResponse response,
  ) {
    Get.snackbar(
      "Payment Failed",
      response.message ?? "The transaction was cancelled. Please try again.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade500,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      icon: const Icon(
        Icons.error_outline_rounded,
        color: Colors.white,
      ),
    );
  }

  // ============================================================
  // EXTERNAL WALLET
  // ============================================================

  void _handleExternalWallet(
    ExternalWalletResponse response,
  ) {
    debugPrint(
      "External wallet selected: ${response.walletName}",
    );
  }

  // ============================================================
  // OPEN RAZORPAY
  // ============================================================

  void _openCheckout() {
    var options = {
      // IMPORTANT:
      // Keep your existing Razorpay key here.
      'key': 'YOUR_RAZORPAY_KEY',

      // ₹4,080 = 408000 paise
      'amount': razorpayAmount,

      'name': 'Chef Hospitality',

      'description': 'Monthly Mess Subscription - ₹4,000 + 2% GST',

      'prefill': {
        'contact': controller.user.value.phonenumber,
        'email': controller.user.value.email,
      },

      'theme': {
        'color': '#FADD73',
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(
        "Razorpay error: $e",
      );

      Get.snackbar(
        "Payment Error",
        "Unable to open payment gateway. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade500,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
      );
    }
  }

  // ============================================================
  // LOAD BANNER AD
  // ============================================================

  void _loadBannerAd() {
    if (kIsWeb) {
      return;
    }

    _bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isBannerAdLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint(
            'Subscription Banner Ad failed: $error',
          );

          ad.dispose();
        },
      ),
    )..load();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        toolbarHeight: 68,
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 68,
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            top: 7,
            bottom: 7,
          ),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => Get.back(),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: darkTextColor,
                size: 18,
              ),
            ),
          ),
        ),
        title: Text(
          "Subscription",
          style: GoogleFonts.poppins(
            color: darkTextColor,
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 16,
              top: 7,
              bottom: 7,
            ),
            child: Material(
              color: primaryLight,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  Get.to(
                    () => const PaymentHistoryScreen(),
                  );
                },
                child: const SizedBox(
                  height: 46,
                  width: 46,
                  child: Icon(
                    Icons.receipt_long_rounded,
                    color: primaryDark,
                    size: 21,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: Obx(() {
        final bool isActive = controller.isSubscriptionActive;

        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                color: primaryDark,
                backgroundColor: Colors.white,
                onRefresh: () => controller.fetchUserProfile(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    6,
                    16,
                    24,
                  ),
                  child: Column(
                    children: [
                      // ========================================
                      // SMALL HEADER
                      // ========================================

                      _buildHeader(isActive),

                      const SizedBox(height: 16),

                      // ========================================
                      // PAYMENT / ACTIVE CARD
                      // ========================================

                      if (isActive) _buildNoDueUI() else _buildPaymentUI(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // ================================================
            // ADMOB BANNER
            // ================================================

            if (!kIsWeb)
              Container(
                height: 50,
                width: double.infinity,
                color: _isBannerAdLoaded
                    ? Colors.transparent
                    : Colors.grey.shade50,
                child: _isBannerAdLoaded && _bannerAd != null
                    ? AdWidget(
                        ad: _bannerAd!,
                      )
                    : Center(
                        child: Text(
                          "Loading Ad...",
                          style: GoogleFonts.poppins(
                            color: lightTextColor,
                            fontSize: 9,
                          ),
                        ),
                      ),
              ),
          ],
        );
      }),
    );
  }

  // ============================================================
  // SMALL MODERN HEADER
  // ============================================================

  Widget _buildHeader(bool isActive) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 15,
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
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.20),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // ICON
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.65),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.restaurant_menu_rounded,
              color: darkTextColor,
              size: 24,
            ),
          ),

          const SizedBox(width: 12),

          // TITLE
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Monthly Mess Plan",
                  style: GoogleFonts.poppins(
                    color: darkTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isActive
                      ? "Your subscription is active"
                      : "Ghar ka khana, every day",
                  style: GoogleFonts.poppins(
                    color: darkTextColor.withOpacity(0.60),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // STATUS
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: isActive ? secondaryLight : Colors.white.withOpacity(0.65),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isActive
                  ? Icons.verified_rounded
                  : Icons.workspace_premium_rounded,
              color: isActive ? secondaryDark : primaryDark,
              size: 21,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PAYMENT UI
  // ============================================================

  Widget _buildPaymentUI() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFF0F0EA),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // ==================================================
          // PLAN TITLE
          // ==================================================

          Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: primaryLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.restaurant_rounded,
                  color: primaryDark,
                  size: 21,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Monthly Subscription",
                      style: GoogleFonts.poppins(
                        color: darkTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      "Complete monthly meal access",
                      style: GoogleFonts.poppins(
                        color: lightTextColor,
                        fontSize: 9.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: secondaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "MONTHLY",
                  style: GoogleFonts.poppins(
                    color: secondaryDark,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ==================================================
          // PRICE IN CENTER
          // ==================================================

          Text(
            "Monthly Fee",
            style: GoogleFonts.poppins(
              color: lightTextColor,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 1),

          Text(
            "₹4,000",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: darkTextColor,
              fontSize: 38,
              height: 1.2,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.3,
            ),
          ),

          const SizedBox(height: 5),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "+ 2% GST",
              style: GoogleFonts.poppins(
                color: primaryDark,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 18),

          // ==================================================
          // PRICE BREAKDOWN
          // ==================================================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAF8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _priceRow(
                  "Mess subscription",
                  "₹4,000",
                ),
                const SizedBox(height: 8),
                _priceRow(
                  "GST (2%)",
                  "₹80",
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Divider(
                    height: 1,
                    color: Color(0xFFEAEAE5),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Total Payable",
                      style: GoogleFonts.poppins(
                        color: darkTextColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "₹4,080",
                      style: GoogleFonts.poppins(
                        color: darkTextColor,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ==================================================
          // PAY BUTTON
          // ==================================================

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _openCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: darkTextColor,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Pay ₹4,080",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 11),

          // ==================================================
          // SECURE PAYMENT
          // ==================================================

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.verified_user_outlined,
                color: secondaryDark,
                size: 14,
              ),
              const SizedBox(width: 5),
              Text(
                "Secure online payment",
                style: GoogleFonts.poppins(
                  color: lightTextColor,
                  fontSize: 9.5,
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
  // ACTIVE SUBSCRIPTION UI
  // ============================================================

  Widget _buildNoDueUI() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        22,
        28,
        22,
        26,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: secondaryColor.withOpacity(0.60),
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
        children: [
          // CHECK ICON
          Container(
            height: 88,
            width: 88,
            decoration: BoxDecoration(
              color: secondaryLight,
              shape: BoxShape.circle,
              border: Border.all(
                color: secondaryColor,
                width: 4,
              ),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: secondaryDark,
              size: 45,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "You're all set! 🎉",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: darkTextColor,
              fontSize: 21,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            "No dues this month",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: secondaryDark,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            "Your meal subscription is active. You can generate your meal tokens normally.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: lightTextColor,
              fontSize: 11,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 22),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: secondaryLight,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.verified_user_outlined,
                  color: secondaryDark,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Meal token access enabled",
                    style: GoogleFonts.poppins(
                      color: secondaryDark,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(
                  Icons.check_circle_rounded,
                  color: secondaryDark,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRICE ROW
  // ============================================================

  Widget _priceRow(
    String title,
    String price,
  ) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: lightTextColor,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          price,
          style: GoogleFonts.poppins(
            color: darkTextColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
