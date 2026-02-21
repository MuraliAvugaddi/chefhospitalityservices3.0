import 'package:chefhospitalityservices/Screens/Navigation_bar/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // 1. Import this

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage for local data persistence
  await GetStorage.init();

  // ✅ 2. ADD THIS BLOCK: Set your test device ID from the logs
  RequestConfiguration configuration = RequestConfiguration(
    testDeviceIds: ["11D47A979A88E7802ABEC44384052E3F"],
  );
  MobileAds.instance.updateRequestConfiguration(configuration);

  // 3. Initialize the Mobile Ads SDK
  MobileAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final token = box.read('token');

    return GetMaterialApp(
      title: 'Flutter Auth App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // If token exists, go to home, otherwise go to signup
      //  home: token == null ? SignupStep1Screen() : HomeScreen(),
      // home: token == null ? OnbordingScreen() : MainScreen(),
      home: SplashScreen(),
      // home: token == null ? SplashScreen() : const MainScreen(),
    );
  }
}
