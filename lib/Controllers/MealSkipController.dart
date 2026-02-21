import 'package:flutter/material.dart'; // ✅ Required for Colors in snackbar
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class MealSkipController extends GetxController {
  final ApiService _apiService = ApiService();

  var historyList = <dynamic>[].obs;
  var isLoading = false.obs;

  var selectedDate = DateTime.now().add(const Duration(days: 1)).obs;
  var selectedMeal = "Full Day".obs;

  @override
  void onInit() {
    super.onInit();
    fetchMySkipHistory();
  }

  // ✅ NEW: Helper methods to calculate history breakdown for the UI
  int getHistoryCount(String type) {
    return historyList.where((item) => item['mealType'] == type).length;
  }

  int get totalHistorySkips => historyList.length;

  // --- SUBMIT SKIP LOGIC ---
  Future<void> submitSkip() async {
    try {
      isLoading(true);
      final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate.value);
      
      // Explicitly cast the response to Map for type safety
      final Map<String, dynamic> res = await _apiService.submitMealSkip(dateStr, selectedMeal.value) as Map<String, dynamic>;
      
      if (res['success'] == true) {
        Get.snackbar(
          "Success", 
          res['message']?.toString() ?? "Meal skipped successfully", 
          backgroundColor: Colors.green, 
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        fetchMySkipHistory(); // Refresh the history tab automatically
      } else {
        Get.snackbar(
          "Action Denied", 
          res['message']?.toString() ?? "Failed to skip meal", 
          backgroundColor: Colors.red, 
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong connecting to server", backgroundColor: Colors.orange);
    } finally {
      isLoading(false);
    }
  }

  // --- FETCH HISTORY LOGIC ---
  Future<void> fetchMySkipHistory() async {
    try {
      isLoading(true);
      
      // Explicitly cast the response to Map for type safety
      final Map<String, dynamic> res = await _apiService.getMySkips() as Map<String, dynamic>;
      
      if (res['success'] == true && res['skips'] != null) {
        historyList.assignAll(res['skips']);
      }
    } catch (e) {
      debugPrint("Error fetching skips: $e");
    } finally {
      isLoading(false);
    }
  }
}