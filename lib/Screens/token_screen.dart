import 'dart:async';
import 'dart:io' show Platform;
import 'package:audioplayers/audioplayers.dart';
import 'package:chefhospitalityservices/Controllers/profile_controller.dart';
import 'package:chefhospitalityservices/Screens/Navigation_bar/new_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';

class TokenScreen extends StatefulWidget {
  final String mealType;
  final String tokenNumber;
  final String generatedAt;

  const TokenScreen({
    super.key,
    required this.mealType,
    required this.tokenNumber,
    required this.generatedAt,
  });

  @override
  State<TokenScreen> createState() => _TokenScreenState();
}

class _TokenScreenState extends State<TokenScreen> {
  final ProfileController controller = Get.find<ProfileController>();
  final AudioPlayer _audioPlayer = AudioPlayer();

  late Timer _timer;
  int _countdown = 30; // 20 second countdown

  // --- AdMob State Variables ---
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;

  // --- Your Production Ad IDs ---
  final String _androidAdUnitId = 'ca-app-pub-6236176751859838/9454234093';
  final String _iosAdUnitId = 'ca-app-pub-6236176751859838/9597704324';

  // --- Test Ad IDs (Use these for testing to avoid account suspension) ---
  // final String _androidAdUnitId = 'ca-app-pub-3940256099942544/2247696110';
  // final String _iosAdUnitId = 'ca-app-pub-3940256099942544/3986624511';

  // Get the correct Ad Unit ID for the platform
  String get _nativeAdUnitId =>
      Platform.isAndroid ? _androidAdUnitId : _iosAdUnitId;
  // --- End AdMob State ---

  @override
  void initState() {
    super.initState();
    _playSound();
    _startTimer();
    _loadAd(); // Load the ad
  }

  // --- ✅ 1. AD LOADING LOGIC ---
  void _loadAd() {
    setState(() {
      _isAdLoaded = false;
    });

    _nativeAd = NativeAd(
      adUnitId: _nativeAdUnitId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          print('✅ Ad loaded.');
          // Ensure the widget is still in the tree before calling setState
          if (mounted) {
            setState(() {
              _isAdLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('❌ Ad failed to load: $error');
          ad.dispose();
        },
      ),

      // --- ⭐️⭐️⭐️ THIS IS THE FIX ⭐️⭐️⭐️ ---
      // This tells the ad to use a pre-built template style,
      // which fixes the crash you were seeing.
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium, // 'medium' is a good size
        // You can customize colors here if you want
        // mainBackgroundColor: Colors.grey.shade200,
        // cornerRadius: 10.0,
      ),
      // --- ⭐️⭐️⭐️ END OF FIX ⭐️⭐️⭐️ ---
    )..load();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Check if mounted before calling setState
      if (mounted) {
        if (_countdown > 0) {
          setState(() {
            _countdown--;
          });
        } else {
          _timer.cancel();
          Get.offAll(() => MainScreen());
        }
      } else {
        // If not mounted, just cancel the timer to prevent memory leaks
        _timer.cancel();
      }
    });
  }

  Future<void> _playSound() async {
    try {
      await _audioPlayer.play(AssetSource('audio/success-221935.mp3'));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _audioPlayer.dispose();
    _nativeAd?.dispose(); // Dispose the ad
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime parsedDate = DateTime.parse(widget.generatedAt);
    final String formattedDate = DateFormat(
      'dd MMMM, hh:mm a',
    ).format(parsedDate);

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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Image.asset(
                  "assets/images/ChatGPT Image Oct 14, 2025, 11_55_22 PM.png",
                  height: 120,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xffFBE156),
                        Color(0xffFEEFB1),
                        Color(0xffFEEFB1),
                        Color(0xffFAE153),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    border: Border.all(
                      color: const Color(0xffF8DE56),
                      width: 4,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.mealType,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '#${widget.tokenNumber}',
                              style: GoogleFonts.poppins(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Image.asset("assets/images/donephoto.png"),
                          ],
                        ),
                        Text(
                          'Your Token Number.',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          formattedDate,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  'Closing $_countdown seconds...',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.red.shade700,
                  ),
                ),

                // --- ✅ 2. AD WIDGET CONTAINER ---
                // This checks if the ad is loaded and displays it.
                if (_nativeAd != null && _isAdLoaded)
                  Container(
                    // Using a Key ensures the widget rebuilds if the ad object changes
                    key: ValueKey(_nativeAd.hashCode),
                    width: double.infinity,
                    // You MUST provide a height constraint for the ad.
                    // 340 is a good height for 'TemplateType.medium'
                    height: 340,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    child: AdWidget(ad: _nativeAd!),
                  )
                else
                  // Placeholder while ad loads
                  Container(
                    height: 340,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    child: const Center(
                      // You can use a CircularProgressIndicator or just text
                      child: Text("Loading ad..."),
                    ),
                  ),
                // --- End Ad Widget Container ---
              ],
            ),
          ),
        ),
      ),
    );
  }
}
