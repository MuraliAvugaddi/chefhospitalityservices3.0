import 'package:chefhospitalityservices/Models/user_model.dart';
import 'package:chefhospitalityservices/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:chefhospitalityservices/services/socket_service.dart';

class ProfileController extends GetxController with WidgetsBindingObserver {
  final box = GetStorage();
  final UserService _userService = UserService();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // A constant "guest" user fallback
  final _guestUser = User(
    gender: " ",
    id: '',
    name: 'Guest',
    email: '',
    enrollmentNo: '',
    course: '',
    year: '',
    phonenumber: '',
    hostelblock: '',
    room: '',
    isApproved: false,
    accessExpiresAt: null, 
  );

  late final Rx<User> user;

  // --- ✨ Subscription Logic ---
  bool get isSubscriptionActive {
    if (user.value.name == 'Guest') return false;
    
    if (user.value.isApproved && user.value.accessExpiresAt != null) {
      return user.value.accessExpiresAt!
          .add(const Duration(minutes: 1))
          .isAfter(DateTime.now());
    }
    return false;
  }

  @override
  void onInit() {
    super.onInit();
    // ✅ Observe app lifecycle to catch updates missed while app was closed
    WidgetsBinding.instance.addObserver(this); 
    
    user = _guestUser.obs;
    loadUserProfileFromStorage();

    // Automatically refresh UI if local storage changes
    box.listenKey('user_data', (storedValue) {
      if (storedValue != null) {
        loadUserProfileFromStorage();
      } else {
        user.value = _guestUser;
      }
    });

    SocketService.instance.connectAndListen();
  }

  @override
  void onReady() {
    super.onReady();
    // ✅ CRITICAL: Perform a silent sync the moment the controller is ready
    fetchUserProfile(showLoading: false);
  }

  // ✅ THIS FIXES THE "APP CLOSED" ISSUE
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint("App Resumed: Forcing silent data sync with server...");
      // Re-fetch latest status from DB and ensure socket is connected
      fetchUserProfile(showLoading: false); 
      SocketService.instance.connectAndListen(); 
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  /// Loads user data from local storage
  void loadUserProfileFromStorage() {
    try {
      final Map<String, dynamic>? userData = box.read('user_data');
      if (userData != null && userData.isNotEmpty) {
        // Support both nested 'user' objects and flat objects
        user.value = User.fromJson(userData.containsKey('user') ? userData['user'] : userData);
      } else {
        user.value = _guestUser;
      }
    } catch (e) {
      user.value = _guestUser;
    }
  }

  /// Called by SocketService for real-time UI updates
  void updateApprovalStatusFromSocket(dynamic data) {
    if (data == null) return;

    bool newStatus = data['isApproved'] ?? false;
    String? newExpiryStr = data['accessExpiresAt'];

    // 1. Update reactive memory
    user.update((val) {
      val!.isApproved = newStatus;
      val.accessExpiresAt = newExpiryStr != null ? DateTime.parse(newExpiryStr) : null;
    });

    // 2. Persist to local storage so it stays correct on next restart
    final Map<String, dynamic>? storedUserData = box.read('user_data');
    if (storedUserData != null) {
      if (storedUserData.containsKey('user')) {
        storedUserData['user']['isApproved'] = newStatus;
        storedUserData['user']['accessExpiresAt'] = newExpiryStr;
      } else {
        storedUserData['isApproved'] = newStatus;
        storedUserData['accessExpiresAt'] = newExpiryStr;
      }
      box.write('user_data', storedUserData);
    }

    // 3. User Feedback
    Get.snackbar(
      "Access Updated",
      newStatus ? "Mess access granted!" : "Access revoked.",
      snackPosition: SnackPosition.TOP,
      backgroundColor: newStatus ? Colors.green : Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  /// Syncs user data with the Backend API
  /// [showLoading] set to false for silent background/lifecycle syncs
  Future<void> fetchUserProfile({bool showLoading = true}) async {
    try {
      if (showLoading) isLoading(true);
      errorMessage('');
      
      User fetchedUser = await _userService.fetchUserProfile();
      
      // Update state and persistent storage
      user.value = fetchedUser;
      final Map<String, dynamic> storedUserData = box.read('user_data') ?? {};
      storedUserData['user'] = fetchedUser.toJson();
      await box.write('user_data', storedUserData);
      
      debugPrint("✅ Profile auto-synced with Server.");
    } catch (e) {
      if (showLoading) {
        final errorMsg = e.toString().replaceAll('Exception: ', '');
        errorMessage(errorMsg);
        Get.snackbar('Sync Error', errorMsg);
      }
      debugPrint("❌ Background sync failed: $e");
    } finally {
      if (showLoading) isLoading(false);
    }
  }
}