// ignore_for_file: depend_on_referenced_packages, file_names

import 'package:flutter/material.dart';
import 'package:wink30/utils/MyColors.dart';
import 'package:google_fonts/google_fonts.dart';

class ATMCard extends StatelessWidget {
  final String name;
  final String image;

  const ATMCard({
    super.key,
    required this.name,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.5, // Adjust opacity here
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10) // Adjust color here
                    ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      width: 50,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.shopping_cart_outlined,
                              color: MyColors.cardText,
                              size: 18,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              width: 1,
                              height: 16,
                              color: MyColors.cardText,
                            ),
                            const Icon(
                              Icons.flight,
                              color: MyColors.cardText,
                              size: 18,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              width: 1,
                              height: 16,
                              color: MyColors.cardText,
                            ),
                            const Icon(
                              Icons.train_outlined,
                              color: MyColors.cardText,
                              size: 18,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              width: 1,
                              height: 16,
                              color: MyColors.cardText,
                            ),
                            const Icon(
                              Icons.video_camera_back,
                              color: MyColors.cardText,
                              size: 18,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              width: 1,
                              height: 16,
                              color: MyColors.cardText,
                            ),
                            const Icon(
                              Icons.local_dining_outlined,
                              color: MyColors.cardText,
                              size: 18,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          name,
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: MyColors.cardText),
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerRight,
                  child: Transform.rotate(
                      angle: 190,
                      child: const Icon(
                        Icons.wifi,
                        color: MyColors.cardText,
                        size: 25,
                      )),
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(
                        "assets/images/chip.png",
                        width: 40,
                      ),
                    )),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "1234",
                      style: GoogleFonts.lato(
                          color: MyColors.cardText,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          fontSize: 20),
                    ),
                    Text(
                      "x x x x",
                      style: GoogleFonts.lato(
                          color: MyColors.cardText,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Text(
                      "x x x x",
                      style: GoogleFonts.lato(
                          color: MyColors.cardText,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Text(
                      "1121",
                      style: GoogleFonts.lato(
                          color: MyColors.cardText,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "JOHN H. SMITH",
                      style: TextStyle(
                          color: MyColors.cardText,
                          fontSize: 18,
                          fontWeight: FontWeight.w900),
                    ),
                    Text(
                      "09/29",
                      style: TextStyle(
                          color: MyColors.cardText,
                          fontSize: 18,
                          fontWeight: FontWeight.w900),
                    )
                  ],
                )
              ],
            ),
          ),
        ]));
  }
}
