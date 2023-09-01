// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:wink30/Pages/ChangePassword.dart';
import 'package:wink30/Pages/EditProfile.dart';
import 'package:wink30/utils/MyColors.dart';

// ignore: must_be_immutable
class EditUserData extends StatelessWidget {
  bool value = false;

  EditUserData({super.key});
  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

// ignore: use_key_in_widget_constructors
class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: MyColors.bgColor,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: MyColors.bgColor,
            bottom: TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[400],
              tabs: const [
                Tab(
                  child: Text("User Info"),
                ),
                Tab(
                  child: Text("Change Password"),
                ),
              ],
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            title: const Text(
              "Edit Profile",
              style: TextStyle(color: Colors.white),
            ),
          ),
          drawer: const Drawer(
            elevation: 0,
          ),
          body: const TabBarView(children: [EditProfile(), ChangePassword()]),
        ));
  }
}
