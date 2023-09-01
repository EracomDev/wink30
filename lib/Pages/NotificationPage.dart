// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:wink30/utils/MyColors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:wink30/utils/API.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isLoading = false;
  var dashboardData;
  List<Map<String, dynamic>> blogData = [];
  @override
  void initState() {
    super.initState();
    FetchData();
  }

  Future<void> FetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userid');
    print('token $userId');
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(APIPaths.notification);
    var body = {'u_id': userId};
    try {
      var response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        print('response.body ${response.body}');
        var jsonData = await jsonDecode(response.body.toString());
        if (jsonData['res'] == "success") {
          final data = jsonData['data'];
          setState(() {
            blogData = List<Map<String, dynamic>>.from(data);
            isLoading = false;
          });
          if (data.length <= 0) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red, content: Text("Data not found")));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.red, content: Text("Data not found")));
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
        backgroundColor: MyColors.bgColor,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: MyColors.bgColor,
          title: const Text(
            "Notifications",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: FetchData,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(strokeWidth: 1))
                    : const Center(),
                for (var data in blogData)
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: const BoxDecoration(
                            color: MyColors.containerColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image.asset("assets/images/wave.png", width: 50),
                                const Icon(
                                  Icons.notifications_active,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                    width:
                                        8), // Add spacing between the image and text
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (data['title']).toString(),
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        (data['message'])
                                            .toString()
                                            .replaceAll('<p>', '')
                                            .replaceAll('</p>', ''),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: GoogleFonts.poppins(
                                            color: const Color.fromARGB(
                                                255, 197, 197, 197),
                                            fontSize: 12),
                                      ),
                                      const SizedBox(
                                          height: 4), // Add vertical spacing
                                      Text(
                                        (data['added_on']).toString(),
                                        style: GoogleFonts.poppins(
                                            color: const Color.fromARGB(
                                                255, 197, 197, 197),
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ))
              ],
            ),
          ),
        ));
  }
}
