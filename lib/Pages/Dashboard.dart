// ignore_for_file: use_key_in_widget_constructors, file_names, depend_on_referenced_packages, no_leading_underscores_for_local_identifiers
import 'package:flutter/material.dart';
import 'package:wink30/Components/CryptoCard.dart';
import 'package:wink30/Components/PieChart.dart';
import 'package:wink30/Pages/CoinStaking.dart';
import 'package:wink30/Pages/Security.dart';
import 'package:wink30/Pages/SetAccount.dart';
import 'package:wink30/Pages/loginPage.dart';
import 'package:wink30/utils/MyColors.dart';
import 'package:wink30/Pages/Deposit.dart';
import 'package:wink30/Pages/FundConvert.dart';
import 'package:wink30/Pages/FundTransfer.dart';
import 'package:wink30/Pages/Packages.dart';
import 'package:wink30/Pages/Support.dart';
import 'package:wink30/Pages/Withdraw.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:wink30/utils/API.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:marquee_widget/marquee_widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isLoading = false;
  String? token;
  var newsData;
  var popupData;
  var videoData;
  bool _isLoading = true;
  List<Map<String, dynamic>> currencyData = [];
  var fullDashboardData;
  List<Map<String, dynamic>> dashboardData = [];
  final TextStyle walletStyle = const TextStyle(
      color: Color.fromARGB(255, 0, 0, 0),
      fontWeight: FontWeight.bold,
      fontSize: 12);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FetchDashboardData();
      _loadToken();
    });
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
    var url = Uri.parse(APIPaths.otherContent);
    try {
      var response = await http.get(url);
      print('res $response');
      if (response.statusCode == 200) {
        log('response.body ${response.body}');
        var jsonData = await jsonDecode(response.body.toString());
        if (jsonData['res'] == "success") {
          final data = jsonData['banner'];
          setState(() {
            newsData = jsonData['news'];
            popupData = jsonData['popup']?[0];
            videoData = jsonData['video']?[0];
            dashboardData = List<Map<String, dynamic>>.from(data);
            isLoading = false;
          });
          if (popupData?['status'] == "1") {
            _showImagePopupOnce();
          }
          print('dashboardData $fullDashboardData');
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
    }
  }

  Future<void> FetchDashboardData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = await prefs.getString('userid');
    print('token $userId');
    if (token != null) {
      setState(() {
        isLoading = true;
      });
      var url = Uri.parse(APIPaths.dashboard);
      var body = {'u_id': userId};
      try {
        var response = await http.post(url, body: body);
        print('res ${response.body}');
        if (response.statusCode == 200) {
          print('response.body ${response.body}');
          var jsonData = await jsonDecode(response.body.toString());
          if (jsonData['res'] == "success") {
            final data = jsonData['crypto1'];
            if (mounted) {
              setState(() {
                currencyData = List<Map<String, dynamic>>.from(data);
                fullDashboardData = jsonData;
                isLoading = false;
              });
            }
            log('dashboardData $fullDashboardData');
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
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false);
    }
  }

  Future<void> _showImagePopupOnce() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isPopupShown = prefs.getBool('imagePopupShown') ?? false;

    if (!isPopupShown) {
      _showImagePopup();
      // Save the flag to shared preferences to indicate the popup has been shown
      prefs.setBool('imagePopupShown', true);
    }
  }

  void _showImagePopup() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                popupData?['title'],
                style: GoogleFonts.poppins(
                    fontSize: 16, color: const Color.fromARGB(255, 0, 0, 0)),
              ),
              const SizedBox(height: 10),
              Text(
                popupData?['description'],
                style: GoogleFonts.poppins(
                    fontSize: 12, color: const Color.fromARGB(255, 0, 0, 0)),
              ),
            ],
          ),
          content: Container(
            padding: const EdgeInsets.only(top: 16.0),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: (popupData?['img_path']),
              placeholder: (context, url) => Container(
                alignment: Alignment.center,
                width: 20,
                height: 20,
                child: const CircularProgressIndicator(
                  strokeWidth: 1,
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ), // Replace with your image path
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final TextStyle btnTextStyle = GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: const Color.fromARGB(255, 255, 255, 255),
    );
    const double iconWidth = 30;

    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.bgColor,
        body: RefreshIndicator(
          onRefresh: FetchDashboardData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isLoading
                      ? Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: const CircularProgressIndicator(
                              color: MyColors.primaryColor,
                              strokeWidth: 1,
                            ),
                          ),
                        )
                      : const Center(),
                  Container(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: currencyData.isNotEmpty
                          ? Row(
                              children: [
                                for (var rowData in currencyData)
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const CoinStaking()));
                                    },
                                    child: CryptoCard(
                                      img: rowData['image'],
                                      name: rowData['symbol'],
                                      stack: (rowData['stake']).toString(),
                                      balance: rowData['bal'].toString(),
                                      rate: rowData['price'],
                                      dateStatus: rowData['unblock_sts'],
                                      date: rowData['unblock_date'],
                                    ),
                                  )
                              ],
                            )
                          : Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  width: screenWidth * 0.6,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: MyColors.containerColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  width: screenWidth * 0.6,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: MyColors.containerColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  width: screenWidth * 0.6,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: MyColors.containerColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                )
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 15),
                  /////////////////////marquee/////////////////////////
                  Row(
                    children: [
                      const Icon(
                        Icons.campaign,
                        color: Colors.white,
                      ),
                      newsData?[0]?['status'] == "1"
                          ? Expanded(
                              child: SizedBox(
                                height: 20,
                                child: Marquee(
                                  direction: Axis.horizontal,
                                  animationDuration:
                                      const Duration(milliseconds: 20000),
                                  backDuration:
                                      const Duration(milliseconds: 5000),
                                  pauseDuration:
                                      const Duration(milliseconds: 2000),
                                  child: Row(
                                    children: [
                                      for (var rowData in currencyData)
                                        Row(
                                          children: [
                                            const SizedBox(width: 20),
                                            Image.network(rowData['image']),
                                            const SizedBox(width: 10),
                                            Text(
                                              "${rowData['symbol']} : ${double.parse(rowData['price']).toStringAsFixed(4)}",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            )
                                          ],
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                  const SizedBox(height: 20),
                  // ----------------------all buttons------------------------------
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () => token != null
                                ? Navigator.push(
                                    context,
                                    SlidePageRoute(
                                      page: const Deposit(),
                                    ))
                                : ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: Colors.red,
                                        content:
                                            Text("Please login your account"))),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/btndeposit.png",
                                  width: iconWidth,
                                ),
                                Text(
                                  "Deposit",
                                  style: btnTextStyle,
                                )
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              SlidePageRoute(
                                page: const Packages(),
                              ),
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/btnpackages.png",
                                  width: iconWidth,
                                ),
                                Text(
                                  "Packages",
                                  style: btnTextStyle,
                                )
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              SlidePageRoute(
                                page: const Security(),
                              ),
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/kyc.png",
                                  width: iconWidth,
                                ),
                                Text(
                                  "Security",
                                  style: btnTextStyle,
                                )
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              SlidePageRoute(
                                page: const FundTransfer(),
                              ),
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/btntransfer.png",
                                  width: iconWidth,
                                ),
                                Text(
                                  "Transfer",
                                  style: btnTextStyle,
                                )
                              ],
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context, SlidePageRoute(page: const Support())),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/btnsupport.png",
                                  width: iconWidth,
                                ),
                                Text(
                                  "Support",
                                  style: btnTextStyle,
                                )
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () => token != null
                                ? Navigator.push(
                                    context,
                                    SlidePageRoute(
                                      page: const Withdraw(),
                                    ))
                                : ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: Colors.red,
                                        content:
                                            Text("Please login your account"))),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/withdraw.png",
                                  width: iconWidth,
                                ),
                                Text(
                                  "Withdraw",
                                  style: btnTextStyle,
                                )
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context, SlidePageRoute(page: FundConvert())),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/convert.png",
                                  width: iconWidth,
                                ),
                                Text(
                                  "Convert",
                                  style: btnTextStyle,
                                )
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () => Navigator.push(context,
                                SlidePageRoute(page: const SetAccount())),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/wallet.png",
                                  width: iconWidth,
                                ),
                                Text(
                                  textAlign: TextAlign.center,
                                  "Payment Method",
                                  style: btnTextStyle,
                                )
                              ],
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // ----------------------slider------------------------------
                  // const MySlider(),

                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              color: MyColors.primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Image.asset("assets/images/wallet.png",
                                  width: 40),
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Token Wallet", style: walletStyle),
                                  Text(
                                      " ${fullDashboardData?['wallets']?['token_wallet'] ?? "0"}",
                                      style: walletStyle)
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              color: MyColors.primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Image.asset("assets/images/wallet.png",
                                  width: 40),
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Staking Wallet", style: walletStyle),
                                  Text(
                                      " ${fullDashboardData?['wallets']?['stake_token'] ?? "0"}",
                                      style: walletStyle)
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: 200.0, // Set the desired height of the slider
                  //   child: Column(
                  //     children: [
                  //       Expanded(
                  //         child: CarouselSlider(
                  //           options: CarouselOptions(
                  //             height: double.infinity,
                  //             autoPlay: true,
                  //             aspectRatio:
                  //                 MediaQuery.of(context).size.width / 200,
                  //             autoPlayInterval: const Duration(seconds: 3),
                  //             viewportFraction: 1.0,
                  //             onPageChanged: (index, reason) {
                  //               setState(() {
                  //                 _currentIndex = index;
                  //               });
                  //             },
                  //           ),
                  //           items: dashboardData.map((banner) {
                  //             String imageUrl = banner['img'];
                  //             return Builder(
                  //               builder: (BuildContext context) {
                  //                 return Container(
                  //                   width: double.infinity,
                  //                   margin:
                  //                       const EdgeInsets.fromLTRB(5, 10, 5, 10),
                  //                   child: ClipRRect(
                  //                     borderRadius: BorderRadius.circular(15),
                  //                     child: CachedNetworkImage(
                  //                       fit: BoxFit.cover,
                  //                       imageUrl: imageUrl,
                  //                       placeholder: (context, url) =>
                  //                           const Center(
                  //                         child: SizedBox(
                  //                           width: 20,
                  //                           height: 20,
                  //                           child: CircularProgressIndicator(
                  //                             strokeWidth: 1,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       errorWidget: (context, url, error) =>
                  //                           const Icon(Icons.error),
                  //                     ),
                  //                   ),
                  //                 );
                  //               },
                  //             );
                  //           }).toList(),
                  //         ),
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: List<Widget>.generate(4, (int index) {
                  //           return Container(
                  //             width: 8.0,
                  //             height: 8.0,
                  //             margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  //             decoration: BoxDecoration(
                  //               shape: BoxShape.circle,
                  //               color: _currentIndex == index
                  //                   ? MyColors.primaryColor
                  //                   : Colors.grey,
                  //             ),
                  //           );
                  //         }),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 40),
                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    child: fullDashboardData != null
                        ? MyChart(
                            amount: (fullDashboardData?['package']).toString(),
                            income:
                                ((fullDashboardData?['total_package_income'])
                                        .toDouble()) ??
                                    0.0, // Use a default value if it's null
                            getIncome:
                                fullDashboardData?['total_earning'].toDouble(),
                            // Use a default value if it's null
                          )
                        : Container(
                            width: double.infinity,
                            height: 200,
                            decoration: const BoxDecoration(
                                color: MyColors.containerColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                          ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlidePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
}
