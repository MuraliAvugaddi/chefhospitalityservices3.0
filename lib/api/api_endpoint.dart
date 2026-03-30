// class ApiEndpoints {
//   // --- ✅ BASE CONFIGURATION ---
//   // Use this IP for physical devices connected to the same Wi-Fi.
//   // Find it by running `ipconfig` (Windows) or `ifconfig` (Mac/Linux) in your terminal.
//   static const String _ipAddress = "10.13.66.247"; // <-- Your computer's IP
//   static const String _port = "5000";
//   static const String _base = "http://$_ipAddress:$_port/api";

//   // --- ✅ SOCKET URL ---
//   static const String socketUrl = "http://$_ipAddress:$_port";

//   // --- ✅ AUTH ENDPOINTS ---
//   static const String authBaseUrl = "$_base/auth";
//   static const String signupStep1 = "$authBaseUrl/signup/1";
//   static const String signupStep2 = "$authBaseUrl/signup/2";
//   static const String signinpage = "$authBaseUrl/signin";

//   // --- ✅ PROFILE ENDPOINTS ---
//   static const String userProfile = "$_base/profile";

//   // --- ✅ TOKEN ENDPOINTS (NEW) ---
//   static const String tokenBaseUrl = "$_base/tokens";
//   static const String generateToken = "$tokenBaseUrl/generate";
//   static const String todayStats = "$tokenBaseUrl/stats/today";

//   // ✅ Fixed Skip Endpoints (Matching the Service)
//   static const String skipToggle = "$_base/skip/toggle";
//   static const String skipCheck = "$_base/skip/check";
// }

class ApiEndpoints {
  static const String _base =
      "https://chefhospitality-backend-main.onrender.com/api";

  // --- ✅ SOCKET URL ---
  static const String socketUrl =
      "https://chefhospitality-backend-main.onrender.com";

  // --- ✅ AUTH ENDPOINTS ---
  static const String authBaseUrl = "$_base/auth";
  static const String signupStep1 = "$authBaseUrl/signup/1";
  static const String signupStep2 = "$authBaseUrl/signup/2";
  static const String signinpage = "$authBaseUrl/signin";

  // --- ✅ PROFILE ENDPOINTS ---
  static const String userProfile = "$_base/profile";

  // --- ✅ TOKEN ENDPOINTS ---
  static const String tokenBaseUrl = "$_base/tokens";
  static const String generateToken = "$tokenBaseUrl/generate";
  static const String todayStats = "$tokenBaseUrl/stats/today";
}
