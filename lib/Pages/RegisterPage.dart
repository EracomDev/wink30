// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wink30/Pages/loginPage.dart';
import 'package:wink30/Pages/termsCondition.dart';
import 'package:wink30/utils/API.dart';
import 'package:wink30/utils/MyColors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  String referralId;
  RegisterPage({super.key, required this.referralId});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool __agreeToTerms = false;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var sponsorController = TextEditingController();
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var countryController = TextEditingController();
  var mobileController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var securityPinController = TextEditingController();
  var fullnameController = TextEditingController();
  var referralController = TextEditingController();
  String userFromId = "";
  var country;
  var countryCode;
  void initState() {
    super.initState();

    if (widget.referralId.toString() != "null" &&
        widget.referralId.toString() != "") {
      referralController.text = widget.referralId.toString();
    }
    // Set the default country name and code when the page loads
    country = 'India'; // You can set any default country name here
    countryCode = '+91'; // You can set any default country code here
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: MyColors.bgColor,
          child: Form(
            key: _formKey,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 50),
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Image.asset(
                                'assets/images/logo.png',
                                width: 100.0,
                              ),
                              const SizedBox(height: 20.0),
                            ],
                          ),
                          const SizedBox(height: 20.0),

                          Container(
                            child: TextFormField(
                              controller: fullnameController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Full Name',
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
                                  return 'name cannot be empty';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          // ---------------------------------------------------------------------
                          const SizedBox(height: 20.0),
                          Container(
                            child: TextFormField(
                              controller: emailController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: const Color.fromARGB(83, 66, 66, 66),
                                prefixIcon: const Icon(Icons.email,
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
                                  return 'email cannot be empty';
                                } else if (!value.contains("@")) {
                                  return 'invalid email';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),

                          const SizedBox(height: 20.0),
                          Container(
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
                                  return 'password cannot be empty';
                                }
                                if (value.length < 6) {
                                  return 'password length should be minimum 6';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          // ---------------------------------------------------------------------
                          const SizedBox(height: 20.0),
                          Container(
                            child: TextFormField(
                              controller: confirmPasswordController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: const Color.fromARGB(83, 66, 66, 66),
                                prefixIcon:
                                    const Icon(Icons.lock, color: Colors.white),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isConfirmPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isConfirmPasswordVisible =
                                          !_isConfirmPasswordVisible;
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
                              obscureText: !_isConfirmPasswordVisible,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'confirm password cannot be empty';
                                } else if (value != passwordController.text) {
                                  return 'check your confirm password';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Container(
                            child: TextFormField(
                              onChanged: (value) {
                                if (referralController.text.length >= 6) {
                                  checkUsername();
                                } else {
                                  setState(() {
                                    userFromId = "";
                                  });
                                }
                              },
                              controller: referralController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Referral Code (optional)',
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: const Color.fromARGB(83, 66, 66, 66),
                                prefixIcon: const Icon(Icons.shield_outlined,
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

                          isLoading2
                              ? Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  width: 20,
                                  height: 20,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
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
                          Row(
                            children: [
                              Checkbox(
                                  value: __agreeToTerms,
                                  onChanged: (value) {
                                    setState(() {
                                      __agreeToTerms = value!;
                                    });
                                  }),
                              Expanded(
                                child: Row(
                                  children: [
                                    const Text(
                                      'I agree to the',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const TermsCondition()));
                                        },
                                        child: const Text(
                                          "Terms&Condition",
                                          style:
                                              TextStyle(color: Colors.yellow),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // ----------------------------------------------------
                          isLoading == true
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Container(
                                  width: double.infinity,
                                  child: SizedBox(
                                    width: 200.0,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        RegisterFun();
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
                                            'Register',
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

                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account?",
                                style: TextStyle(color: Colors.white),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()));
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
  Future<void> RegisterFun() async {
    print(__agreeToTerms);
    debugPrint(APIPaths.register);
    debugPrint(referralController.text);
    debugPrint(passwordController.text);
    debugPrint(fullnameController.text);
    debugPrint(country);
    debugPrint(countryCode);
    if (__agreeToTerms == false) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Accept Terms & Conditions")));
    }
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate() &&
        __agreeToTerms) {
      setState(() {
        isLoading = true;
      });
      var url = Uri.parse(APIPaths.register);
      var body = {
        'referrer_id': referralController.text,
        // 'usename': usernameController.text,
        // 'reg_mob_number': mobileController.text,
        'reg_full_name': fullnameController.text,
        'reg_email': emailController.text,
        'reg_password': passwordController.text,
        'confirm_password': confirmPasswordController.text,
        // 'security_pin': securityPinController.text,
        // 'country_code': countryCode,
        // 'country': country,
        'device_token': "token"
      };
      try {
        var response = await http.post(url, body: body);
        print(response);
        if (response.statusCode == 200) {
          print('Register successful');
          print(response.body);
          var responseBody = await jsonDecode(response.body);
          if (responseBody['status'] == true) {
            setState(() {
              isLoading = false;
            });
            // ignore: use_build_context_synchronously
            _showAlert(context, responseBody['message'],
                responseBody['username'], responseBody['password']);
          } else {
            setState(() {
              isLoading = false;
            });
            // ignore: use_build_context_synchronously
            if (responseBody['err_referrer_id'].isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(responseBody['err_referrer_id']
                      .toString()
                      .replaceAll('<p>', '')
                      .replaceAll('</p>', ''))));
            } else
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(responseBody['message'])));
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
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showAlert(BuildContext context, String msg, String user, String pass) {
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
          content: Container(
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16)),

                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 0),
                          blurRadius: .5,
                          spreadRadius: .5,
                          color: Colors.black26,
                        ),
                      ],
                      //boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3),blurRadius: 1,offset: Offset(1, 1))]
                    ),
                    child: const Text(
                      "Note: Please take screen shot for future reference.",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                      textAlign: TextAlign.center,
                    )),
                const SizedBox(height: 10),
                Text(msg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Username"),
                    Row(
                      children: [
                        Text(user),
                        IconButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: user))
                                  .then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text("$user copied to clipboard")));
                              });
                            },
                            icon: const Icon(Icons.copy))
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Password"),
                    Row(
                      children: [
                        Text(pass),
                        IconButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: pass))
                                  .then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text("$pass copied to clipboard")));
                              });
                            },
                            icon: const Icon(Icons.copy))
                      ],
                    )
                  ],
                )
              ],
            ),
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
                  // Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const LoginPage())));
                },
              ),
            ),
          ],
        );
      },
    );
  }

  bool isLoading2 = false;
  Future<void> checkUsername() async {
    if (!mounted) {
      return;
    }
    setState(() {
      isLoading2 = true;
    });
    var url = Uri.parse(APIPaths.getUsername);
    var body = {'username': referralController.text};
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
