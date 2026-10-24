class ApiEndpoints {
  // ============================================================
  // SERVER CONFIGURATION
  // ============================================================

  // 🔹 Local Development (Mac IP on Wi-Fi)
  //static const String serverUrl = 'http://192.168.1.14:5002';

  // 🔹 Android Emulator alternative (uncomment if testing on standard Android Emulator)
  // static const String serverUrl = 'http://10.0.2.2:5002';

  // 🔹 Production Render URL — USE THIS when building the APK for students
  static const String serverUrl = 'https://chefhospitality-backend-main.onrender.com';

  // ============================================================
  // API BASE URL
  // ============================================================

  static const String baseUrl = '$serverUrl/api';

  // ============================================================
  // SOCKET.IO URL
  // ============================================================

  static const String socketUrl = serverUrl;

  // ============================================================
  // AUTH ENDPOINTS
  // ============================================================

  static const String authBaseUrl = '$baseUrl/auth';

  static const String signupStep1 = '$authBaseUrl/signup/1';

  static const String verifyOtp = '$authBaseUrl/signup/verify-otp';

  static const String signupStep2 = '$authBaseUrl/signup/2';

  static const String signinpage = '$authBaseUrl/signin';

  // ============================================================
  // PROFILE ENDPOINTS
  // ============================================================

  static const String userProfile = '$baseUrl/profile';

  // ============================================================
  // FEEDBACK ENDPOINT
  // ============================================================

  // POST /api/feedback
  static const String feedbackSubmit = '$baseUrl/feedback';

  // ✅ FIXED: was '$baseUrl/api/feedback' → became /api/api/feedback
  static const String feedback = '$baseUrl/feedback';

  // ============================================================
  // MENU ENDPOINTS
  // ============================================================

  static const String menuActive = '$baseUrl/menu/active';

  static const String adminUploadMenu = '$baseUrl/admin/menu/upload';

  // ============================================================
  // TOKEN ENDPOINTS
  // ============================================================

  static const String tokenBaseUrl = '$baseUrl/tokens';

  static const String generateToken = '$tokenBaseUrl/generate';

  static const String todayStats = '$tokenBaseUrl/stats/today';

  // ============================================================
  // SKIP ENDPOINTS
  // ============================================================

  static const String skipToggle = '$baseUrl/skip/toggle';

  static const String skipCheck = '$baseUrl/skip/check';

  // ============================================================
  // PASSWORD RESET ENDPOINTS
  // ============================================================

  static const String forgotPassword = '$authBaseUrl/forgot-password';

  static const String resetPassword = '$authBaseUrl/reset-password';

  // ============================================================
  // MESS FEE — UPI QR + SCREENSHOT UPLOAD
  // ============================================================

  static const String paymentConfig = '$baseUrl/payments/config';

  static const String paymentSubmit = '$baseUrl/payments/submit';

  static const String paymentSubmissions = '$baseUrl/payments/my-submissions';

  static const String paymentReceipts = '$baseUrl/payments/my-receipts';

  // ============================================================
  // APP UPDATE CHECK
  // ============================================================

  static const String appVersion = '$baseUrl/app-version';
}
