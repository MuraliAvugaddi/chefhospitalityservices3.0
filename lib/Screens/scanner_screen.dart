import 'package:chefhospitalityservices/Screens/token_screen.dart';
import 'package:chefhospitalityservices/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // ✅ NEW: Import ads

class ScannerScreen extends StatefulWidget {
  final String mealType;
  const ScannerScreen({Key? key, required this.mealType}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _isScanComplete = false;
  final ApiService _apiService = ApiService();

  // --- ✅ NEW: Ad-related variables ---
  BannerAd? _topBannerAd;
  bool _isTopBannerLoaded = false;
  BannerAd? _bottomBannerAd;
  bool _isBottomBannerLoaded = false;

  // Using Google's official Test Ad IDs
  final String _androidAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  final String _iosAdUnitId = 'ca-app-pub-3940256099942544/2934735716';
  // --- End of Ad-related variables ---

  // --- TIME VALIDATION LOGIC (Unchanged) ---
  bool isTimeValidForMeal() {
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute;
    final currentTimeInMinutes = hour * 60 + minute;

    switch (widget.mealType) {
      // case "Breakfast":
      //   return currentTimeInMinutes >= (7 * 60 + 50) &&
      //       currentTimeInMinutes <= (9 * 60 + 10);
      // case "Lunch":
      //   return currentTimeInMinutes >= (11 * 60 + 50) &&
      //       currentTimeInMinutes <= (14 * 60 + 10);
      // case "Snacks":
      //   return currentTimeInMinutes >= (16 * 60 + 50) &&
      //       currentTimeInMinutes <= (18 * 60 + 10);
      // case "Dinner":
      //   return currentTimeInMinutes >= (19 * 60 + 50) &&
      //       currentTimeInMinutes <= (21 * 60 + 30);
      case "Breakfast":
        return currentTimeInMinutes >= (00 * 60 + 00) &&
            currentTimeInMinutes <= (24 * 60 + 00);

      // case "Lunch":
      //   return currentTimeInMinutes >= (11 * 60 + 50) &&
      //       currentTimeInMinutes <= (14 * 60 + 10);
      // case "Snacks":
      //   return currentTimeInMinutes >= (16 * 60 + 50) &&
      //       currentTimeInMinutes <= (18 * 60 + 10);
      // case "Dinner":
      //   return currentTimeInMinutes >= (19 * 60 + 50) &&
      //       currentTimeInMinutes <= (21 * 60 + 30);

      case "Lunch":
        return currentTimeInMinutes >= (00 * 60 + 00) &&
            currentTimeInMinutes <= (24 * 60 + 00);
      case "Snacks":
        return currentTimeInMinutes >= (00 * 60 + 00) &&
            currentTimeInMinutes <= (24 * 60 + 00);
      case "Dinner":
        return currentTimeInMinutes >= (00 * 60 + 00) &&
            currentTimeInMinutes <= (24 * 60 + 00);
      default:
        return false;
    }
  }

  @override
  void initState() {
    super.initState();
    // ✅ NEW: Load both ads
    _loadTopBannerAd();
    _loadBottomBannerAd();
  }

  // --- ✅ NEW: Ad loading functions ---
  void _loadTopBannerAd() {
    String adUnitId = Platform.isAndroid ? _androidAdUnitId : _iosAdUnitId;
    _topBannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isTopBannerLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Top BannerAd failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  void _loadBottomBannerAd() {
    String adUnitId = Platform.isAndroid ? _androidAdUnitId : _iosAdUnitId;
    _bottomBannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBottomBannerLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Bottom BannerAd failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
  }
  // --- End of ad loading functions ---

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      if (Platform.isAndroid) {
        controller!.pauseCamera();
      }
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (_isScanComplete) return;

      if (scanData.code == 'ACIKgwq4WrEncscjBbVRbA') {
        setState(() {
          _isScanComplete = true;
        });
        controller.pauseCamera();
        _generateToken();
      } else {
        controller.pauseCamera();
        Get.snackbar(
          'Invalid QR Code',
          'This is not a valid mess QR code.',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        Future.delayed(const Duration(seconds: 2), () {
          controller.resumeCamera();
        });
      }
    });
  }

  Future<void> _generateToken() async {
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Color(0xffFFC800))),
      barrierDismissible: false,
    );
    final result = await _apiService.generateToken(widget.mealType);
    Get.back();

    if (result['success'] == true) {
      Get.off(
        () => TokenScreen(
          mealType: result['token']['mealType'],
          tokenNumber: result['token']['tokenNumber'].toString(),
          generatedAt: result['token']['generatedAt'],
        ),
      );
    } else {
      Get.snackbar(
        'Token Generation Failed',
        result['message'] ?? 'An unknown error occurred.',
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
        colorText: Colors.white,
      );
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isScanComplete = false;
        });
        controller?.resumeCamera();
      });
    }
  }

  // ✅ CHANGED: Helper widget for building the ad container
  Widget _buildAdContainer(BannerAd? ad, bool isLoaded) {
    return Container(
      alignment: Alignment.center,
      height: 50.0,
      width: double.infinity,
      // ✅ CHANGED: Placeholder is now transparent
      color: Colors.transparent,
      child: isLoaded
          ? AdWidget(ad: ad!)
          : Container(), // ✅ CHANGED: Show an empty container
    );
  }

  @override
  Widget build(BuildContext context) {
    // --- ✅ MODIFIED BUILD PATH 1: Time Invalid Screen ---
    if (!isTimeValidForMeal()) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            '${widget.mealType} Token',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          backgroundColor: Color(0xffFADD73),
        ),
        // ✅ CHANGED: Body is now a Column to hold ads and content
        body: Column(
          children: [
            // ✅ TOP AD
            _buildAdContainer(_topBannerAd, _isTopBannerLoaded),

            // ✅ CONTENT (Original body wrapped in Expanded)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: Image.asset(
                        "assets/images/timeout-3d.webp",
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          'Sorry, the window for generating a ${widget.mealType} token is currently closed.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: const Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ✅ BOTTOM AD
            _buildAdContainer(_bottomBannerAd, _isBottomBannerLoaded),
          ],
        ),
      );
    }

    // --- ✅ MODIFIED BUILD PATH 2: QR Scanner Screen ---
    return Scaffold(
      // ✅ CHANGED: Set background to black to match camera feed
      backgroundColor: Colors.black,
      // ✅ CHANGED: Body is now a Column to hold ads and scanner
      body: Column(
        children: <Widget>[
          // ✅ TOP AD
          // We use SafeArea here to avoid the status bar,
          // but only for the top ad container
          SafeArea(
            bottom: false, // Don't apply padding to the bottom
            child: _buildAdContainer(_topBannerAd, _isTopBannerLoaded),
          ),

          // ✅ CONTENT (Original Stack wrapped in Expanded)
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: Colors.teal,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: 300,
                  ),
                ),
                Positioned(
                  top: 60,
                  child: Text(
                    'Scan Mess QR for ${widget.mealType}',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 60,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Align QR code within the frame',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ✅ BOTTOM AD
          // We use SafeArea here to avoid the home bar (on iOS)
          // but only for the bottom ad container
          SafeArea(
            top: false, // Don't apply padding to the top
            child: _buildAdContainer(_bottomBannerAd, _isBottomBannerLoaded),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    // ✅ NEW: Dispose both ads
    _topBannerAd?.dispose();
    _bottomBannerAd?.dispose();
    super.dispose();
  }
}
