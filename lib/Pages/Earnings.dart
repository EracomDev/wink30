// ignore_for_file: depend_on_referenced_packages, file_names, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wink30/Components/Incomes.dart';
import 'package:wink30/utils/API.dart';
import 'package:wink30/utils/MyColors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:developer';

class Earnings extends StatefulWidget {
  const Earnings({super.key});

  @override
  State<Earnings> createState() => _EarningsState();
}

class _EarningsState extends State<Earnings> {
  dynamic jsonData;
  bool isLoading = false;
  var dashboardData;
  @override
  void initState() {
    super.initState();
    FetchData();
  }

  Future<void> FetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userid');
    print('token $userId');
    if (!mounted) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(APIPaths.dashboard);
    var body = {'u_id': userId};
    try {
      var response = await http.post(url, body: body);
      print('res $response');
      if (response.statusCode == 200) {
        log('Login successful');
        print('response.body ${response.body}');
        var jsonData = await jsonDecode(response.body.toString());
        log("jkbjkbkg hj ggiuguo gohioh");
        if (jsonData['res'] == "success") {
          if (mounted) {
            setState(() {
              dashboardData = jsonData;
              isLoading = false;
            });
          }
          log('dashboardData $dashboardData');
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

      print('An error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle businessText = GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: const Color.fromARGB(255, 255, 255, 255),
    );
    final TextStyle heading = GoogleFonts.poppins(
        color: MyColors.primaryColor,
        fontSize: 13,
        fontWeight: FontWeight.w500);

    return RefreshIndicator(
      onRefresh: FetchData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              child: isLoading == true
                  ? const Center(
                      child: CircularProgressIndicator(
                      strokeWidth: 1,
                    ))
                  : null,
            ),
            const SizedBox(height: 5),
            Text(
              "Wallets",
              style: heading,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color: MyColors.containerColor,
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Image.asset("assets/images/wallet.png", width: 40),
                        const SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Main Wallet",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              dashboardData?['wallets']['main_wallet'] != null
                                  ? "\$ ${double.parse(dashboardData?['wallets']['main_wallet']).toStringAsFixed(2)}"
                                  : "\$ 0.00",
                              style: const TextStyle(color: Colors.white),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color: MyColors.containerColor,
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Image.asset("assets/images/wallet.png", width: 40),
                        const SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Fund Wallet",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              dashboardData?['wallets']['fund_wallet'] != null
                                  ? "\$ ${double.parse(dashboardData?['wallets']['fund_wallet']).toStringAsFixed(2)}"
                                  : "\$ 0.00",
                              style: const TextStyle(color: Colors.white),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              "Teams",
              style: heading,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color: MyColors.containerColor,
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Active Directs",
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255)),
                            ),
                            const Spacer(),
                            Text(
                              (dashboardData?['teams']['active_directs'])
                                  .toString(),
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              "Inactive Directs",
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255)),
                            ),
                            const Spacer(),
                            Text(
                              (dashboardData?['teams']['inactive_directs'])
                                  .toString(),
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color: MyColors.containerColor,
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Total Directs",
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255)),
                            ),
                            const Spacer(),
                            Text(
                              (dashboardData?['teams']['total_directs'])
                                  .toString(),
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              "Total Generation ",
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255)),
                            ),
                            const Spacer(),
                            Text(
                              (dashboardData?['teams']['total_gen']).toString(),
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              "Incomes",
              style: heading,
            ),
            HeadingWithImage(
              currency: "\$ ",
              name: 'Total Earning',
              value: dashboardData?['total_earning'].toString() ?? "0",
              imagePath: 'assets/images/wave.png',
            ),
            HeadingWithImage(
              currency: "\$ ",
              name: 'Daily Trading Profit',
              value: dashboardData?['incomes']['daily_roi'] ?? "0",
              imagePath: 'assets/images/wave2.png',
            ),
            HeadingWithImage(
              currency: "",
              name: 'Signup Bonus In Wink Token',
              value: dashboardData?['incomes']['signup'] ?? "0",
              imagePath: 'assets/images/wave3.png',
            ),
            HeadingWithImage(
              currency: "\$ ",
              name: 'Level income Of DTP',
              value: dashboardData?['incomes']['roi_sponsor'] ?? "0",
              imagePath: 'assets/images/wave.png',
            ),
            HeadingWithImage(
              currency: "\$ ",
              name: 'Booster',
              value: dashboardData?['incomes']['booster'] ?? "0",
              imagePath: 'assets/images/wave2.png',
            ),
            HeadingWithImage(
              currency: "",
              name: 'Daily Dividend on Staking',
              value: dashboardData?['incomes']['monthly_staking'] ?? "0",
              imagePath: 'assets/images/wave3.png',
            ),
            HeadingWithImage(
              currency: "\$ ",
              name: 'Reward',
              value: dashboardData?['incomes']['reward'] ?? "0",
              imagePath: 'assets/images/wave.png',
            ),
            HeadingWithImage(
              currency: "",
              name: 'Signup Referral',
              value: dashboardData?['incomes']['signup_referral'] ?? "0",
              imagePath: 'assets/images/wave2.png',
            ),
          ]),
        ),
      ),
    );
  }
}
