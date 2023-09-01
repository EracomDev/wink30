import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:wink30/utils/API.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import 'package:google_fonts/google_fonts.dart';

import '../utils/MyColors.dart';

class Transaction extends StatefulWidget {
  const Transaction({Key? key}) : super(key: key);

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  bool isLoading = false;
  List<dynamic>? dashboardData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userid');
    print('token $userId');
    setState(() {
      isLoading = true;
    });

    var url = Uri.parse(APIPaths.transcations);
    var body = {'u_id': userId, 'init_val': "0"};

    try {
      var response = await http.post(url, body: body);
      print('res $response');

      if (response.statusCode == 200) {
        print('Login successful');
        print('response.body ${response.body}');
        var jsonData = jsonDecode(response.body) as Map<String, dynamic>;

        if (jsonData['res'] == "success") {
          final mydata = jsonData['data'];
          print("mydata $mydata");
          if (mounted) {
            setState(() {
              dashboardData = List.from(mydata);
              isLoading = false;
            });
          }

          print('dashboardData $dashboardData');
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
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
            strokeWidth: 1,
          ))
        : dashboardData != null && dashboardData!.isNotEmpty
            ? RefreshIndicator(
                onRefresh: fetchData,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: dashboardData != null ? dashboardData!.length : 0,
                  itemBuilder: (context, index) {
                    final item = dashboardData![index];
                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: const BoxDecoration(
                              color: MyColors.containerColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  item['debit_credit'] == "credit"
                                      ? Image.asset("assets/images/wallet.png",
                                          width: 40)
                                      : Image.asset("assets/images/delete.png",
                                          width: 40),
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
                                              "Amount",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white),
                                            ),
                                            const Spacer(), // Add spacing between "Amount" and "Value"

                                            Text(
                                              item['tx_type'] == "token"
                                                  ? "${item['amount']}"
                                                  : item['wallet_type'] ==
                                                          "token_wallet"
                                                      ? "${item['amount']}"
                                                      : "\$${item['amount']} ",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                            height: 4), // Add vertical spacing
                                        Text(
                                          "${item['remark']}",
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 12),
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
                                  Text(
                                    "${item['date']}",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white, fontSize: 11),
                                  ),
                                  item['status'] == "0"
                                      ? Text(
                                          "Pending",
                                          style: GoogleFonts.poppins(
                                              color: MyColors.primaryColor),
                                        )
                                      : item['status'] == "1"
                                          ? Text(
                                              "Approved",
                                              style: GoogleFonts.poppins(
                                                  color: const Color.fromARGB(
                                                      255, 3, 173, 74)),
                                            )
                                          : Text(
                                              "Rejected",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.red),
                                            )
                                ],
                              )
                            ],
                          ),
                        ));
                  },
                ),
              )
            : const Center(
                child: Text("Data Not Found",
                    style: TextStyle(color: Colors.white)));
  }
}
