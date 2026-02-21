import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Controllers/special_food_controller.dart';

class SpacelFoodScreen extends StatelessWidget {
  const SpacelFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SpecialFoodController());

    return Scaffold(
      backgroundColor: const Color(0xffF8F9FA),
      appBar: AppBar(
        title: Text("Special Menu",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: const Color(0xffFFC800),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildLeadTimeWarning(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value)
                return const Center(child: CircularProgressIndicator());
              if (controller.menuItems.isEmpty)
                return const Center(child: Text("No items available today."));

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.menuItems.length,
                itemBuilder: (context, index) {
                  final item = controller.menuItems[index];
                  return _buildProductCard(item, controller);
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() => controller.cart.isEmpty
          ? const SizedBox.shrink()
          : _buildCartBar(controller)),
    );
  }

  Widget _buildProductCard(dynamic item, SpecialFoodController controller) {
    String id = item['_id'];
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        title: Text(item['name'],
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("₹${item['price']}"),
        trailing: Obx(() {
          int qty = controller.cart[id] ?? 0;
          return ElevatedButton(
            onPressed: () => controller.addToCart(id),
            style: ElevatedButton.styleFrom(
                backgroundColor: qty > 0 ? Colors.green : Colors.black),
            child: Text(qty > 0 ? "Added ($qty)" : "Add"),
          );
        }),
      ),
    );
  }

  Widget _buildCartBar(SpecialFoodController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () => Get.toNamed('/checkout'),
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffFFC800),
            minimumSize: const Size(double.infinity, 50)),
        child: Text("Checkout ₹${controller.totalAmount.toStringAsFixed(2)}",
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildLeadTimeWarning() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      color: Colors.orange.shade50,
      child: const Text("⚠️ Pre-order at least 3 hours before meal time.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}
