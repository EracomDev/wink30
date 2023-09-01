// ignore_for_file: depend_on_referenced_packages, file_names

import 'package:flutter/material.dart';
import 'package:wink30/utils/MyColors.dart';
import 'package:google_fonts/google_fonts.dart';

class cryptoPackage extends StatelessWidget {
  final String coinName;
  final String totalCoin;
  final String amount;
  final String liveRate;
  final String date;

  const cryptoPackage({
    super.key,
    required this.coinName,
    required this.totalCoin,
    required this.amount,
    required this.liveRate,
    required this.date,
  });
  @override
  Widget build(BuildContext context) {
    final TextStyle packageText = GoogleFonts.lato(
        color: Color.fromARGB(255, 0, 0, 0),
        fontSize: 14,
        fontWeight: FontWeight.bold);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      // padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              // Color.fromARGB(255, 0, 0, 0),
              // Color.fromARGB(132, 248, 171, 5),
              // Color.fromARGB(255, 248, 171, 5)
              MyColors.primaryColor,
              MyColors.primaryColor,
            ],
          ),
          // image: DecorationImage(
          //   image: AssetImage('assets/images/bg4.jpg'),
          //   fit: BoxFit.cover,
          // ),
          color: MyColors.containerColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Stack(children: [
        // Positioned.fill(
        //   top: 0,
        //   child: Opacity(
        //     opacity: 0.3, // Adjust opacity here
        //     child: Container(
        //       decoration: BoxDecoration(
        //           color: Colors.black,
        //           borderRadius: BorderRadius.circular(10) // Adjust color here
        //           ),
        //     ),
        //   ),
        // ),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Coin Name",
                        style: packageText,
                      ),
                      Text(coinName, style: packageText),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Coin Live Rate",
                        style: packageText,
                      ),
                      Text("\$ ${double.parse(liveRate).toStringAsFixed(7)}",
                          style: packageText),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Coin",
                        style: packageText,
                      ),
                      Text(double.parse(totalCoin).toStringAsFixed(7),
                          style: packageText),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Amount",
                        style: packageText,
                      ),
                      Text("\$ $amount", style: packageText),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date",
                        style: packageText,
                      ),
                      Text(date, style: packageText),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ]),
    );
  }
}
