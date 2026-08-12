// import 'package:chefhospitalityservices/Controllers/profile_controller.dart';
// import 'package:chefhospitalityservices/Screens/auth/onbording_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:google_fonts/google_fonts.dart';
// // ============================================================
//   // DELETE ACCOUNT BUTTON
//   // ============================================================

//   Widget _buildDeleteAccountButton(ProfileController profileController) {
//     return SizedBox(
//       width: double.infinity,
//       height: 52,
//       child: OutlinedButton(
//         onPressed: () {
//           _showDeleteAccountDialog(profileController);
//         },
//         style: OutlinedButton.styleFrom(
//           foregroundColor: Colors.red.shade700,
//           side: BorderSide(
//             color: Colors.red.shade200,
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(18),
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.delete_forever_rounded,
//               color: Colors.red.shade700,
//               size: 21,
//             ),
//             const SizedBox(width: 9),
//             Text(
//               "Delete Account",
//               style: TextStyle(
//                 color: Colors.red.shade700,
//                 fontSize: 15,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // DELETE ACCOUNT CONFIRMATION DIALOG
//   // ============================================================

//   void _showDeleteAccountDialog(ProfileController profileController) {
//     Get.dialog(
//       AlertDialog(
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(24),
//         ),
//         title: const Row(
//           children: [
//             Icon(
//               Icons.warning_amber_rounded,
//               color: Colors.red,
//             ),
//             SizedBox(width: 10),
//             Text(
//               "Delete Account?",
//               style: TextStyle(
//                 color: darkTextColor,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ],
//         ),
//         content: const Text(
//           "This action is permanent and cannot be undone. All your account data and history will be completely erased.",
//           style: TextStyle(
//             color: lightTextColor,
//             fontSize: 14,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Get.back();
//             },
//             child: const Text(
//               "Cancel",
//               style: TextStyle(
//                 color: lightTextColor,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Get.back();
//               profileController.deleteAccount();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red.shade600,
//               foregroundColor: Colors.white,
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text(
//               "Permanently Delete",
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }