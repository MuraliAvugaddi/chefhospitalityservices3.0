import 'package:chefhospitalityservices/Screens/token_screen.dart';
import 'package:chefhospitalityservices/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:flutter/foundation.dart'; // ✅ FIXED: Replaced dart:io with foundation
import 'package:google_mobile_ads/google_mobile_ads.dart';

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

  // --- Ad-related variables ---
  BannerAd? _topBannerAd;
  bool _isTopBannerLoaded = false;
  BannerAd? _bottomBannerAd;
  bool _isBottomBannerLoaded = false;

  final String _androidAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  final String _iosAdUnitId = 'ca-app-pub-3940256099942544/2934735716';

  // --- TIME VALIDATION LOGIC ---
  bool isTimeValidForMeal() {
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute;
    final currentTimeInMinutes = hour * 60 + minute;

    switch (widget.mealType) {
      case "Breakfast":
        return currentTimeInMinutes >= (00 * 60 + 00) &&
            currentTimeInMinutes <= (24 * 60 + 00);
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
    _loadTopBannerAd();
    _loadBottomBannerAd();
  }

  // --- ✅ FIXED: Ad loading functions made web-safe ---
  void _loadTopBannerAd() {
    if (kIsWeb) return; // Skip ad loading on Web

    String adUnitId = defaultTargetPlatform == TargetPlatform.android
        ? _androidAdUnitId
        : _iosAdUnitId;
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
    if (kIsWeb) return; // Skip ad loading on Web

    String adUnitId = defaultTargetPlatform == TargetPlatform.android
        ? _androidAdUnitId
        : _iosAdUnitId;
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

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      // ✅ FIXED: Prevented crash during hot reload on web
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
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

  Widget _buildAdContainer(BannerAd? ad, bool isLoaded) {
    return Container(
      alignment: Alignment.center,
      height: 50.0,
      width: double.infinity,
      color: Colors.transparent,
      child: isLoaded ? AdWidget(ad: ad!) : Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: const Color(0xffFADD73),
        ),
        body: Column(
          children: [
            // ✅ Hide Ad container completely on web
            if (!kIsWeb) _buildAdContainer(_topBannerAd, _isTopBannerLoaded),

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

            if (!kIsWeb)
              _buildAdContainer(_bottomBannerAd, _isBottomBannerLoaded),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          if (!kIsWeb)
            SafeArea(
              bottom: false,
              child: _buildAdContainer(_topBannerAd, _isTopBannerLoaded),
            ),
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
                      color: Colors.black
                          .withOpacity(0.5), // ✅ Fixed opacity warning
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
          if (!kIsWeb)
            SafeArea(
              top: false,
              child: _buildAdContainer(_bottomBannerAd, _isBottomBannerLoaded),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    _topBannerAd?.dispose();
    _bottomBannerAd?.dispose();
    super.dispose();
  }
}
