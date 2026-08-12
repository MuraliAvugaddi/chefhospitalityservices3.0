import 'package:chefhospitalityservices/Controllers/auth_controller.dart';
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
    WidgetsBinding.instance.addObserver(this); 
    
    user = _guestUser.obs;
    loadUserProfileFromStorage();

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
    fetchUserProfile(showLoading: false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint("App Resumed: Forcing silent data sync with server...");
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

    user.update((val) {
      val!.isApproved = newStatus;
      val.accessExpiresAt = newExpiryStr != null ? DateTime.parse(newExpiryStr) : null;
    });

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
  Future<void> fetchUserProfile({bool showLoading = true}) async {
    try {
      if (showLoading) isLoading(true);
      errorMessage('');
      
      User fetchedUser = await _userService.fetchUserProfile();
      
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

  // ============================================================
  // DELETE ACCOUNT METHOD
  // ============================================================
  Future<void> deleteAccount() async {
    try {
      isLoading(true);
      bool isDeleted = await _userService.deleteAccount();

      if (isDeleted) {
        await box.remove('user_data');
        await box.remove('token');
        
        Get.find<SignupController>().logout();
        
        Get.snackbar(
          'Account Deleted',
          'Your account and personal data have been permanently deleted.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        'Deletion Error',
        errorMsg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
}