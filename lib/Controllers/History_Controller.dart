import 'package:flutter/material.dart';
import '../services/api_service.dart'; 
import 'package:get/get.dart';

class HistoryController extends GetxController {
  final ApiService _apiService = ApiService();
  
  // 1. Initialize the ScrollController
  ScrollController scrollController = ScrollController();

  var historyList = <dynamic>[].obs;
  var isLoading = false.obs;
  
  // 2. FIX: Make sure this variable exists for the UI to see
  var isMoreLoading = false.obs; 
  
  var totalMeals = 0.obs;
  var currentPage = 1.obs;
  var hasMoreData = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitialHistory();
    
    // 3. Setup the scroll listener
    scrollController.addListener(() {
      // Trigger when user is near the bottom
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        fetchMoreHistory();
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose(); // Clean up memory
    super.onClose();
  }

  Future<void> fetchInitialHistory() async {
    try {
      isLoading(true);
      currentPage.value = 1;
      hasMoreData.value = true;

      final response = await _apiService.getUserHistory(currentPage.value);

      if (response['success'] == true) {
        List data = response['history'];
        historyList.assignAll(data);
        totalMeals.value = historyList.length;
        if (data.length < 15) hasMoreData.value = false;
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchMoreHistory() async {
    // Prevent double-loading
    if (!hasMoreData.value || isMoreLoading.value || isLoading.value) return;

    try {
      isMoreLoading(true); // Shows the bottom spinner
      int nextPage = currentPage.value + 1;
      final response = await _apiService.getUserHistory(nextPage);

      if (response['success'] == true) {
        List newItems = response['history'];
        if (newItems.isEmpty) {
          hasMoreData.value = false;
        } else {
          historyList.addAll(newItems);
          currentPage.value = nextPage;
          if (newItems.length < 15) hasMoreData.value = false;
        }
      }
    } finally {
      isMoreLoading(false); // Hides the bottom spinner
    }
  }
}