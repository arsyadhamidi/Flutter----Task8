import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task8/home/menu.dart';
import 'package:task8/login/login.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  void showSplash(){
    Timer(Duration(seconds: 3), () async {
      var prefs = await SharedPreferences.getInstance();
      var data = prefs.get("dataUser");
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context)
          => data != null ? MenuPage() : LoginPage()), (route) => false);
    });
  }

  @override
  void initState() {
    showSplash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Spacer(),
          Center(
            child: Image.asset("assets/images/logo.png"),
          ),
          Spacer(),
          Center(
            child: Text("Magang Udacoding",
              style: TextStyle(fontSize: 20,),),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
