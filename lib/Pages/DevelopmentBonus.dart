// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:wink30/utils/MyColors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:wink30/utils/API.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class DevelopmentBonus extends StatefulWidget {
  const DevelopmentBonus({Key? key}) : super(key: key);

  @override
  State<DevelopmentBonus> createState() => _DevelopmentBonusState();
}

class _DevelopmentBonusState extends State<DevelopmentBonus> {
  List<dynamic>? dashboardData;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    FetchData();
  }

  Future<void> FetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userid');
    print('token $userId');
    print('token ${APIPaths.developmentBonus}');
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(APIPaths.reward);
    var body = {'u_id': userId};
    try {
      var response = await http.post(url, body: body);
      print('res $response');
      if (response.statusCode == 200) {
        print('Login successful');
        print('response.body ${response.body}');
        var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        log("jkbjkbkg hj ggiuguo gohioh");
        if (jsonData['res'] == "success") {
          final mydata = jsonData['data'];
          print(mydata);
          setState(() {
            dashboardData = List.from(mydata);
            isLoading = false;
          });
          log('dashboardData $dashboardData');
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Failed to fetch data")));
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
    return Scaffold(
        backgroundColor: MyColors.bgColor,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: MyColors.bgColor,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Development Bonus",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                strokeWidth: 2,
              ))
            : dashboardData != null && dashboardData!.isNotEmpty
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount:
                        dashboardData != null ? dashboardData!.length : 0,
                    itemBuilder: (context, index) {
                      final item = dashboardData![index];
                      return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromARGB(66, 248, 171, 5)),
                                color: MyColors.containerColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${item['rank']}",
                                  style: GoogleFonts.poppins(
                                      color: MyColors.primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Image.asset("assets/images/gift.png",
                                        width: 50),
                                    const SizedBox(
                                        width:
                                            8), // Add spacing between the image and text
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Reward Business",
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white),
                                              ),
                                              const Spacer(), // Add spacing between "Amount" and "Value"
                                              Text(
                                                "\$ ${item['reward_business']}",
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                              height:
                                                  4), // Add vertical spacing
                                          Row(
                                            children: [
                                              Text(
                                                "Daily Reward",
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white),
                                              ),
                                              const Spacer(), // Add spacing between "Amount" and "Value"
                                              Text(
                                                "\$ ${item['daily_reward']} ",
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "Monthly Reward",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: Text(
                                        "\$ ${item['monthly_reward']} ",
                                        style: GoogleFonts.poppins(
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255)),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "Total Reward ",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: Text(
                                        "\$ ${item['total_reward_50_month']} ",
                                        style: GoogleFonts.poppins(
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255)),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "Status",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: Text(
                                        "${item['status']} ",
                                        style: GoogleFonts.poppins(
                                            color: MyColors.primaryColor),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ));
                    },
                  )
                : const Center(
                    child: Text("Data Not Found",
                        style: TextStyle(color: Colors.white))));
  }
}
