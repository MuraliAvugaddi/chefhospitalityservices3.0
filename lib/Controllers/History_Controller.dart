import '../services/api_service.dart'; // <-- double check this path!
import 'package:get/get.dart';

class HistoryController extends GetxController {
  final ApiService _apiService = ApiService();

  var historyList = <dynamic>[].obs;
  var isLoading = false.obs;
  var totalMeals = 0.obs;

  var currentPage = 1.obs;
  var hasMoreData = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitialHistory();
  }

  Future<void> fetchInitialHistory() async {
    try {
      isLoading(true);
      currentPage.value = 1;
      hasMoreData.value = true;

      // Pass the integer value explicitly
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
    if (!hasMoreData.value || isLoading.value) return;

    try {
      isLoading(true);
      int nextPage = currentPage.value + 1;
      final response = await _apiService.getUserHistory(nextPage);

      if (response['success'] == true) {
        List newItems = response['history'];
        if (newItems.isEmpty) {
          hasMoreData.value = false;
        } else {
          historyList.addAll(newItems);
          currentPage.value = nextPage;
        }
      }
    } finally {
      isLoading(false);
    }
  }
}
