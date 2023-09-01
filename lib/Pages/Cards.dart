// ignore_for_file: depend_on_referenced_packages, file_names

import 'package:flutter/material.dart';
import 'package:wink30/Components/ATMCards.dart';
import 'package:wink30/utils/MyColors.dart';

class Cards extends StatelessWidget {
  const Cards({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.bgColor,
      appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: MyColors.bgColor,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Cards",
            style: TextStyle(color: Colors.white),
          )),
      body: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                ATMCard(name: "PLATINUM CARD", image: "assets/images/atm.png"),
                ATMCard(name: "GOLDS CARD", image: "assets/images/atm.png"),
                ATMCard(name: "SILVER CARD", image: "assets/images/atm.png"),
                ATMCard(name: "BOWNZ CARD", image: "assets/images/atm.png"),
              ],
            )),
      ),
    );
  }
}
