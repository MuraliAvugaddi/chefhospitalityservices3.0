class ApiEndpoints {
  // --- LOCAL DEVELOPMENT BASE CONFIGURATION ---
  static const String baseUrl =   "https://chefhospitality-backend-main.onrender.com/api";

  // --- SOCKET URL ---
  static const String socketUrl =   "https://chefhospitality-backend-main.onrender.com";


  // --- AUTH ENDPOINTS ---
  static const String authBaseUrl = "$baseUrl/auth";
  static const String signupStep1 = "$authBaseUrl/signup/1";
  static const String verifyOtp = "$authBaseUrl/signup/verify-otp";
  static const String signupStep2 = "$authBaseUrl/signup/2";
  static const String signinpage = "$authBaseUrl/signin";

  // --- PROFILE ENDPOINTS ---
  static const String userProfile = "$baseUrl/profile";

  // --- MENU ENDPOINTS ---
  static const String menuActive = "$baseUrl/menu/active";
  static const String adminUploadMenu = "$baseUrl/admin/menu/upload";

  // --- TOKEN ENDPOINTS ---
  static const String tokenBaseUrl = "$baseUrl/tokens";
  static const String generateToken = "$tokenBaseUrl/generate";
  static const String todayStats = "$tokenBaseUrl/stats/today";

  // --- SKIP ENDPOINTS ---
  static const String skipToggle = "$baseUrl/skip/toggle";
  static const String skipCheck = "$baseUrl/skip/check";

  // --- PASSWORD RESET ENDPOINTS ---
  static const String forgotPassword = "$authBaseUrl/forgot-password";
  static const String resetPassword = "$authBaseUrl/reset-password";
}