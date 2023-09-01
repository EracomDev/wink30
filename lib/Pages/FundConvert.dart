// ignore_for_file: deprecated_member_use, file_names
import 'package:flutter/material.dart';
import 'package:wink30/utils/API.dart';
import 'package:wink30/utils/MyColors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "dart:developer";

class FundConvert extends StatefulWidget {
  // const FundConvert({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _FundConvertState createState() => _FundConvertState();
}

class _FundConvertState extends State<FundConvert> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var userIdController = TextEditingController();
  var tokenController = TextEditingController();
  List<Map<String, dynamic>> dropdownData = [];
  String? dropdownValue;
  double usdtAmount = 0;
  var currencyName;
  var currencyRate;
  var liveRate;
  void getUsdtRate() {
    double token = double.tryParse(tokenController.text) ?? 0.0;
    double rate = 0.0;
    if (currencyRate != null) {
      rate = double.parse(currencyRate.toString());
    }
    setState(() {
      usdtAmount = rate * token;
    });
  }

  @override
  void initState() {
    super.initState();
    dropdownValue = "1";
    fetchData();
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userid');
    if (!mounted) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(APIPaths.dashboard);
    var body = {'u_id': userId};
    try {
      var response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        log('fund convert ${response.body}');
        var jsonData = await jsonDecode(response.body);
        if (jsonData['res'] == "success") {
          final data = jsonData['crypto1'];
          setState(() {
            dropdownData = List<Map<String, dynamic>>.from(data);
            liveRate = double.parse(jsonData['token_rate']);
            isLoading = false;
          });
          log('dropdownData $dropdownData');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: MyColors.bgColor,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Fund Convert",
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
                    const SizedBox(height: 20),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: DropdownButtonFormField<String>(
                                  value: dropdownValue,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value == "1") {
                                      return "Please select Currency";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 16),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                        color: MyColors.bgColor,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  dropdownColor: MyColors.bgColor,
                                  items: [
                                    const DropdownMenuItem(
                                      value: "1",
                                      child: Text(
                                        'Wallets',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: "token_wallet",
                                      child: const Text(
                                        'Token Wallet',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      onTap: () {
                                        currencyRate = liveRate;
                                      },
                                    ),
                                    for (var rowData in dropdownData)
                                      DropdownMenuItem(
                                        value: rowData['wallet_type'],
                                        child: Text(
                                          (rowData['name']).toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        onTap: () {
                                          currencyName = rowData['name'];
                                          currencyRate = rowData['price'];
                                        },
                                      )
                                  ],
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue = newValue;
                                      tokenController.clear();
                                      usdtAmount = 0.0;
                                    });
                                  },
                                ),
                              ),
                              const Icon(
                                Icons.swap_horiz,
                                color: Colors.white,
                                size: 30,
                              ),
                              const Text(
                                "Main Wallet",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Container(
                            child: TextFormField(
                              onChanged: (value) {
                                getUsdtRate();
                              },
                              keyboardType: TextInputType.number,
                              controller: tokenController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: dropdownValue == 'token_wallet' ||
                                        dropdownValue == "1"
                                    ? "Token"
                                    : currencyName,
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: const Color.fromARGB(83, 66, 66, 66),
                                prefixIcon: const Icon(Icons.token_outlined,
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
                                  return 'field cannot be empty';
                                } else {
                                  // Convert the value to a numeric type (e.g., double or int) before comparison
                                  double? numericValue = double.tryParse(value);
                                  if (numericValue == null ||
                                      numericValue <= 0) {
                                    return 'Invalid data';
                                  }
                                  return null;
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "USDT Amount : $usdtAmount",
                            style:
                                const TextStyle(color: MyColors.primaryColor),
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
                                        Convert();
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
                                        'Convert',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),

                          const SizedBox(height: 20.0),
                          for (var rowData in dropdownData)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(35),
                                  color: MyColors.containerColor),
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Image.network(
                                        rowData['image'],
                                        width: 50,
                                      ),
                                      Text(
                                        rowData['symbol'],
                                        style: const TextStyle(
                                            color: MyColors.primaryColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        rowData['name'],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        rowData['bal'].toString(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
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

  Future<void> Convert() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userid');
    print(tokenController.text);
    print(APIPaths.fundConvert);
    print(dropdownValue);
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      var url = Uri.parse(APIPaths.fundConvert);
      var body = {
        'u_id': userId,
        'from_wallet': dropdownValue,
        'to_wallet': 'main_wallet',
        'amount': tokenController.text
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
