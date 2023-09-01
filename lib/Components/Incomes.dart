// ignore_for_file: depend_on_referenced_packages, file_names

import 'package:flutter/material.dart';
import 'package:wink30/utils/MyColors.dart';
import 'package:google_fonts/google_fonts.dart';

class HeadingWithImage extends StatelessWidget {
  final String currency;
  final String name;
  final String value;
  final String imagePath;

  const HeadingWithImage({
    super.key,
    required this.currency,
    required this.name,
    required this.value,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          color: MyColors.containerColor,
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                      color: Colors.white),
                ),
                const SizedBox(height: 8.0),
                Text(
                  "$currency${double.parse(value).toStringAsFixed(2)}",
                  style:
                      GoogleFonts.poppins(fontSize: 16.0, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16.0),
          Image.asset(
            imagePath,
            width: 100.0,
          ),
        ],
      ),
    );
  }
}
