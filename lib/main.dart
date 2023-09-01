import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wink30/Pages/SplashScreen.dart';
import 'package:wink30/utils/MyColors.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    // Android will work via Dart initialisation
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDrYx__lrWPDbULH7cbW-_oiII-yviueHU',
        appId: '1:397476967603:android:4759c2beaa7708ff20acc6',
        messagingSenderId: '397476967603',
        projectId: 'wink30-7d598',
        // authDomain: 'react-native-firebase-testing.firebaseapp.com',
        //iosClientId: '448618578101-4km55qmv55tguvnivgjdiegb3r0jquv5.apps.googleusercontent.com',
      ),
    );
  } else {
    // iOS requires that there is a GoogleService-Info.plist otherwise getInitialLink & getDynamicLink will not work correctly.
    // iOS also requires you run in release mode to test dynamic links ("flutter run --release").
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wink30',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: MyColors.primaryColor),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

/*class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppBottomNavigation();
  }
}*/
