// ignore_for_file: depend_on_referenced_packages, file_names

import 'package:flutter/material.dart';
import 'package:wink30/utils/MyColors.dart';
import 'package:google_fonts/google_fonts.dart';

class BlogPost extends StatelessWidget {
  final String date;
  final String heading;
  final String subheading;
  final String imagePath;

  const BlogPost({
    super.key,
    required this.date,
    required this.heading,
    required this.subheading,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: MyColors.containerColor,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(imagePath)),
          const SizedBox(height: 10),
          Text(
            date,
            style: GoogleFonts.poppins(fontSize: 13.0, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            heading,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
                color: Colors.white),
          ),
          const SizedBox(height: 8.0),
          Text(
            subheading,
            style: GoogleFonts.poppins(fontSize: 13.0, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
