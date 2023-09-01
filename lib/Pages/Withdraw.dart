import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wink30/Pages/SetAccount.dart';
import 'package:wink30/utils/MyColors.dart';
import 'dart:convert';
import 'package:wink30/utils/API.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class Withdraw extends StatefulWidget {
  const Withdraw({super.key});

  @override
  State<Withdraw> createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  var dashboardData;
  var amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    selectedValue = dropdownData[0]['type']!;
    fetchData();
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userid');
    debugPrint('token $userId');
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
      print('res $response');
      if (response.statusCode == 200) {
        print('response.body ${response.body}');
        var jsonData = await jsonDecode(response.body.toString());
        if (jsonData['res'] == "success") {
          setState(() {
            dashboardData = jsonData;
            isLoading = false;
          });
          log('dashboardData $dashboardData');
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

  List<Map<String, dynamic>> dropdownData = [
    {"name": "Select Wallet", "type": "0"},
    {"name": "Main Wallet", "type": "main_wallet"},
    {"name": "Token Wallet", "type": "token_wallet"},
  ];
  String selectedValue = "";
  double usdtAmount = 0;

  void checkUSDT() {
    if (selectedValue == "token_wallet") {
      try {
        // int val = int.parse(amountController.text);
        if (amountController.text.isNotEmpty) {
          double enterAmount = double.parse(amountController.text);
          double tokenRate = double.parse((dashboardData?['token_rate']));
          double usdtAmt = enterAmount * tokenRate;
          setState(() {
            usdtAmount = usdtAmt;
          });
        } else {
          setState(() {
            usdtAmount = 0.00;
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Something went wrong")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.bgColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: MyColors.bgColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Withdraw",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.primaryColor),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SetAccount()));
                        },
                        child: const Text(
                          "Add Account",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            color: MyColors.containerColor,
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Image.asset("assets/images/wallet.png", width: 25),
                            const SizedBox(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Main Wallet",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                Text(
                                  "\$ ${(dashboardData?['wallets']['main_wallet']).toString()}",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                )
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
                            color: MyColors.containerColor,
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Image.asset("assets/images/wallet.png", width: 25),
                            const SizedBox(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Token Wallet",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                Text(
                                  (dashboardData?['wallets']['token_wallet'])
                                      .toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      color: MyColors.containerColor,
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Image.asset("assets/images/wallet.png", width: 50),
                      const SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Total Withdrawal Amount",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            "\$ ${(dashboardData?['total_withdrawal']).toString()}",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
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
                        validator: (value) {
                          if (value == null || value.isEmpty || value == "0") {
                            return "Please select Wallet";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          labelStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: MyColors.containerColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
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
                            if (numericValue == null || numericValue <= 0) {
                              return 'Invalid amount';
                            }
                            return null;
                          }
                        },
                        onChanged: (value) {
                          checkUSDT();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                selectedValue == "token_wallet"
                    ? Text(
                        "USDT Amount : $usdtAmount",
                        style: const TextStyle(color: MyColors.primaryColor),
                      )
                    : const Center(),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Withdrawal Address : ",
                      style: TextStyle(color: Colors.white),
                    ),
                    selectedValue == "token_wallet"
                        ? Expanded(
                            flex: 1,
                            child: Text(
                              dashboardData?['token_address'] ??
                                  "Please add your account",
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        : selectedValue == "main_wallet"
                            ? Expanded(
                                flex: 1,
                                child: Text(
                                  dashboardData?['user_address'] ??
                                      "Please add your account",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              )
                            : const Text("")
                  ],
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : SizedBox(
                        width: double.infinity,
                        child: SizedBox(
                          width: 200.0,
                          child: ElevatedButton(
                            onPressed: () {
                              Withdraw();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(15.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              primary: MyColors
                                  .primaryColor, // Set Sanguine background color
                              onPrimary: Colors.white, // Set text color
                              elevation: 3.0, // Add elevation
                            ),
                            child: const Text(
                              'Withdraw',
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

  Future<void> Withdraw() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userid');
    print(amountController.text);
    print(selectedValue);
    print(APIPaths.withdraw);

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      var url = Uri.parse(APIPaths.withdraw);
      var body = {
        'u_id': userId,
        'selected_wallet': selectedValue,
        'amount': amountController.text
      };
      try {
        var response = await http.post(url, body: body);
        print(response.body);
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
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text((responseBody?['message'])
                    .toString()
                    .replaceAll('<p>', '')
                    .replaceAll('</p>', ''))));
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
                  fetchData();
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
