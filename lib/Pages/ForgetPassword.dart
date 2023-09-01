// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'package:wink30/Pages/loginPage.dart';
import 'package:wink30/utils/MyColors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:wink30/utils/API.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool isLoading = false;
  bool isConfirmLoading = false;
  bool _isPasswordVisible = false;
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: MyColors.bgColor,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                flex: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          isConfirmLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Container(),
                          const Icon(
                            Icons.lock_person_outlined,
                            color: MyColors.primaryColor,
                            size: 100,
                          ),
                          const SizedBox(height: 20.0),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: usernameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'username',
                          labelStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: const Color.fromARGB(83, 66, 66, 66),
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
                            return 'username cannot be empty';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: passwordController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: const Color.fromARGB(83, 66, 66, 66),
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.white),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 20.0,
                          ),
                        ),
                        obscureText: !_isPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'password cannot be empty';
                          } else {
                            return null;
                          }
                        },
                      ),
                      // ---------------------------------------------------------------------
                      const SizedBox(height: 20.0),

                      isLoading
                          ? const Center(
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : SizedBox(
                              width: double.infinity,
                              child: SizedBox(
                                width: 200.0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    sendOTP();
                                    // _showAlert(context, "msg");
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
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Reset Password',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      SizedBox(width: 5.0),
                                      Icon(
                                        Icons.restart_alt_outlined,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "login your account?",
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()));
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } // ignore: non_constant_identifier_names

  Future<void> sendOTP() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      var url = Uri.parse(APIPaths.sendForgetOTP);
      var body = {
        'u_code': usernameController.text,
        'otp_type': "forgot_password",
        'password': passwordController.text
      };

      try {
        var response = await http.post(url, body: body);
        print(response.statusCode);
        if (response.statusCode == 200) {
          var responseBody = await jsonDecode(response.body);
          if (responseBody['res'] == "success") {
            setState(() {
              isLoading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                content: Text((responseBody['message']).toString())));
            _showAlert(context, "");
          } else {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Invalid username and password")));
          }
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        }
      } catch (error) {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> forgetPassword() async {
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate() &&
        _formKey2.currentState != null &&
        _formKey2.currentState!.validate()) {
      print(otpController.text);
      setState(() {
        isConfirmLoading = true;
      });
      var url = Uri.parse(APIPaths.forgotPassword);
      var body = {
        'u_code': usernameController.text,
        'otp_type': "forgot_password",
        'entered_otp': otpController.text,
        'new_password': passwordController.text
      };

      try {
        var response = await http.post(url, body: body);
        print(response.statusCode);
        if (response.statusCode == 200) {
          print("response ${response.body}");
          var responseBody = await jsonDecode(response.body);
          if (responseBody['res'] == "success") {
            setState(() {
              isConfirmLoading = false;
            });
            otpController.clear();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                content: Text((responseBody['message']).toString())));
          } else {
            setState(() {
              isConfirmLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text((responseBody['message']).toString())));
          }
        } else {
          setState(() {
            isConfirmLoading = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        }
      } catch (error) {
        setState(() {
          isConfirmLoading = false;
        });
      }
    }
  }

  void _showAlert(BuildContext context, String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          icon: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              color: MyColors.primaryColor,
            ),
            child: const Icon(
              Icons.security_rounded,
              color: Color.fromARGB(255, 255, 255, 255),
              size: 40.0,
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              textAlign: TextAlign.center,
              'Confirm OTP',
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ),
          content: Container(
            child: Form(
              key: _formKey2,
              child: Column(
                children: [
                  Text(
                    "An OTP has been send to your email. Please check OTP and enter",
                    textAlign: TextAlign.center,
                    style:
                        GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: otpController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(6),
                      FilteringTextInputFormatter
                          .digitsOnly, // Only allow digits
                    ],
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'OTP',
                      labelStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: const Color.fromARGB(83, 66, 66, 66),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 20.0,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length != 6) {
                        return 'Please enter a 6-digit number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Expanded(
                child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(MyColors.primaryColor),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      otpController.clear();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                isConfirmLoading == true
                    ? const Center(child: CircularProgressIndicator())
                    : Expanded(
                        flex: 1,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                MyColors.primaryColor),
                          ),
                          child: const Text(
                            'Confirm',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            forgetPassword();
                          },
                        ),
                      ),
              ],
            )),
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
      backgroundColor: MyColors.bgColor,
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
