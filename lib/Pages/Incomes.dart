// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:wink30/utils/MyColors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:wink30/utils/API.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Incomes extends StatefulWidget {
  const Incomes({super.key});

  @override
  State<Incomes> createState() => _IncomesState();
}

class _IncomesState extends State<Incomes> {
  var sno = 0;
  final TextStyle tableText = GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: const Color.fromARGB(255, 255, 255, 255),
  );

  String? dropdownValue;
  bool isLoading = false;
  List<dynamic>? incomesData;
  final TextStyle tabledata =
      const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 12);

  List<Map<String, dynamic>> dropdownData = [
    {"name": "Signup Bonus", "type": "signup"},
    {"name": "Signup Referral", "type": "signup_referral"},
    {"name": "Daily Trading Profit", "type": "daily_roi"},
    {"name": "Level Income On DTP", "type": "roi_sponsor"},
    {"name": "Booster Earning", "type": "booster"},
    {"name": "Daily Dividend", "type": "monthly_staking"},
  ];
  String selectedValue = ""; // Set initial value

  List<Map<String, dynamic>> tableData = [];
  @override
  void initState() {
    super.initState();
    selectedValue = dropdownData[0]['type']!;
    fetchData(selectedValue);
  }

  Future<void> fetchData(incomeType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userid');
    print('token $userId');
    print('selectedValue $incomeType');
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(APIPaths.incomes);
    var body = {'u_id': userId, "init_val": "0", "income_type": incomeType};
    try {
      var response = await http.post(url, body: body);
      print('res $response');
      if (response.statusCode == 200) {
        print('response.body ${response.body}');
        var jsonData = jsonDecode(response.body);
        if (jsonData['res'] == "success") {
          final data = jsonData['data'];
          setState(() {
            tableData = List<Map<String, dynamic>>.from(data);
            isLoading = false;
          });
          if (data.length <= 0) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: MyColors.primaryColor,
                content: Text("Data not found")));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.red, content: Text("Data not found")));
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.bgColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: MyColors.bgColor,
        title: const Text(
          "Incomes",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedValue,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: MyColors.bgColor,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    borderSide: BorderSide(
                      color: MyColors.bgColor,
                      width: 1.0,
                    ),
                  ),
                ),
                dropdownColor: MyColors.bgColor,
                items: dropdownData.map((data) {
                  return DropdownMenuItem<String>(
                    value: data['type']!,
                    child: Text(
                      data['name']!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                    fetchData(selectedValue);
                  });
                },
              ),
              const SizedBox(height: 15),
              isLoading == true
                  ? const Center(
                      child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ))
                  : Container(),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  selectedValue.replaceAll("_", " ").toUpperCase(),
                  style: const TextStyle(
                      color: MyColors.primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Table(
                    defaultColumnWidth: const IntrinsicColumnWidth(),
                    border: TableBorder.all(
                        color: const Color.fromARGB(48, 255, 255, 255)),
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                              child: Container(
                            color: MyColors.primaryColor,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            alignment: Alignment.center,
                            child: Text(
                              'Amount',
                              style: tabledata,
                            ),
                          )),
                          TableCell(
                              child: Container(
                            color: MyColors.primaryColor,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            alignment: Alignment.center,
                            child: Text(
                              'Type',
                              style: tabledata,
                            ),
                          )),
                          TableCell(
                              child: Container(
                            color: MyColors.primaryColor,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            alignment: Alignment.center,
                            child: Text(
                              'Remark',
                              style: tabledata,
                            ),
                          )),
                          TableCell(
                              child: Container(
                            color: MyColors.primaryColor,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            alignment: Alignment.center,
                            child: Text(
                              'Date',
                              style: tabledata,
                            ),
                          )),
                        ],
                      ),
                      for (var rowData in tableData)
                        TableRow(
                          children: [
                            TableCell(
                                child: Container(
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: Text(
                                rowData['amount'].toString(),
                                style: tabledata,
                              ),
                            )),
                            TableCell(
                                child: Container(
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: Text(
                                rowData['tx_type'].toString(),
                                style: tabledata,
                              ),
                            )),
                            TableCell(
                                child: Container(
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: Text(
                                rowData['remark'].toString(),
                                style: tabledata,
                              ),
                            )),
                            TableCell(
                                child: Container(
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: Text(
                                rowData['date'].toString(),
                                style: tabledata,
                              ),
                            )),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
