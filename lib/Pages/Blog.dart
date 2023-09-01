// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:wink30/utils/API.dart';
import 'package:wink30/utils/MyColors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class Blog extends StatefulWidget {
  const Blog({super.key});

  @override
  State<Blog> createState() => _BlogState();
}

class _BlogState extends State<Blog> {
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
    var url = Uri.parse(APIPaths.blog);
    var body = {'u_id': userId};
    try {
      var response = await http.post(url, body: body);
      print('res $response');
      if (response.statusCode == 200) {
        print('Login successful');
        print('response.body ${response.body}');
        var jsonData = await jsonDecode(response.body.toString());
        log("jkbjkbkg hj ggiuguo gohioh");
        if (jsonData['res'] == "success") {
          final data = jsonData['data'];
          setState(() {
            blogData = List<Map<String, dynamic>>.from(data);
            isLoading = false;
          });
          print('tableData $blogData');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.bgColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: MyColors.bgColor,
        title: const Text(
          "Blog",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ))
                  : const Center(),
              for (var data in blogData)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      color: MyColors.containerColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: (data['img']),
                          placeholder: (context, url) => Container(
                            width: 20,
                            height: 20,
                            child: const CircularProgressIndicator(
                              strokeWidth: 1,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        (data['added_on']).toString(),
                        style: GoogleFonts.poppins(
                            fontSize: 13.0, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        (data['title']).toString(),
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable.",
                        style: GoogleFonts.poppins(
                            fontSize: 13.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              // BlogPost(
              //   date: (data['added_on']).toString(),
              //   heading: (data['title']).toString(),
              //   subheading:
              //       "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable.",
              //   imagePath: (data['img']).toString(),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
