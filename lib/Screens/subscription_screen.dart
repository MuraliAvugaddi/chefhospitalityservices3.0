import 'package:flutter/foundation.dart'; // ✅ Web safe imports
import 'package:chefhospitalityservices/Controllers/profile_controller.dart';
import 'package:chefhospitalityservices/Screens/Payment_HistoryScreen.dart';
import 'package:chefhospitalityservices/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:audioplayers/audioplayers.dart';

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

  @override
  void initState() {
    super.initState();
    _loadBannerAd();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    if (controller.isSubscriptionActive) {
      _playSuccessSound();
    }
  }

  void _playSuccessSound() async {
    try {
      // await _audioPlayer.play(AssetSource('audio/success-221935.mp3'));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _razorpay.clear();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Get.dialog(
        const Center(
            child: CircularProgressIndicator(color: Color(0xffFFC800))),
        barrierDismissible: false);

    final result = await _apiService.verifyOnlinePayment(response.paymentId!,
        response.orderId ?? "online_${DateTime.now().millisecondsSinceEpoch}");

    Get.back(); // Close loading

    if (result['success'] == true) {
      _playSuccessSound();
      await controller.fetchUserProfile();
      Get.snackbar("Success", "Access granted until month end!",
          backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar("Error", "Account update failed. Please contact Admin.");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar("Payment Failed", response.message ?? "Transaction Cancelled",
        backgroundColor: Colors.red, colorText: Colors.white);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  void _openCheckout() {
    var options = {
      'key': 'YOUR_RAZORPAY_KEY',
      'amount': 380000,
      'name': 'Chef Hospitality',
      'description': 'Monthly Mess Subscription',
      'prefill': {
        'contact': controller.user.value.phonenumber,
        'email': controller.user.value.email
      },
    };
    _razorpay.open(options);
  }

  void _loadBannerAd() {
    // ✅ Completely skip ad loading if running on the Web
    if (kIsWeb) return;

    _bannerAd = BannerAd(
      adUnitId: defaultTargetPlatform == TargetPlatform.android
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => _isBannerAdLoaded = true),
        onAdFailedToLoad: (ad, err) => ad.dispose(),
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: GestureDetector(
              onTap: () => Get.to(() => const PaymentHistoryScreen()),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: const Color(0xffFADD73),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
                ),
                child: const Icon(Icons.receipt_long,
                    color: Color.fromARGB(255, 0, 0, 0), size: 22),
              ),
            ),
          ),
        ],
        title: Obx(() => Text('Hello ${controller.user.value.name}',
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w600,
                fontSize: 22,
                color: Colors.black))),
        backgroundColor: const Color(0xffFADD73),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        bool isActive = controller.isSubscriptionActive;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Ghar ka khana",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xffFFC800),
                            fontSize: 30)),
                    Text("(Subscription Plan)",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500, fontSize: 20)),
                    isActive ? _buildNoDueUI() : _buildPaymentUI(),
                  ],
                ),
              ),
            ),

            // ✅ Hide Ad Container on Web entirely
            if (!kIsWeb)
              Container(
                height: 50,
                color:
                    _isBannerAdLoaded ? Colors.transparent : Colors.grey[100],
                child: _isBannerAdLoaded
                    ? AdWidget(ad: _bannerAd!)
                    : const Center(
                        child: Text("Loading Ad...",
                            style: TextStyle(fontSize: 10))),
              ),
          ],
        );
      }),
    );
  }

  // ✅ Updated responsive UI for Paid Students
  Widget _buildNoDueUI() {
    return Column(
      children: [
        const SizedBox(height: 55),
        Container(
          width: double
              .infinity, // ✅ Makes it stretch across any screen size perfectly
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.greenAccent.withOpacity(0.8)),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF1F9F3), Colors.white],
              stops: [0.0, 0.4],
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment
                .center, // ✅ Forces all inner content to perfectly center
            children: [
              Positioned(
                right: 0,
                top: 0,
                child: Icon(Icons.close,
                    color: Colors.grey.withOpacity(0.9), size: 20),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF00C853),
                      gradient: const RadialGradient(
                        center: Alignment(-0.3, -0.4),
                        colors: [Color(0xFF16E377), Color(0xFF00AD46)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00C853).withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.check_rounded,
                        color: Colors.white, size: 65),
                  ),
                  const SizedBox(height: 35),
                  const Text(
                    "You Have No Dues This Month🎉",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF263238),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    "Your access is active. Enjoy Your delicious meals!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentUI() {
    return Column(
      children: [
        Center(child: Image.asset("assets/images/pay1immage.png", height: 250)),
        const SizedBox(height: 20),
        InkWell(
          onTap: _openCheckout,
          child: Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffFFDB1E), width: 3),
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(colors: [
                Color(0xffFBE15A),
                Color(0xffFDEEB0),
                Color(0xffFBE15A)
              ]),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  CircleAvatar(
                      backgroundColor: const Color(0xffFEEFB8),
                      child:
                          Image.asset("assets/images/money.png", height: 25)),
                  const SizedBox(width: 16),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                        text: "₹3800",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, fontSize: 22)),
                    TextSpan(
                        text: "/Month.",
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: const Color(0xff495E63))),
                  ])),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Text("Pay",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Text("Note: Unlock QR Scanner access instantly after payment.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
