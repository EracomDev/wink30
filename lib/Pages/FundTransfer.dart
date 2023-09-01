// ignore_for_file: deprecated_member_use, file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wink30/utils/API.dart';
import 'package:wink30/utils/MyColors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FundTransfer extends StatefulWidget {
  const FundTransfer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FundTransferState createState() => _FundTransferState();
}

class _FundTransferState extends State<FundTransfer> {
  bool isLoading = false;
  bool isLoading2 = false;
  final _formKey = GlobalKey<FormState>();
  var userIdController = TextEditingController();
  var amountController = TextEditingController();
  String userFromId = "";
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
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(APIPaths.getTransferFund);
    var body = {'u_id': userId};
    try {
      var response = await http.post(url, body: body);
      print('res $response');
      if (response.statusCode == 200) {
        print('response.body ${response.body}');
        var jsonData = await jsonDecode(response.body.toString());
        if (jsonData['res'] == "success") {
          setState(() {
            dashboardData = jsonData;
            isLoading = false;
          });
          print('dashboardData $dashboardData');
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
      appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: MyColors.bgColor,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Fund Transfer",
            style: TextStyle(color: Colors.white),
          )),
      body: Container(
        color: MyColors.bgColor,
        child: Form(
          key: _formKey,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          (dashboardData?['wallet_type']?[0]?['wallet_type'])
                              .toString()
                              .replaceAll('_', ' '),
                          style: const TextStyle(
                              color: MyColors.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                        Text(
                          (dashboardData?['wallet_amount']).toString(),
                          style: const TextStyle(
                              color: MyColors.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20.0),
                          Container(
                            child: TextFormField(
                              onChanged: (value) {
                                if (userIdController.text.length >= 6) {
                                  checkUsername();
                                } else {
                                  setState(() {
                                    userFromId = "";
                                  });
                                }
                              },
                              controller: userIdController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'User ID',
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: const Color.fromARGB(83, 66, 66, 66),
                                prefixIcon: const Icon(Icons.person,
                                    color: Colors.white),
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
                                  return 'user ID cannot be empty';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          isLoading2
                              ? Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  width: 20,
                                  height: 20,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ))
                              : Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      userFromId,
                                      style: GoogleFonts.poppins(
                                          color: const Color.fromARGB(
                                              255, 105, 252, 110)),
                                    ),
                                  ),
                                ),
                          // ---------------------------------------------------------------------
                          const SizedBox(height: 10.0),
                          Container(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: amountController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Amount',
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: const Color.fromARGB(83, 66, 66, 66),
                                prefixIcon: const Icon(Icons.money_off,
                                    color: Colors.white),
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
                                  // Convert the value to a numeric type (e.g., double or int) before comparison
                                  double? numericValue = double.tryParse(value);
                                  if (numericValue == null ||
                                      numericValue <= 0) {
                                    return 'Invalid amount';
                                  }
                                  return null;
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          // ----------------------------------------------------
                          isLoading == true
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  child: SizedBox(
                                    width: 200.0,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        TransferFund();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(15.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                        ),
                                        primary: MyColors
                                            .primaryColor, // Set Sanguine background color
                                        onPrimary:
                                            Colors.white, // Set text color
                                        elevation: 3.0, // Add elevation
                                      ),
                                      child: const Text(
                                        'Transfer',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),

                          const SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Future<void> TransferFund() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userid');
    print(amountController.text);
    print(APIPaths.transferFund);
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      var url = Uri.parse(APIPaths.transferFund);
      var body = {
        'u_id': userId,
        "selected_wallet":
            (dashboardData?['wallet_type']?[0]?['wallet_type']).toString(),
        "tx_username": userIdController.text,
        "amount": amountController.text
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

  Future<void> checkUsername() async {
    if (!mounted) {
      return;
    }
    setState(() {
      isLoading2 = true;
    });
    var url = Uri.parse(APIPaths.getUsername);
    var body = {'username': userIdController.text};
    try {
      var response = await http.post(url, body: body);
      print('res ${response.body}');
      if (response.statusCode == 200) {
        var jsonData = await jsonDecode(response.body);
        if (jsonData['res'] == "success") {
          setState(() {
            userFromId = jsonData['name'];
            isLoading2 = false;
          });
          print('r $dashboardData');
        } else {
          setState(() {
            userFromId = "";
            isLoading2 = false;
          });
        }
      } else {
        setState(() {
          isLoading2 = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          isLoading2 = false;
        });
      }
    }
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
