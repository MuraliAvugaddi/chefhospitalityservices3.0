import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MyChoiceWidget extends StatelessWidget {
  const MyChoiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width; // Get screen width

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: Color(0xffE3E3E3), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "My Choice",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(height: 6),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Note:",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Color(0xff757474),
                      fontSize: 12, // ₹3600 font size
                    ),
                  ),
                  TextSpan(
                    text: " This service is not intended for hostels",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(
                        255,
                        159,
                        159,
                        159,
                      ), //  // Yellow color
                      fontSize: 12, // /Month font size
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () {
                showCupertinoDialog(
                  context: Get.context!,
                  builder: (context) => CupertinoAlertDialog(
                    title: Text(
                      "Sorry",
                      style: TextStyle(color: CupertinoColors.systemRed),
                    ),
                    content: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        " My Choice access opens on verysoon",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    actions: [
                      CupertinoDialogAction(
                        child: Text(
                          "OK",
                          style: TextStyle(color: CupertinoColors.systemRed),
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ],
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Color(0xffE4ADCF),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                      child: Image.asset(
                        "assets/images/breakfast.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Breakfast",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/time.png",
                            height: 18,
                            width: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "8Am - 9Am",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              color: Color(0xff425F2B),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 8,
                        bottom: 8,
                      ),
                      child: Text(
                        "Oder Now",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 2,
              width: double.infinity,
              color: Color(0xffE3E3E3),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                showCupertinoDialog(
                  context: Get.context!,
                  builder: (context) => CupertinoAlertDialog(
                    title: Text(
                      "Sorry",
                      style: TextStyle(color: CupertinoColors.systemRed),
                    ),
                    content: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        " My Choice access opens on verysoon",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    actions: [
                      CupertinoDialogAction(
                        child: Text(
                          "OK",
                          style: TextStyle(color: CupertinoColors.systemRed),
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ],
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Color(0xffB1D8E6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                      child: Image.asset(
                        "assets/images/lunch.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "lunch",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/time.png",
                            height: 18,
                            width: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "12Pm - 2Pm",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              color: Color(0xff425F2B),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 8,
                        bottom: 8,
                      ),
                      child: Text(
                        "Oder Now",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 2,
              width: double.infinity,
              color: Color(0xffE3E3E3),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                showCupertinoDialog(
                  context: Get.context!,
                  builder: (context) => CupertinoAlertDialog(
                    title: Text(
                      "Sorry",
                      style: TextStyle(color: CupertinoColors.systemRed),
                    ),
                    content: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        " My Choice access opens on verysoon",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    actions: [
                      CupertinoDialogAction(
                        child: Text(
                          "OK",
                          style: TextStyle(color: CupertinoColors.systemRed),
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ],
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Color(0xffFFCBA9),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                      child: Image.asset(
                        "assets/images/snakes.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Snacks",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/time.png",
                            height: 18,
                            width: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "5Pm - 6Pm",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              color: Color(0xff425F2B),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 8,
                        bottom: 8,
                      ),
                      child: Text(
                        "Oder Now",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 2,
              width: double.infinity,
              color: Color(0xffE3E3E3),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                showCupertinoDialog(
                  context: Get.context!,
                  builder: (context) => CupertinoAlertDialog(
                    title: Text(
                      "Sorry",
                      style: TextStyle(color: CupertinoColors.systemRed),
                    ),
                    content: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        " My Choice access opens on verysoon",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    actions: [
                      CupertinoDialogAction(
                        child: Text(
                          "OK",
                          style: TextStyle(color: CupertinoColors.systemRed),
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ],
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Color(0xffFCDC67),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                      child: Image.asset(
                        "assets/images/dinner.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dinner",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/time.png",
                            height: 18,
                            width: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "8Pm - 9Pm",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              color: Color(0xff425F2B),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 8,
                        bottom: 8,
                      ),
                      child: Text(
                        "Oder Now",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
