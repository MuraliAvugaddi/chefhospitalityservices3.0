// lib/Screens/history_screen.dart
import 'package:chefhospitalityservices/widgets/history_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Controllers/history_controller.dart';


class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  // Initialize the controller
  final HistoryController hController = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FA),
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("My Meal History", 
          style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (hController.isLoading.value && hController.historyList.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Color(0xffFFC800)));
        }

        return RefreshIndicator(
          onRefresh: () => hController.fetchInitialHistory(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // 1. Stats Summary Header
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xffFFC800), Color(0xffFADD73)]),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat("Total Tokens", "${hController.historyList.length}"),
                      Container(width: 1, height: 40, color: Colors.black12),
                      _buildStat("Status", "Active"),
                    ],
                  ),
                ),
              ),

              // 2. The History List
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: hController.historyList.isEmpty
                    ? const SliverToBoxAdapter(child: Center(child: Text("No meals found yet.")))
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            // Check for end of list to load more
                            if (index == hController.historyList.length - 1 && hController.hasMoreData.value) {
                              hController.fetchMoreHistory();
                            }

                            final item = hController.historyList[index];
                            return HistoryTile(
                              mealType: item['mealType'],
                              tokenNumber: item['tokenNumber'].toString(),
                              date: DateTime.parse(item['generatedAt']),
                            );
                          },
                          childCount: hController.historyList.length,
                        ),
                      ),
              ),
              
              // 3. Bottom Loader
              if (hController.hasMoreData.value)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }
}