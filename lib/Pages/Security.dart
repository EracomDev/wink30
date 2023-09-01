import 'package:flutter/material.dart';
import 'package:wink30/Pages/VerifyOTP.dart';
import 'package:wink30/utils/MyColors.dart';
import 'dart:convert';
import 'package:wink30/utils/API.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

class Security extends StatefulWidget {
  const Security({super.key});

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  var dashboardData;
  var documentData;
  File? _image;
  @override
  void initState() {
    super.initState();
    FetchData();
    fetchDocumentData();
  }

  Future<void> _pickImage() async {
    File? pickedImage = await pickImage();
    setState(() {
      _image = pickedImage;
    });
  }

  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<void> _uploadImage() async {
    if (_image != null) {
      await uploadImageToApi(_image!);
    }
  }

  Future<void> uploadImageToApi(File imageFile) async {
    setState(() {
      isLoading2 = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userid');
    print('token $userId');
    final url = APIPaths.uploadDocument; // Replace with your API endpoint

    // Read the image file as bytes
    List<int> imageBytes = await imageFile.readAsBytes();

    // Encode the image data using base64 encoding
    String base64Image = base64Encode(imageBytes);

    // Create the request body
    var requestBody = {
      'u_id': userId,
      'identity_image': base64Image,
    };
    try {
      var response = await http.post(
        Uri.parse(url),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        var jsonData = await jsonDecode(response.body.toString());
        if (jsonData['res'] == "success") {
          setState(() {
            isLoading2 = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              content: Text(jsonData['message'])));
        } else {
          setState(() {
            isLoading2 = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red, content: Text(jsonData['message'])));
        }
        print(response.body);
      } else {
        setState(() {
          isLoading2 = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green, content: Text("Failed")));
      }
    } catch (e) {
      setState(() {
        isLoading2 = false;
      });
      print('Image upload error: $e');
    }
  }

  Future<void> FetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = await prefs.getString('userid');
    print('token $userId');
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(APIPaths.dashboard);
    var body = {'u_id': userId};
    try {
      var response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        log('response.body ${response.body}');
        var jsonData = await jsonDecode(response.body.toString());
        if (jsonData['res'] == "success") {
          setState(() {
            dashboardData = jsonData;
            emailController.text = dashboardData?['profile']?[0]?['email'];
            isLoading = false;
          });
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

  Future<void> fetchDocumentData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = await prefs.getString('userid');
    print('token $userId');
    setState(() {
      isLoading2 = true;
    });
    var url = Uri.parse(APIPaths.getDocumentData);
    var body = {'u_id': userId};
    try {
      var response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        log('response.body ${response.body}');
        var jsonData = await jsonDecode(response.body.toString());
        if (jsonData['res'] == "success") {
          setState(() {
            documentData = jsonData['data'];
            isLoading2 = false;
          });
        } else {
          setState(() {
            isLoading2 = false;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Failed to fetch data")));
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

  var emailController = TextEditingController();
  bool isLoading = false;
  bool isLoading2 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.bgColor,
      appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: MyColors.bgColor,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text("Security", style: TextStyle(color: Colors.white))),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              dashboardData?['profile']?[0]?['is_email_verify'] == "1"
                  ? Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: MyColors.containerColor,
                      ),
                      child: Row(children: [
                        Image.asset(width: 50, "assets/images/kyc.png"),
                        const SizedBox(width: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Email Verified",
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(width: 5),
                                Image.asset(
                                    width: 20, "assets/images/check.png"),
                              ],
                            ),
                            Text(
                              dashboardData?['profile']?[0]?['email'],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ]),
                    )
                  : Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                          color: MyColors.containerColor,
                          borderRadius: BorderRadius.circular(25)),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Document Verification",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Image.asset(
                            width: 150,
                            height: 150,
                            "assets/images/padlock.png",
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 50),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              textAlign: TextAlign.center,
                              "Your Email Address To Receive a Verification Code.",
                              style: TextStyle(
                                  height: 1.4,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            enabled: false,
                            // keyboardType: TextInputType.number,
                            controller: emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              labelStyle: const TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: const Color.fromARGB(83, 66, 66, 66),
                              prefixIcon: const Icon(Icons.mail_outlined,
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
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          isLoading == true
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                  ),
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  child: SizedBox(
                                    width: 200.0,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        sendOtp();
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
                                        'Send OTP',
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
              documentData?['pan_kyc_status'] == "submitted"
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(top: 20),
                      decoration: const BoxDecoration(
                          color: MyColors.containerColor,
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            fit: BoxFit.contain,
                            width: 150,
                            imageUrl: documentData?['pan_image'],
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                const Text("data"),
                          ),
                          const Text(
                            "Pending Request",
                            style: TextStyle(color: MyColors.primaryColor),
                          )
                        ],
                      ),
                    )
                  : documentData?['pan_kyc_status'] == "approved"
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.only(top: 20),
                          decoration: const BoxDecoration(
                              color: MyColors.containerColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          child: Row(
                            children: [
                              CachedNetworkImage(
                                fit: BoxFit.contain,
                                width: 80,
                                imageUrl: documentData?['pan_image'],
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    const Text("data"),
                              ),
                              const SizedBox(width: 20),
                              Row(
                                children: [
                                  const Text(
                                    "Document Verified",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(width: 5),
                                  Image.asset(
                                      width: 20, "assets/images/check.png"),
                                ],
                              )
                            ],
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                              color: MyColors.containerColor,
                              borderRadius: BorderRadius.circular(25)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Document Verification",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              ),
                              _image != null
                                  ? Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      child: Image.file(_image!))
                                  : Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 42, 49, 65),
                                          padding: const EdgeInsets.all(0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                20), // Set the border radius to zero
                                          ),
                                        ),
                                        onPressed: _pickImage,
                                        child: const Icon(
                                          Icons.image,
                                          size: 150,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                              isLoading2
                                  ? Container(
                                      margin: EdgeInsets.all(20),
                                      child: const Center(
                                          child: CircularProgressIndicator(
                                              strokeWidth: 1)),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                MyColors.primaryColor),
                                        onPressed: _uploadImage,
                                        child: const Text(
                                          'Upload Image',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendOtp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userid');
    print(emailController.text);
    print(APIPaths.fundConvert);
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(APIPaths.sendOtp);
    var body = {'u_code': userId, 'otp_type': "email"};
    try {
      var response = await http.post(url, body: body);
      print(response);
      if (response.statusCode == 200) {
        print(response.statusCode);
        print(response.body);
        var responseBody = await jsonDecode(response.body);
        if (responseBody['res'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              content: Text(responseBody?['message'])));
          setState(() {
            isLoading = false;
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      VerifyOTP(emailAddress: emailController.text)));
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text(responseBody?['message'])));
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
  }
}
