// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:wink30/utils/MyColors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:wink30/utils/API.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SetAccount extends StatefulWidget {
  const SetAccount({super.key});

  @override
  State<SetAccount> createState() => _SetAccountState();
}

class _SetAccountState extends State<SetAccount> {
  var sno = 0;
  final TextStyle tableText = GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: const Color.fromARGB(255, 255, 255, 255),
  );

  String? dropdownValue;
  bool isLoading = false;
  var addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<dynamic>? incomesData;
  final TextStyle tabledata =
      const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 12);

  List<Map<String, dynamic>> dropdownData = [
    {"name": "Select Withdrawal Option", "type": "trc20"},
    {"name": "Token Address", "type": "token_address"},
    {"name": "USDT BEP20 Address", "type": "BEP20"},
  ];
  String? selectedValue = "trc20";
  List<Map<String, dynamic>> tableData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.bgColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: MyColors.bgColor,
        title: const Text(
          "Account",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
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
                  });
                },
              ),
              // Container(
              //   padding: EdgeInsets.all(15),
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //       color: const Color.fromARGB(83, 66, 66, 66),
              //       borderRadius: BorderRadius.circular(25),
              //       border: Border.all(color: Color.fromARGB(255, 65, 65, 65))),
              //   child: const Text(
              //     "USDT BEP20 Address",
              //     style: TextStyle(color: Colors.white),
              //   ),
              // ),
              const SizedBox(height: 15),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: addressController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Address',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: const Color.fromARGB(83, 66, 66, 66),
                    prefixIcon: const Icon(Icons.person, color: Colors.white),
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
                      return 'username cannot be empty';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              const SizedBox(height: 15),
              isLoading == true
                  ? const Center(
                      child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ))
                  : SizedBox(
                      width: double.infinity,
                      child: SizedBox(
                        width: 200.0,
                        child: ElevatedButton(
                          onPressed: () {
                            setAccount();
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
                            'Add Account',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> setAccount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userid');
    debugPrint(userId);
    debugPrint(addressController.text);
    debugPrint(selectedValue);
    debugPrint(APIPaths.setAccount);

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      var url = Uri.parse(APIPaths.setAccount);
      var body = {
        'u_id': userId,
        'account': addressController.text,
        'account_type': selectedValue
      };
      try {
        var response = await http.post(url, body: body);
        print(response);
        if (response.statusCode == 200) {
          print(response.body);
          var responseBody = await jsonDecode(response.body);
          if (responseBody['res'] == "success") {
            setState(() {
              isLoading = false;
            });
            _showAlert(context, responseBody['message']);
            addressController.clear();
          } else {
            setState(() {
              isLoading = false;
            });
            if (responseBody?['error_amount'].length > 0) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text((responseBody?['error_amount'])
                      .toString()
                      .replaceAll('<p>', '')
                      .replaceAll('</p>', ''))));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(responseBody?['message'])));
            }
          }
        } else {
          setState(() {
            isLoading = false;
          });
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        }
      } catch (error) {
        setState(() {
          isLoading = false;
        });
        print('An error occurred: $error');
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showAlert(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          icon: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              color: Colors.green,
            ),
            child: const Icon(
              Icons.done,
              color: Color.fromARGB(255, 255, 255, 255),
              size: 40.0,
            ),
          ),
          title: const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              textAlign: TextAlign.center,
              'Success',
              style: TextStyle(
                  fontSize: 30, color: Color.fromARGB(255, 78, 78, 78)),
            ),
          ),
          content: Column(
            children: [
              Container(child: Text(msg)),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ],
          ),
          actions: [
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class CustomAlertDialog extends StatelessWidget {
  final Widget icon;
  final Widget title;
  final Widget content;
  final List<Widget> actions;

  const CustomAlertDialog({
    Key? key,
    required this.icon,
    required this.title,
    required this.content,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: -40.0,
            child: icon,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                title,
                const SizedBox(height: 8.0),
                content,
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
