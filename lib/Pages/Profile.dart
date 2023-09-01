// ignore_for_file: depend_on_referenced_packages, file_names

import 'package:flutter/material.dart';
import 'package:wink30/Pages/EditUserData.dart';
import 'package:wink30/Pages/SetAccount.dart';
import 'package:wink30/Pages/loginPage.dart';

import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

import '../utils/API.dart';
import '../utils/MyColors.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = false;

  // ignore: prefer_typing_uninitialized_variables
  var dashboardData;

  @override
  void initState() {
    super.initState();
    FetchData();
  }

  Future<void> FetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = await prefs.getString('userid');
    print('token $userId');
    if (userId != null && userId.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      var url = Uri.parse(APIPaths.dashboard);
      var body = {'u_id': userId};
      try {
        var response = await http.post(url, body: body);
        print('res ${response.body}');
        if (response.statusCode == 200) {
          print('Login successful');
          print('response.body ${response.body}');
          var jsonData = await jsonDecode(response.body.toString());
          log("jkbjkbkg hj ggiuguo gohioh");
          if (jsonData['res'] == "success") {
            if (mounted) {
              setState(() {
                dashboardData = jsonData;
                isLoading = false;
              });
            }
            log('dashboardData $dashboardData');
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
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle profileDetail =
        GoogleFonts.poppins(color: Colors.white, fontSize: 13);

    return RefreshIndicator(
      onRefresh: FetchData,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: isLoading == true
                    ? const Center(
                        child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ))
                    : null,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            MyColors.primaryColor, // Set the background color
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SetAccount()));
                      },
                      child: const Text(
                        "Account",
                        style: TextStyle(color: Colors.black),
                      )),
                  const SizedBox(width: 10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            MyColors.primaryColor, // Set the background color
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditUserData()));
                      },
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dashboardData?['profile']?[0]?['username'] ?? '...',
                    style: GoogleFonts.lato(
                      color: const Color.fromARGB(255, 255, 255, 254),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  (dashboardData?['profile']?[0]?['active_status'] ?? '...') ==
                          "1"
                      ? const Icon(
                          Icons.circle,
                          color: Colors.green,
                          size: 14,
                        )
                      : const Icon(
                          Icons.circle,
                          color: Color.fromARGB(255, 255, 0, 0),
                          size: 14,
                        ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: MyColors.containerColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sponsor",
                            style: profileDetail,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                (dashboardData?['sponsor_username'] ?? '...')
                                    .toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                softWrap: true,
                                style: profileDetail,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Name",
                            style: profileDetail,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                (dashboardData?['profile']?[0]?['name'] ??
                                    '...'),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                softWrap: true,
                                style: profileDetail,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Email",
                            style: profileDetail,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                (dashboardData?['profile']?[0]?['email'] ??
                                    '...'),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                softWrap: true,
                                style: profileDetail,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Status ",
                            style: profileDetail,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: (dashboardData?['profile']?[0]
                                              ?['active_status'] ??
                                          '...') ==
                                      "1"
                                  ? Text(
                                      'Active',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      softWrap: true,
                                      style: profileDetail,
                                    )
                                  : Text(
                                      'Inactive',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      softWrap: true,
                                      style: profileDetail,
                                    ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Mobile",
                            style: profileDetail,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                dashboardData?['profile']?[0]?['mobile'] ??
                                    '...',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                softWrap: true,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Joining Date",
                            style: profileDetail,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                dashboardData?['profile']?[0]?['added_on'] ??
                                    '...',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                softWrap: true,
                                style: profileDetail,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Activation Date",
                            style: profileDetail,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                dashboardData?['profile']?[0]?['active_date'] ??
                                    '...',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                softWrap: true,
                                style: profileDetail,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
