import 'package:flutter/material.dart';
import 'package:wink30/utils/MyColors.dart';
import 'dart:convert';
import 'package:wink30/utils/API.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class MetaRequest extends StatefulWidget {
  const MetaRequest({super.key});

  @override
  State<MetaRequest> createState() => _MetaRequestState();
}

class _MetaRequestState extends State<MetaRequest>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
          seconds: 4), // Change the duration as per your requirement
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> MetaRequest() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userid');
    if (!mounted) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(APIPaths.metaRequest);
    var body = {'u_id': userId};
    try {
      var response = await http.post(url, body: body);
      print('res $response');
      if (response.statusCode == 200) {
        print('response.body ${response.body}');
        var jsonData = await jsonDecode(response.body.toString());
        if (jsonData['res'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              content: Text(jsonData['message'])));
          setState(() {
            isLoading = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red, content: Text(jsonData['message'])));
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
          backgroundColor: MyColors.bgColor,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Meta Request",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(40),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                color: MyColors.containerColor,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Container(
                    alignment: Alignment.center,
                    child: RotationTransition(
                      turns: _controller,
                      child: Image.asset(
                          fit: BoxFit.cover,
                          width: 150,
                          height: 150,
                          'assets/images/metabig.png'),
                    )),
                const SizedBox(height: 40),
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ))
                    : GestureDetector(
                        onTap: () {
                          MetaRequest();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          decoration: BoxDecoration(
                              color: MyColors.primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          width: double.infinity,
                          child: const Text(
                            "Click",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ));
  }
}
