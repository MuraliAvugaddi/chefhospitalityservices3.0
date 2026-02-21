import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../Controllers/MealSkipController.dart'; // ✅ Ensure this path is correct

class MealSkippingscreen extends StatefulWidget {
  const MealSkippingscreen({super.key});

  @override
  State<MealSkippingscreen> createState() => _MealSkippingscreenState();
}

class _MealSkippingscreenState extends State<MealSkippingscreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ✅ Initialize the Controller to manage state and logic
  final MealSkipController controller = Get.put(MealSkipController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FA),
      appBar: AppBar(
        title: Text("Meal Management",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: const Color(0xffFADD73),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          indicatorColor: Colors.black,
          tabs: const [Tab(text: "Schedule Skip"), Tab(text: "My History")],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildScheduleTab(), _buildHistoryTab()],
      ),
    );
  }

  // --- 1. SCHEDULE TAB ---
  Widget _buildScheduleTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("1. Select Date"),
          const SizedBox(height: 10),
          _datePickerCard(),
          const SizedBox(height: 25),
          _sectionTitle("2. Select Meal Type"),
          const SizedBox(height: 10),
          _mealTypeGrid(),
          const SizedBox(height: 40),

          // ✅ Submit Button connected to Controller state
          Obx(() => SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.submitSkip(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Confirm Skipping",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                ),
              )),

          const SizedBox(height: 20),
          const Text(
              "Note: Skips for tomorrow must be submitted before 11:00 PM tonight.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _datePickerCard() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
            context: context,
            initialDate: controller.selectedDate.value,
            firstDate: DateTime.now().add(const Duration(days: 1)),
            lastDate: DateTime.now().add(const Duration(days: 30)));
        if (date != null) controller.selectedDate.value = date;
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xffFADD73), width: 2)),
        child: Row(
          children: [
            const Icon(Icons.calendar_month, color: Color(0xffFADD73)),
            const SizedBox(width: 15),
            Obx(() => Text(
                DateFormat('EEEE, dd MMMM yyyy')
                    .format(controller.selectedDate.value),
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600))),
          ],
        ),
      ),
    );
  }

  Widget _mealTypeGrid() {
    List<String> options = [
      "Breakfast",
      "Lunch",
      "Snacks",
      "Dinner",
      "Full Day"
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((m) {
        return Obx(() {
          bool isSel = controller.selectedMeal.value == m;
          return ChoiceChip(
            label: Text(m),
            selected: isSel,
            onSelected: (v) => controller.selectedMeal.value = m,
            selectedColor: const Color(0xffFADD73),
            backgroundColor: Colors.white,
          );
        });
      }).toList(),
    );
  }

  // --- 2. HISTORY TAB WITH DASHBOARD ---
  Widget _buildHistoryTab() {
    return Obx(() {
      if (controller.isLoading.value && controller.historyList.isEmpty) {
        return const Center(
            child: CircularProgressIndicator(color: Color(0xffFFC800)));
      }

      return Column(
        children: [
          // ✅ NEW: User Personal Savings Dashboard
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xff1A1A1A), // Sleek Modern Dark
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5))
              ],
            ),
            child: Column(
              children: [
                Text("Your Saved Meals This Month",
                    style: GoogleFonts.poppins(
                        color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _miniStat("B", controller.getHistoryCount("Breakfast")),
                    _miniStat("L", controller.getHistoryCount("Lunch")),
                    _miniStat("S", controller.getHistoryCount("Snacks")),
                    _miniStat("D", controller.getHistoryCount("Dinner")),
                    _miniStat("Total", controller.totalHistorySkips),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: controller.historyList.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.historyList.length,
                    itemBuilder: (context, index) {
                      final skip = controller.historyList[index];
                      return _buildSkipHistoryCard(skip);
                    },
                  ),
          ),
        ],
      );
    });
  }

  Widget _miniStat(String label, int count) {
    return Column(
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                color: const Color(0xffFADD73),
                fontWeight: FontWeight.bold,
                fontSize: 12)),
        const SizedBox(height: 4),
        Text("$count",
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSkipHistoryCard(dynamic skip) {
    IconData mealIcon;
    Color iconColor;
    Color bgColor;

    // Use a helper to determine UI styling based on meal type
    switch (skip['mealType']) {
      case 'Breakfast':
        mealIcon = Icons.wb_sunny_outlined;
        iconColor = Colors.orange;
        bgColor = Colors.orange.shade50;
        break;
      case 'Lunch':
        mealIcon = Icons.restaurant;
        iconColor = Colors.green;
        bgColor = Colors.green.shade50;
        break;
      case 'Snacks':
        mealIcon = Icons.bakery_dining_outlined;
        iconColor = Colors.blue;
        bgColor = Colors.blue.shade50;
        break;
      case 'Dinner':
        mealIcon = Icons.nightlight_round;
        iconColor = Colors.indigo;
        bgColor = Colors.indigo.shade50;
        break;
      default:
        mealIcon = Icons.event_available;
        iconColor = Colors.red;
        bgColor = Colors.red.shade50;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 5,
              offset: const Offset(0, 2))
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
          child: Icon(mealIcon, color: iconColor, size: 24),
        ),
        title: Text("${skip['mealType']} Skipped",
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: Row(
          children: [
            const Icon(Icons.calendar_today_outlined,
                size: 12, color: Colors.grey),
            const SizedBox(width: 5),
            Text(skip['date'],
                style:
                    GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
        trailing: Text(
          skip['month'].toString().split(' ')[0],
          style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400]),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.no_meals_outlined, size: 80, color: Colors.grey[300]),
        const SizedBox(height: 16),
        Text("No skipped meals found.",
            style: GoogleFonts.poppins(color: Colors.grey[500])),
      ],
    );
  }

  Widget _sectionTitle(String text) => Text(text,
      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold));
}
