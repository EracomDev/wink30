// ignore_for_file: deprecated_member_use, file_names, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wink30/Pages/ForgetPassword.dart';
import 'package:wink30/Pages/RegisterPage.dart';
import 'package:wink30/Pages/app_bottom_navigation.dart';
import 'package:wink30/utils/API.dart';
import 'package:wink30/utils/MyColors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  bool isLoding = false;
  final _formKey = GlobalKey<FormState>();
  final loginUrl = APIPaths.login;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.bgColor,
        body: Center(
          child: Container(
            color: MyColors.bgColor,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Image.asset(
                                'assets/images/logo.png',
                                width: 140.0,
                              ),
                              const SizedBox(height: 20.0),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'username cannot be empty';
                                } else {
                                  return null;
                                }
                              },
                              // validator: (value) {
                              //    if (value == null || value.isEmpty) {
                              //     return 'Please enter some text';
                              //   }
                              // },
                              controller: usernameController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Username',
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
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextFormField(
                              controller: passwordController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle:
                                    const TextStyle(color: Colors.white),
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
                                  return 'Password cannot be empty';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          isLoding == true
                              ? const CircularProgressIndicator(
                                  strokeWidth: 1,
                                )
                              : Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: SizedBox(
                                    width: 200.0,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        login();
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
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Login',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          SizedBox(width: 5.0),
                                          Icon(
                                            Icons.login,
                                            color: Colors.black,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 20.0),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgetPassword()));
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(color: Colors.white),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterPage(referralId: "",)));
                                },
                                child: const Text(
                                  'Register',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
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

  Future<void> login() async {
    print(APIPaths.login);
    print(usernameController.text);
    print(passwordController.text);
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoding = true;
      });
      var url = Uri.parse(APIPaths.login);
      var body = {
        'u_code': usernameController.text,
        'password': passwordController.text,
        'device_token': "token"
      };
      try {
        var response = await http.post(url, body: body);
        print(response.body);
        if (response.statusCode == 200) {
          print('Login successful');
          print(response.body);
          var responseBody = await jsonDecode(response.body);
          if (responseBody['res'] == "found") {
            print("userId="+responseBody['u_id']);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', responseBody['session_key']);
            await prefs.setString('userid', responseBody['u_id']);
            await prefs.setString('username', responseBody["user_info"]['username'].toString());

            print("usernam="+responseBody['username'].toString());


            // ignore: use_build_context_synchronously
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const AppBottomNavigation()),
                (route) => false);
          } else {
            setState(() {
              isLoding = false;
            });
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Invalid username or password")));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.red,
              content: Text("Failed to fetch data")));
          setState(() {
            isLoding = false;
          });
        }
      } catch (error) {
        setState(() {
          isLoding = false;
        });
      }
    } else {
      setState(() {
        isLoding = false;
      });
    }
  }
}
