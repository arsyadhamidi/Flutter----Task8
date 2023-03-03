import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task8/home/menu.dart';
import 'package:task8/login/registrasi.dart';
import 'package:task8/model/modeluser.dart';
import 'package:task8/network/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  GlobalKey<FormState> _key = GlobalKey();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  void validasiLogin() async{
    if(_key.currentState!.validate()){
      if(_email.text.isEmpty || _password.text.isEmpty){
        print("Data cannot be Empty");
      }else{
        ModelUser? getData = await NetworkProvider().getLoginPage(
            _email.text,
            _password.text
        );
        if(getData == null){
          print("Data Null");
        }else{
          ModelUser? dataUser = getData;
          print(
            "Data: ${dataUser.data?.idUsers}, ${dataUser.data?.nama}"
                "${dataUser.data?.email},"
          );
          await savePreferences(dataUser);
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => MenuPage()), (route) => false);
        }

      }
    }
  }

  Future<void> savePreferences(ModelUser dataUser) async{
    SharedPreferences prefsUser = await SharedPreferences.getInstance();
    prefsUser.setString('dataUser', jsonEncode(dataUser));
  }

  bool _obsurce = true;

  void inHidePassword(){
    if(_obsurce == true){
      setState(() {
        _obsurce = false;
      });
    }else{
      setState(() {
        _obsurce = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Form(
        key: _key,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Spacer(),
              Center(
                child: Image.asset("assets/images/logo.png", scale: 3),
              ),
              SizedBox(height: 50),
              TextFormField(
                controller: _email,
                decoration: InputDecoration(
                  hintText: "Email address...",
                  contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(50),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.circular(50),
                  )
                ),
                  validator: (e){
                    if(e!.isEmpty){
                      return "Please enter your email!";
                    }
                  }
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _password,
                obscureText: _obsurce,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: (){
                        inHidePassword();
                      },
                      icon: Icon(_obsurce
                          ? CupertinoIcons.eye_slash
                          : CupertinoIcons.eye
                      )
                  ),
                  hintText: "Password...",
                  contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(50),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.circular(50),
                  )
                ),
                  validator: (e){
                    if(e!.isEmpty){
                      return "Please enter your password!";
                    }
                  }
              ),
              SizedBox(height: 20),
              MaterialButton(
                onPressed: (){
                  validasiLogin();
                },
                color: Colors.green,
                height: 50,
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none
                ),
                minWidth: double.infinity,
                child: Text("Login", style: TextStyle(color: Colors.white),),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have your account ?", style: TextStyle(fontSize: 16),),
                  TextButton(
                      onPressed: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => RegistrasiPage()));
                      },
                      child: Text("Register !", style: TextStyle(fontSize: 16, color: Colors.green),),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
