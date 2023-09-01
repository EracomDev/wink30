// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, file_names

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wink30/Pages/RegisterPage.dart';
import 'package:wink30/Pages/app_bottom_navigation.dart';
import 'package:wink30/utils/MyColors.dart';

import 'loginPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  String referralVal = "";
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    _animationController.forward();
    initDynamicLinks();
    //navigateToMainScreen();
  }


  Future<void> initDynamicLinks() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('userid').toString();

    print("userId"+userId);

    bool isLogin = false;

    if(userId=="null" || userId==""){

      isLogin=false;

    } else {
      isLogin=true;
    }

    var widgetBuilder;

    /*if(isLogin){
    //if(walletAddress.isNotEmpty){


      widgetBuilder = (context) => MainPage();

      if(mounted){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: widgetBuilder,
          ),
        );
      }

    } else {

      widgetBuilder = (context) => const LoginPage(username: "", password: "");
      //widgetBuilder = (context) => ();

      if(mounted){

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: widgetBuilder,
          ),
        );

      }

    }*/
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if(deepLink!=null){

      try{
        print(deepLink.queryParameters.toString());

        String id = deepLink.queryParameters['referral_id'].toString();
        //String position = deepLink.queryParameters['position'].toString();


        if(mounted){
          setState(() {
            referralVal = id;
            //positionVal = position;
          });
        }


        print("referral_id = $id");


      }
      catch(e){
        print("Error1=$e");
      }


    }


    //FirebaseDynamicLinks.instance.onLink(onSuccess:())



    dynamicLinks.onLink.listen((dynamicLinkData) {

      Uri uri = dynamicLinkData.link;

      if(uri!=null){

        try{
          String id = uri.queryParameters['referral_id'].toString();
          //String position = uri.queryParameters['position'].toString();
          print("referral_id = $id");

          if(mounted){
            setState(() {
              referralVal = id;
              //positionVal = position;
              //referralVal = id;
            });
          }


        }
        catch(e){
          print("Error2=$e");
        }

      }

      //Navigator.pushNamed(context, dynamicLinkData.link.path);
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });

    print("referralVal2=$referralVal");

    //WidgetBuilder widgetBuilder;

    if(referralVal.isNotEmpty){
      widgetBuilder = (context) => RegisterPage(referralId: referralVal,);

      if(mounted){
        Navigator. pushReplacement(
          context,
          MaterialPageRoute(
            builder: widgetBuilder,
          ),
        );
      }

    } else {


      if(isLogin){

        print("yessssssss");


        widgetBuilder = (context) =>  const AppBottomNavigation();

      } else {


        widgetBuilder = (context) =>const LoginPage();


      }

      if(mounted){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: widgetBuilder,
          ),
        );
      }

    }

  }

  Future<void> navigateToMainScreen() async {
    // Simulate a delay, e.g., for fetching data or performing initial setup
    await Future.delayed(const Duration(milliseconds: 3000));



    // Navigate to the main screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const AppBottomNavigation(),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)   {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
          255, 0, 0, 0), // Set the background color as per your needs
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Opacity(
              opacity: _animation.value,
              child: Container(
                decoration: const BoxDecoration(color: MyColors.bgColor),
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/logo.png",
                  width: 200,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
