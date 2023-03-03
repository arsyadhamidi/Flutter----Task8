import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task8/login/login.dart';
import 'package:task8/model/modeluser.dart';
import 'package:task8/network/network.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({Key? key}) : super(key: key);

  @override
  State<RegistrasiPage> createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {

  ModelUser? addDataUser;
  GlobalKey<FormState> _key = GlobalKey();
  TextEditingController _nama = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  void validasiRegistrasi() async{
    if(_key.currentState!.validate()){
      if(_nama.text.isEmpty || _email.text.isEmpty || _password.text.isEmpty){
        print("Data is cannot be empty");
      }else{
        final response = await NetworkProvider().addSignup(
            _nama.text,
            _email.text,
            _password.text
        );

        if(response!.status == 200){
          AwesomeDialog(
              context: context,
              btnOkColor: Colors.green,
              dialogType: DialogType.SUCCES,
              animType: AnimType.RIGHSLIDE,
              title: 'Register Information',
              desc: 'You have successfully registered',
          btnOkOnPress: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
          },
          )..show();
        }else{
          AwesomeDialog(
            context: context,
            btnCancelColor: Colors.red,
            dialogType: DialogType.ERROR,
            animType: AnimType.RIGHSLIDE,
            title: 'Register Information',
            desc: 'You failed to register',
            btnCancelOnPress: () {},
          )..show();
        }

      }
    }
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
                controller: _nama,
                decoration: InputDecoration(
                    hintText: "Full name...",
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
                validator: (n){
                  if(n!.isEmpty){
                    return "Data cannot be Empty";
                  }
                },
              ),
              SizedBox(height: 20),
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
                validator: (n){
                  if(n!.isEmpty){
                    return "Data cannot be Empty";
                  }
                },
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
                      ),
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
                validator: (n){
                  if(n!.isEmpty){
                    return "Data cannot be Empty";
                  }
                },
              ),
              SizedBox(height: 30),
              MaterialButton(
                onPressed: (){
                  validasiRegistrasi();
                },
                color: Colors.green,
                height: 50,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none
                ),
                minWidth: double.infinity,
                child: Text("Registrasi", style: TextStyle(color: Colors.white),),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("You have an account ?", style: TextStyle(fontSize: 16),),
                  TextButton(
                    onPressed: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text("Login !", style: TextStyle(fontSize: 16, color: Colors.green),),
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
