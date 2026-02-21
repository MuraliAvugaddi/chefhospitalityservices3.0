import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../services/special_food_service.dart';

class SpecialFoodController extends GetxController {
  final box = GetStorage();
  var menuItems = <dynamic>[].obs; 
  var cart = <String, int>{}.obs; 
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMenu();
  }

  Future<void> fetchMenu() async {
    try {
      isLoading(true);
      final String? token = box.read('token');
      if (token != null) {
        final List<dynamic> data = await SpecialFoodService.fetchMenu(token);
        menuItems.assignAll(data);
      }
    } finally {
      isLoading(false);
    }
  }

  void addToCart(String productId) {
    cart[productId] = (cart[productId] ?? 0) + 1;
  }

  double get totalAmount {
    double total = 0;
    cart.forEach((id, qty) {
      final item = menuItems.firstWhere((element) => element['_id'] == id, orElse: () => null);
      if (item != null) {
        total += (item['price'] * qty);
      }
    });
    return total;
  }
}