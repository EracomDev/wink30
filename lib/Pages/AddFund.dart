import 'package:flutter/material.dart';
import 'package:wink30/utils/MyColors.dart';
import 'dart:convert';
import 'package:wink30/utils/API.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class AddFund extends StatefulWidget {
  const AddFund({super.key});

  @override
  State<AddFund> createState() => _AddFundState();
}

class _AddFundState extends State<AddFund> {
  var amountController = TextEditingController();
  var txHashController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  var addFundData;
  File? _image;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = await prefs.getString('userid');
    print('token $userId');
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(APIPaths.fundRequestData);
    var body = {'u_id': userId};
    try {
      var response = await http.post(url, body: body);
      print('res ${response.body}');
      if (response.statusCode == 200) {
        print('response.body ${response.body}');
        var jsonData = await jsonDecode(response.body.toString());
        if (jsonData?['res'] == "success") {
          if (mounted) {
            setState(() {
              addFundData = jsonData;
              isLoading = false;
            });
          }
          log('dashboardData $addFundData');
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
          "Add Fund",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(83, 66, 66, 66),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                        color: const Color.fromARGB(255, 65, 65, 65))),
                child: const Text(
                  "USDT BEP20 Address",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            addFundData?['address'] ?? '',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                                  text: (addFundData?['address']).toString()))
                              .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "${(addFundData?['address']).toString()} copied to clipboard")));
                          });
                        },
                        icon: const Icon(
                          Icons.copy,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Row(children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          addFundData?['remark'] ?? "",
                          style: const TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  )
                ]),
              ),
              const SizedBox(height: 15),
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: amountController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          labelStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: const Color.fromARGB(83, 66, 66, 66),
                          prefixIcon:
                              const Icon(Icons.money, color: Colors.white),
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
                            return 'Amount cannot be empty';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: txHashController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Transaction Hash',
                          labelStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: const Color.fromARGB(83, 66, 66, 66),
                          prefixIcon:
                              const Icon(Icons.numbers, color: Colors.white),
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
                            return 'Transaction hash cannot be empty';
                          } else {
                            return null;
                          }
                        },
                      ),
                      isLoading
                          ? Container(
                              margin: const EdgeInsets.all(20),
                              child: const Center(
                                  child: CircularProgressIndicator(
                                      strokeWidth: 1)),
                            )
                          : Container(
                              margin: const EdgeInsets.only(top: 10),
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(15),
                                    backgroundColor: MyColors.primaryColor),
                                onPressed: addFundWithSlip,
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            )
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

  Future<void> addFundWithSlip() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('userid');
      print('token $userId');
      final url = APIPaths.fundRequest; // Replace with your API endpoint
      // Create the request body
      var requestBody = {
        'u_id': userId,
        'utr_number': txHashController.text,
        'amount': amountController.text,
      };
      try {
        var response = await http.post(
          Uri.parse(url),
          body: requestBody,
        );

        if (response.statusCode == 200) {
          var jsonData = await jsonDecode(response.body.toString());
          if (jsonData?['res'] == "success") {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                content: Text(jsonData?['message'])));
            amountController.clear();
            txHashController.clear();
          } else {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text(jsonData?['message'])));
          }
          print(response.body);
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.green, content: Text("Failed")));
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print('Image upload error: $e');
      }
    }
  }
}
