// ignore_for_file: deprecated_member_use, depend_on_referenced_packages, file_names

import 'package:flutter/material.dart';
import 'package:wink30/utils/MyColors.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:wink30/utils/API.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Subscription extends StatefulWidget {
  const Subscription({super.key});

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  var useridController = TextEditingController();
  String? dropdownValue;

  bool isLoading = false;
  var dashboardData;
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> dropdownData = [];
  @override
  void initState() {
    super.initState();
    dropdownValue = "1";
    FetchData();
  }

  // ignore: non_constant_identifier_names
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
    var url = Uri.parse(APIPaths.packages);
    var body = {'u_id': userId};
    try {
      var response = await http.post(url, body: body);
      print('res ${response.body}');
      if (response.statusCode == 200) {
        print('Login successful');
        print('response.body ${response.body}');
        var jsonData = await jsonDecode(response.body);
        print("jkbjkbkg hj ggiuguo gohioh");
        if (jsonData['res'] == "success") {
          final data = jsonData['retopup_data'];
          setState(() {
            dropdownData = List<Map<String, dynamic>>.from(data);
            isLoading = false;
          });
          print('r $dashboardData');
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        log("jkbjkbkg hj ggiuguo gohioh");
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

  Future<void> depostiFun() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('userid');
      print('token $userId');
      print('dropdownValue $dropdownValue');
      setState(() {
        isLoading = true;
      });
      var url = Uri.parse(APIPaths.retopup);
      print(url);
      var body = {
        'selected_wallet': "fund_wallet",
        'tx_username': useridController.text,
        'selected_pin': dropdownValue,
        'u_id': userId
      };
      try {
        var response = await http.post(url, body: body);
        print('res ${response.statusCode}');
        if (response.statusCode == 200) {
          print('Login successful');
          print('response.body ${response.body}');
          var jsonData = await jsonDecode(response.body.toString());
          log("jkbjkbkg hj ggiuguo gohioh");
          if (jsonData['res'] == "success") {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(jsonData['message']),
                  backgroundColor: Colors.green),
            );
            setState(() {
              isLoading = false;
            });
          } else {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(jsonData['message']),
                  backgroundColor: Colors.red),
            );
            setState(() {
              isLoading = false;
            });
          }
        } else {
          print(response);
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10.0),
                    Image.asset(
                      "assets/images/logo.png",
                      width: 150,
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: useridController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'User ID',
                        labelStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: MyColors.containerColor,
                        prefixIcon:
                            const Icon(Icons.person, color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 20.0,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "user id cannot be empty";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 10.0),

                    // ----------------------------------------------------------------------------------------

                    DropdownButtonFormField<String>(
                      value: dropdownValue,
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "1") {
                          return "Please select subscription type";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: MyColors.containerColor,
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
                      items: [
                        const DropdownMenuItem(
                          value: '1',
                          child: Text(
                            'Select Package',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        for (var rowData in dropdownData)
                          DropdownMenuItem(
                            value: rowData['pin_type'],
                            child: Text(
                              rowData['pin_type'],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                      ],
                      onChanged: (String? newValue) {
                        // Handle dropdown value change
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                    ),
                    // ----------------------------------------------------------------------------------------

                    const SizedBox(height: 10.0),
                    SizedBox(
                        width: double.infinity,
                        child: SizedBox(
                          width: 200.0,
                          child: isLoading
                              ? const Center(
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2))
                              : ElevatedButton(
                                  onPressed: () {
                                    depostiFun();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(15.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    primary: MyColors
                                        .primaryColor, // Set Sanguine background color
                                    onPrimary: Colors.white, // Set text color
                                    elevation: 3.0, // Add elevation
                                  ),
                                  child: const Text(
                                    'Topup',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
