import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task8/constantfile/constantfile.dart';
import 'package:task8/global/dataglobal.dart';
import 'package:task8/home/update_profile.dart';
import 'package:task8/login/splashscreen.dart';
import 'package:http/http.dart' as http;
import 'package:task8/model/modeluser.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 50, right: 20, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: ListTile(
                onTap: () async {
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          UpdateProfilePage(
                            data: dataGlobal.user,
                          )));

                  setState(() {

                  });

                },
                leading: dataGlobal?.user?.data?.fotoProfile == null
                    ? CircleAvatar(child: Image.asset("assets/images/foto-profile.png"),)
                    : Image.network("${ConstantFile.url + "upload/"}${dataGlobal?.user?.data?.fotoProfile}"),
                title: Text(
                  dataGlobal?.user?.data?.nama ?? '',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(dataGlobal?.user?.data?.email ?? ''),
                trailing: Icon(Icons.settings),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              child: ListTile(
                onTap: (){
                  Navigator.pop(context);
                },
                title: Text("Home"),
                trailing: Icon(Icons.arrow_right),
              ),
            ),
            SizedBox(height: 10),
            Text("v.3.7.0", style: TextStyle(color: Colors.grey),),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: MaterialButton(
          onPressed: () async{
            var prefs = await SharedPreferences.getInstance();
            prefs.clear();
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) => SplashScreenPage()), (route) => false);
          },
          height: 50,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none
          ),
          color: Colors.green,
          child: Text("Logout", style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
