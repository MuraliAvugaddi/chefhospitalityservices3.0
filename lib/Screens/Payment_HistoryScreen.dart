import 'package:chefhospitalityservices/Controllers/UserPaymentController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // For date formatting

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final UserPaymentController controller = Get.put(UserPaymentController());

    return Scaffold(
      backgroundColor: const Color(0xffF8F9FA),
      appBar: AppBar(
        title: Text("My Payment History", 
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black)),
        backgroundColor: const Color(0xffFADD73),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xffFFC800)));
        }

        if (controller.paymentHistory.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text("No payments found yet", 
                  style: GoogleFonts.poppins(color: Colors.grey[500])),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchPaymentHistory,
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.paymentHistory.length,
            itemBuilder: (context, index) {
              final payment = controller.paymentHistory[index];
              final bool isOffline = payment['method'] == 'offline';
              final DateTime paidAt = DateTime.parse(payment['paidAt']).toLocal();

              return Card(
                elevation: 0.5,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Icon Section
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isOffline ? Colors.green[50] : Colors.blue[50],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isOffline ? Icons.payments_outlined : Icons.account_balance_wallet_outlined,
                          color: isOffline ? Colors.green : Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Details Section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isOffline ? "Paid Cash (Admin Approved)" : "Online Payment (Razorpay)",
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Plan: ${payment['month']}",
                              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700]),
                            ),
                            Text(
                              DateFormat('dd MMM yyyy, hh:mm a').format(paidAt),
                              style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[400]),
                            ),
                            if (!isOffline) 
                              Text("Txn ID: ${payment['transactionId'] ?? 'N/A'}",
                                style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          ],
                        ),
                      ),
                      
                      // Amount Section
                      Text(
                        "₹${payment['amount']}",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}