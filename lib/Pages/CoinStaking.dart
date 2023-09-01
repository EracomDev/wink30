// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wink30/utils/MyColors.dart';
import 'package:wink30/utils/API.dart';

class CoinStaking extends StatefulWidget {
  const CoinStaking({super.key});

  @override
  State<CoinStaking> createState() => _CoinStakingState();
}

class _CoinStakingState extends State<CoinStaking> {
  String? dropdownValue;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isFormListLoading = false;
  var liveRate = 0.00;
  double totalToken = 0.00;
  var username;
  var amountController = TextEditingController();
  List<Map<String, dynamic>> dropdownData = [];
  List<Map<String, dynamic>> tableData = [];
  final TextStyle tabledata =
      const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 12);
  @override
  void initState() {
    super.initState();
    dropdownValue = "1";
    fetchData();
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userid');
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
      if (response.statusCode == 200) {
        print('response.body ${response.body}');
        var jsonData = await jsonDecode(response.body);
        if (jsonData['res'] == "success") {
          final data = jsonData['crypto1'];
          setState(() {
            dropdownData = List<Map<String, dynamic>>.from(data);
            username = jsonData?['profile']?[0]?['username'];
            isLoading = false;
          });
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
    }
  }

  Future<void> topup() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('userid');
      if (!mounted) {
        return;
      }
      setState(() {
        isLoading = true;
      });
      var url = Uri.parse(APIPaths.currencyTopup);
      var body = {
        'u_id': userId,
        'selected_wallet': "fund_wallet",
        'tx_username': username,
        'amount': amountController.text,
        'token_type': dropdownValue
      };
      try {
        var response = await http.post(url, body: body);
        print('res ${response.body}');
        if (response.statusCode == 200) {
          print('response.body ${response.body}');
          var jsonData = await jsonDecode(response.body);
          if (jsonData['res'] == "success") {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(jsonData['message']),
                  backgroundColor: Colors.green),
            );
            amountController.clear();
          } else {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(jsonData['message']),
                  backgroundColor: Colors.red),
            );
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
      }
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
          "Coin Staking",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              width: double.infinity,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          value: dropdownValue,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value == "1") {
                              return "Please select Currency";
                            } else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: MyColors.containerColor,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                color: MyColors.bgColor,
                                width: 1.0,
                              ),
                            ),
                          ),
                          dropdownColor: MyColors.bgColor,
                          items: [
                            const DropdownMenuItem(
                              value: "1",
                              child: Text(
                                'Select Currency',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            for (var rowData in dropdownData)
                              DropdownMenuItem(
                                value: rowData['name'],
                                child: Text(
                                  (rowData['name']).toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  print("newValue ${rowData['price']}");
                                  liveRate =
                                      double.parse(rowData['price'].toString());
                                  amountController.clear();
                                  setState(() {
                                    totalToken = 0.00;
                                  });
                                },
                              ),
                          ],
                          onChanged: (String? newValue) {
                            // Handle dropdown value change

                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '$dropdownValue Live Rate : $liveRate',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: amountController,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                          // Set it to null to allow multiple lines
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            labelText: '\$ Amount',
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                totalToken = double.parse(value) / liveRate;
                              } else {
                                totalToken = 0.00;
                              }
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Amount cannot be empty";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        dropdownValue != '1'
                            ? Text(
                                "$dropdownValue : $totalToken",
                                style: const TextStyle(color: Colors.white),
                              )
                            : Text(''),
                        const SizedBox(height: 10),
                        isLoading
                            ? Container(
                                alignment: Alignment.center,
                                width: 20,
                                height: 20,
                                child: Center(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 1)))
                            : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      padding: const EdgeInsets.all(14),
                                      backgroundColor: MyColors.primaryColor,
                                    ),
                                    onPressed: () {
                                      topup();
                                    },
                                    child: const Text(
                                      "Send",
                                      style: TextStyle(color: Colors.black),
                                    )),
                              )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          )),
    );
  }
}
