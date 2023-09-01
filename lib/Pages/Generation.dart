// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:wink30/utils/MyColors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:wink30/utils/API.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class GenerationTeam extends StatefulWidget {
  const GenerationTeam({super.key});

  @override
  State<GenerationTeam> createState() => _GenerationTeamState();
}

class _GenerationTeamState extends State<GenerationTeam> {
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
    {"name": "Level 1", "type": "1"},
    {"name": "Level 2", "type": "2"},
    {"name": "Level 3", "type": "3"},
    {"name": "Level 4", "type": "4"},
    {"name": "Level 5", "type": "5"},
    {"name": "Level 6", "type": "6"},
    {"name": "Level 7", "type": "7"},
    {"name": "Level 8", "type": "8"},
    {"name": "Level 9", "type": "9"},
    {"name": "Level 10", "type": "10"},
    {"name": "Level 11", "type": "11"},
    {"name": "Level 12", "type": "12"},
    {"name": "Level 13", "type": "13"},
    {"name": "Level 14", "type": "14"},
    {"name": "Level 15", "type": "15"},
    {"name": "Level 16", "type": "16"},
    {"name": "Level 17", "type": "17"},
    {"name": "Level 18", "type": "18"},
    {"name": "Level 19", "type": "19"},
    {"name": "Level 20", "type": "20"},
    {"name": "Level 21", "type": "21"},
    {"name": "Level 22", "type": "22"},
    {"name": "Level 23", "type": "23"},
    {"name": "Level 24", "type": "24"},
  ];
  String selectedValue = ""; // Set initial value
  List<Map<String, dynamic>> tableData = [];
  @override
  void initState() {
    super.initState();
    selectedValue = dropdownData[0]['type']!;
    fetchData(selectedValue);
  }

  Future<void> fetchData(teamLevel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userid');
    print('token $userId');
    print('selectedValue $teamLevel');
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(APIPaths.generationTeam);
    var body = {'u_id': userId, "init_val": "0", "level": teamLevel};
    try {
      var response = await http.post(url, body: body);
      print('res $response');
      if (response.statusCode == 200) {
        log('response.body ${response.body}');
        var jsonData = jsonDecode(response.body);
        print("jkbjkbkg hj ggiuguo gohioh");
        if (jsonData['res'] == "success") {
          final data = jsonData['data'];
          setState(() {
            tableData = List<Map<String, dynamic>>.from(data);
            isLoading = false;
          });
          print('tableData $tableData');
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
    return Scaffold(
      backgroundColor: MyColors.bgColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: MyColors.bgColor,
        title: const Text(
          "Generation Team",
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Table(
                    defaultColumnWidth: const IntrinsicColumnWidth(),
                    border: TableBorder.all(
                        color: const Color.fromARGB(48, 255, 255, 255)),
                    children: [
                      TableRow(
                        children: [
                          // TableCell(
                          //     child: Container(
                          //   color: MyColors.primaryColor,
                          //   padding: const EdgeInsets.symmetric(
                          //       vertical: 5, horizontal: 5),
                          //   alignment: Alignment.center,
                          //   child: Text(
                          //     'ID.',
                          //     style: tabledata,
                          //   ),
                          // )),

                          TableCell(
                              child: Container(
                            color: MyColors.primaryColor,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            alignment: Alignment.center,
                            child: Text(
                              'Username',
                              style: tabledata,
                            ),
                          )),
                          // TableCell(
                          //     child: Container(
                          //   color: MyColors.primaryColor,
                          //   padding: const EdgeInsets.symmetric(
                          //       vertical: 5, horizontal: 5),
                          //   alignment: Alignment.center,
                          //   child: Text(
                          //     'Sponsor',
                          //     style: tabledata,
                          //   ),
                          // )),
                          TableCell(
                              child: Container(
                            color: MyColors.primaryColor,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            alignment: Alignment.center,
                            child: Text(
                              'Package',
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
                              'Team Business',
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
                              'Status',
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
                              'Active Date',
                              style: tabledata,
                            ),
                          )),
                        ],
                      ),
                      for (var rowData in tableData)
                        TableRow(
                          children: [
                            // TableCell(
                            //   child: Container(
                            //     padding: const EdgeInsets.all(5),
                            //     alignment: Alignment.center,
                            //     child: Text(
                            //       rowData['id'].toString(),
                            //       style: tabledata,
                            //     ),
                            //   ),
                            // ),

                            TableCell(
                                child: Container(
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: Text(
                                rowData['username'].toString(),
                                style: tabledata,
                              ),
                            )),
                            // TableCell(
                            //     child: Container(
                            //   padding: const EdgeInsets.all(5),
                            //   alignment: Alignment.center,
                            //   child: Text(
                            //     rowData['u_sponsor'].toString(),
                            //     style: tabledata,
                            //   ),
                            // )),
                            TableCell(
                                child: Container(
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: Text(
                                "\$ ${rowData['my_package'].toString()}",
                                style: tabledata,
                              ),
                            )),
                            TableCell(
                                child: Container(
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: Text(
                                rowData['team_business'].toString(),
                                style: tabledata,
                              ),
                            )),
                            TableCell(
                                child: Container(
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: Text(
                                rowData['active_status'] == "1"
                                    ? "Active"
                                    : "Inactive",
                                style: tabledata,
                              ),
                            )),
                            TableCell(
                                child: Container(
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: Text(
                                rowData['active_date'] ?? "",
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
