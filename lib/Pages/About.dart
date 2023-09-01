import 'package:flutter/material.dart';
import 'package:wink30/utils/MyColors.dart';
import 'package:google_fonts/google_fonts.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.bgColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: MyColors.bgColor,
        title: const Text(
          "About",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                      fit: BoxFit.cover,
                      width: double.infinity,
                      "assets/images/about.png")),
              const SizedBox(height: 20),
              const Text(
                "ABOUT US",
                style: TextStyle(
                    color: MyColors.primaryColor, fontWeight: FontWeight.w700),
              ),
              const Text(
                "Empowering People By Keeping Them Well",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 40),
              ),
              Text(
                "Our unique Smart Tools and powerful Wave Count Scanner help identify potential trading opportunities with clearly-defined risk, and unlock keys to price pattern-based risk management, all in real timeWith our Whether you trade stocks, forex, futures, cryptocurrencies or other, wink30bot will help you make smarter trading decisions and take control of your trading.",
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
