import 'package:chefhospitalityservices/Screens/Navigation_bar/splashScreen.dart';
import 'package:chefhospitalityservices/Screens/Navigation_bar/new_main_screen.dart'; // Ensure this path is correct
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  // 1. Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize GetStorage for local data persistence
  await GetStorage.init();

  // 3. Mobile Ads Configuration
  RequestConfiguration configuration = RequestConfiguration(
    testDeviceIds: ["11D47A979A88E7802ABEC44384052E3F"],
  );
  MobileAds.instance.updateRequestConfiguration(configuration);

  // 4. Initialize the Mobile Ads SDK
  MobileAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the storage box
    final box = GetStorage();

    // Read the stored token
    final String? token = box.read('token');

    return GetMaterialApp(
      title: 'Chef Hospitality',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      /* ✅ THE CRITICAL FIX: 
      If the token exists (the user is already logged in), we go straight to MainScreen.
      If the token is null, we show the SplashScreen/Onboarding.
      */
      home: token != null ? const MainScreen() : const SplashScreen(),
    );
  }
}
