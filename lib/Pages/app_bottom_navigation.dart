// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:wink30/Pages/AddFund.dart';
import 'package:wink30/Pages/CoinStaking.dart';
import 'package:wink30/Pages/Dashboard.dart';
import 'package:wink30/Pages/DevelopmentBonus.dart';
import 'package:wink30/Pages/DirectTeam.dart';
import 'package:wink30/Pages/Earnings.dart';
import 'package:wink30/Pages/FundConverAll.dart';
import 'package:wink30/Pages/Generation.dart';
import 'package:wink30/Pages/Incomes.dart';
import 'package:wink30/Pages/Markets.dart';
import 'package:wink30/Pages/NotificationPage.dart';
import 'package:wink30/Pages/Profile.dart';
import 'package:wink30/Pages/Transaction.dart';
import 'package:wink30/Pages/invite_friend.dart';
import 'package:wink30/Pages/loginPage.dart';
import 'package:wink30/utils/MyColors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:wink30/utils/API.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class AppBottomNavigation extends StatefulWidget {
  const AppBottomNavigation({Key? key}) : super(key: key);

  @override
  State<AppBottomNavigation> createState() => _AppBottomNavigationState();
}

class _AppBottomNavigationState extends State<AppBottomNavigation> {
  final int numberOfEmails = 10; // Number of emails
  String? token;
  var dashboardData;
  var profileData;

  Future<void> FetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = await prefs.getString('userid');
    print('token $userId');
    if (token != null) {
      var url = Uri.parse(APIPaths.dashboard);
      print(APIPaths.dashboard);
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
              profileData = jsonData['profile'];
            });
            log('dashboardData $dashboardData');
          } else {}
        } else {}
      } catch (error) {
        if (mounted) {}
      }
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadToken();
    FetchData();
  }

  Future<void> _loadToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        token = prefs.getString('token');
        print(token);
      });
    } catch (e) {
      print("error: $e");
    }
  }

  int _currentIndex = 0;
  final tabs = [
    const Dashboard(),
    const Transaction(),
    const Markets(),
    const Earnings(),
    const Profile(),
  ];

  Future<void> Logout() async {
    showDialog<bool>(
        context: context,
        barrierDismissible:
            false, // Prevent the user from dismissing the dialog by tapping outside
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(false); // Return false when "No" is pressed
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.clear();
                  // ignore: use_build_context_synchronously
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (route) => false);
                },
                child: const Text('Yes'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle drawerHeading = GoogleFonts.poppins(
        color: const Color.fromARGB(255, 255, 255, 255),
        fontSize: 13,
        fontWeight: FontWeight.w500);
    int backButtonPressedCount = 0;

    return WillPopScope(
      onWillPop: () async {
        backButtonPressedCount++;
        if (backButtonPressedCount == 2) {
          // Exit the app or perform any other desired action
          SystemNavigator.pop();
        } else {
          // Show a toast or snackbar indicating to press back again
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Press back again to exit'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        // Return false to prevent the default back button behavior
        return false;
      },
      child: Scaffold(
        backgroundColor: MyColors.bgColor,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: MyColors.bgColor,
          title: const Row(
            children: [
              Image(
                image: AssetImage("assets/images/logo.png"),
                width: 50,
              ),
              SizedBox(width: 10),
              // Text(
              //   "Wink 30",
              //   style: TextStyle(
              //       color: MyColors.primaryColor,
              //       fontSize: 16,
              //       fontWeight: FontWeight.w700),
              // )
            ],
          ),
          actions: [
            // IconButton(
            //   icon: const Icon(
            //     Icons.volume_off_outlined,
            //     color: MyColors.primaryColor,
            //   ),
            //   onPressed: () {
            //     // Perform search action
            //   },
            // ),
            Stack(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.email,
                    color: MyColors.primaryColor,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationPage()));
                  },
                ),
                // Positioned(
                //   top: 5,
                //   right: 5,
                //   child: Container(
                //     padding: const EdgeInsets.all(2),
                //     decoration: BoxDecoration(
                //       color: Colors.red,
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     child: Text(
                //       numberOfEmails.toString(),
                //       style: const TextStyle(
                //         color: Colors.white,
                //         fontSize: 10,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: MyColors.bgColor,
          shadowColor: MyColors.bgColor,
          surfaceTintColor: MyColors.bgColor,
          child: ListView(
            children: [
              Container(
                height: 150,
                child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: MyColors.bgColor,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: profileData != null && profileData != false
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (profileData?[0]?['name']).toString(),
                              style: const TextStyle(
                                  color: MyColors.primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              (profileData?[0]?['username']).toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              (profileData?[0]?['email']).toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        )
                      : const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: SizedBox(
                              height: 70,
                              child: Image(
                                  image: AssetImage("assets/images/logo.png")),
                            ),
                          ),
                        ),
                ),
              ),

              ExpansionTile(
                title: Text(
                  "Team",
                  style: drawerHeading,
                ),
                leading: const Icon(
                  Icons.diversity_3_outlined,
                  color: Colors.white,
                ),
                childrenPadding: const EdgeInsets.only(left: 40),
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.people,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Direct",
                      style: drawerHeading,
                    ),
                    onTap: () {
                      //action on press
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DirectTeam()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.people,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Generation",
                      style: drawerHeading,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const GenerationTeam()));
                    },
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                title: Text(
                  'Add Fund',
                  style: drawerHeading,
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AddFund()));
                },
              ),

              ListTile(
                leading: const Icon(
                  Icons.share,
                  color: Colors.white,
                ),
                title: Text(
                  'Share App Link',
                  style: drawerHeading,
                ),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String userId = prefs.getString("username").toString();
                  debugPrint("userId$userId");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              InviteFriendPage(userId: userId)));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.money,
                  color: Colors.white,
                ),
                title: Text(
                  'My Portfolio',
                  style: drawerHeading,
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Incomes()));
                },
              ),

              ListTile(
                leading: const Icon(
                  Icons.token_outlined,
                  color: Colors.white,
                ),
                title: Text(
                  'Coin Staking',
                  style: drawerHeading,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CoinStaking()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.swap_horiz,
                  color: Colors.white,
                ),
                title: Text(
                  'Coin Convert',
                  style: drawerHeading,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FundConvertAll()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.card_giftcard,
                  color: Colors.white,
                ),
                title: Text(
                  'Reward',
                  style: drawerHeading,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DevelopmentBonus()));
                },
              ),
              // ListTile(
              //   leading: const Icon(
              //     Icons.rss_feed,
              //     color: Colors.white,
              //   ),
              //   title: Text(
              //     'Blog',
              //     style: drawerHeading,
              //   ),
              //   onTap: () {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => const Blog()));
              //   },
              // ),
              // ListTile(
              //   leading: const Icon(
              //     Icons.card_giftcard,
              //     color: Colors.white,
              //   ),
              //   title: Text(
              //     'Cards',
              //     style: drawerHeading,
              //   ),
              //   onTap: () {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => const Cards()));
              //   },
              // ),
              // ListTile(
              //   leading: const Icon(
              //     Icons.info,
              //     color: Colors.white,
              //   ),
              //   title: Text(
              //     'About',
              //     style: drawerHeading,
              //   ),
              //   onTap: () {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => const About()));
              //   },
              // ),

              // ListTile(
              //   leading: const Icon(
              //     Icons.assignment,
              //     color: Colors.white,
              //   ),
              //   title: Text(
              //     'Terms & Conditions',
              //     style: drawerHeading,
              //   ),
              //   onTap: () {},
              // ),
              // ListTile(
              //   leading: const Icon(
              //     Icons.https,
              //     color: Colors.white,
              //   ),
              //   title: Text(
              //     'Private Policy',
              //     style: drawerHeading,
              //   ),
              //   onTap: () {},
              // ),
              token == null
                  ? ListTile(
                      leading: const Icon(
                        Icons.login,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Login',
                        style: drawerHeading,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                    )
                  : ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Logout',
                        style: drawerHeading,
                      ),
                      onTap: Logout,
                    ),
              // Add more list items as needed
            ],
          ),
        ),
        body: tabs[_currentIndex],
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                  color: Color.fromARGB(12, 158, 158, 158), width: 1.0),
            ),
          ),
          child: BottomNavigationBar(
            unselectedItemColor: const Color.fromARGB(255, 138, 136, 136),
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: MyColors.bgColor,
            iconSize: 25,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.receipt_long_outlined,
                ),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.timeline_outlined),
                label: 'Market',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_outlined),
                label: 'Portfolio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              )
            ],
            unselectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w300,
              fontSize: 11,
            ),
            selectedLabelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w300,
                fontSize: 11,
                color: const Color.fromARGB(255, 255, 255, 255)),
            selectedItemColor: Colors.white,
            selectedIconTheme: const IconThemeData(
                size: 25, color: Color.fromARGB(255, 255, 255, 255)),
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
