import 'package:flutter/material.dart';
import 'package:wink30/Pages/Security.dart';
import 'package:wink30/utils/MyColors.dart';
import 'dart:convert';
import 'package:wink30/utils/API.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VerifyOTP extends StatefulWidget {
  final String emailAddress;

  const VerifyOTP({required this.emailAddress});

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  var otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.bgColor,
      appBar: AppBar(
          backgroundColor: MyColors.bgColor,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text("Verify Your Email",
              style: TextStyle(
                color: (Colors.white),
              ))),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.all(50),
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                        color: MyColors.containerColor,
                        borderRadius: BorderRadius.circular(125)),
                    child: Image.asset(
                      width: 150,
                      height: 150,
                      "assets/images/email.png",
                      fit: BoxFit.contain,
                    )),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    textAlign: TextAlign.center,
                    "Please Enter 6 Digit Code Sent To ${widget.emailAddress}",
                    style: const TextStyle(
                        height: 1.4,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  controller: otpController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'OTP',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: const Color.fromARGB(83, 66, 66, 66),
                    prefixIcon:
                        const Icon(Icons.mail_outlined, color: Colors.white),
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
                      return 'OTP cannot be empty';
                    } else {
                      if (value.length != 6) {
                        return 'Invalid OTP';
                      }
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                isLoading == true
                    ? const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: SizedBox(
                          width: 200.0,
                          child: ElevatedButton(
                            onPressed: () {
                              verifyOtp();
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
                              'Verify',
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
      ),
    );
  }

  Future<void> verifyOtp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userid');
    print(otpController.text);
    print(APIPaths.fundConvert);
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      var url = Uri.parse(APIPaths.verifyOtp);
      var body = {
        'u_code': userId,
        'otp_type': "email",
        'entered_otp': otpController.text
      };
      try {
        var response = await http.post(url, body: body);
        print(response);
        if (response.statusCode == 200) {
          print(response.statusCode);
          print(response.body);
          var responseBody = await jsonDecode(response.body);
          if (responseBody['res'] == "success") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                content: Text(responseBody?['message'])));
            Navigator.pushAndRemoveUntil(
                // ignore: prefer_const_constructors
                context,
                MaterialPageRoute(builder: (context) => Security()),
                (route) => true);
            setState(() {
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text(responseBody?['message'])));
          }
        } else {
          print(response.statusCode);
          print(response.body);
          setState(() {
            isLoading = false;
          });
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.red, content: Text("Failed")));
        }
      } catch (error) {
        setState(() {
          isLoading = false;
        });
        print('An error occurred: $error');
      }
    }
  }
}
