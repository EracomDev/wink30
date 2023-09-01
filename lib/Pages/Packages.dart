// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:wink30/Components/PackagesDiv.dart';
import 'package:wink30/Components/cryptoPackage.dart';
import 'package:wink30/utils/MyColors.dart';
import 'package:wink30/Pages/loginPage.dart';
import 'dart:convert';
import 'package:wink30/utils/API.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class Packages extends StatefulWidget {
  const Packages({super.key});

  @override
  State<Packages> createState() => _PackagesState();
}

class _PackagesState extends State<Packages> {
  bool isLoading = false;
  var packagesData;
  List<Map<String, dynamic>> packageList = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = await prefs.getString('userid');
    print('token $userId');
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(APIPaths.getPackages);
    var body = {'u_id': userId};
    try {
      var response = await http.post(url, body: body);
      print('res ${response.body}');
      if (response.statusCode == 200) {
        print('response.body ${response.body}');
        var jsonData = await jsonDecode(response.body.toString());
        if (jsonData['res'] == "success") {
          final data = jsonData['data'];
          if (mounted) {
            setState(() {
              packageList = List<Map<String, dynamic>>.from(data);
              packagesData = jsonData;
              isLoading = false;
            });
          }
          log('packagesData $packagesData');
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
          "Packages",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              isLoading
                  ? Center(child: CircularProgressIndicator(strokeWidth: 1))
                  : Center(),
              for (var rowData in packageList)
                rowData['tx_type'] == "purchase"
                    ? PackagesDiv(
                        amount: rowData['order_amount'],
                        date: rowData['added_on'],
                        token: rowData['token'],
                      )
                    : cryptoPackage(
                        coinName: rowData['coin_name'],
                        totalCoin: rowData['total_coin'],
                        amount: rowData['order_amount'],
                        liveRate: rowData['coin_rate'],
                        date: rowData['added_on'])
            ],
          ),
        ),
      ),
    );
  }
}
