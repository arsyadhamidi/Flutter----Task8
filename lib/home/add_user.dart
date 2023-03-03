import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:task8/constantfile/constantfile.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({Key? key}) : super(key: key);

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {

  PickedFile? _imageFile;
  GlobalKey<FormState> _key = GlobalKey();
  TextEditingController _nama = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  Future<String?> validasiUser() async{
    if(_key.currentState!.validate()){
      if(_nama.text.isEmpty || _email.text.isEmpty || _password.text.isEmpty){
        print("Data is cannot be empty");
      }else{
        final uri = Uri.parse(ConstantFile.url + "addusers.php");
        var request = http.MultipartRequest('POST', uri);
        request.files.add(
            http.MultipartFile.fromBytes(
                'foto_profile',
                File(_imageFile?.path ?? '').readAsBytesSync(),
                filename: _imageFile?.path.split("/").last
            )
        );
        request.fields['nama'] = _nama.text;
        request.fields['email'] = _email.text;
        request.fields['password'] = _password.text;
        var res = await request.send();
        log(res.toString());
        Navigator.pop(context);
        return res.reasonPhrase;
      }
    }
  }

  Future<void> pilihGalery() async{
    try{
      var image = await ImagePicker.platform.pickImage(
          source: ImageSource.gallery, maxWidth: 1080, maxHeight: 1920
      );
      setState(() {
        _imageFile = image!;
      });
    }catch(exp){
      print(exp);
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

    var placeholder = Container(
      height: 200,
      width: 200,
      child: Image.asset("assets/images/foto-profile.png"),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Center(child: Text("Add User")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _key,
          child: ListView(
            children: [
              Container(
                child: InkWell(
                  onTap: (){
                    pilihGalery();
                  },
                  child: _imageFile == null ? placeholder :
                  Image.file(File(_imageFile?.path ?? ''), width: 200, height: 200,),
                ),
              ),

              SizedBox(height: 30),

              TextFormField(
                controller: _nama,
                decoration: InputDecoration(
                  hintText: "Full Name",
                  prefixIcon: Icon(CupertinoIcons.person),
                  border: OutlineInputBorder(
                    borderSide: BorderSide()
                  )
                ),
              ),

              SizedBox(height: 25),

              TextFormField(
                controller: _email,
                decoration: InputDecoration(
                    hintText: "Email Address",
                    prefixIcon: Icon(CupertinoIcons.envelope),
                    border: OutlineInputBorder(
                        borderSide: BorderSide()
                    )
                ),
              ),

              SizedBox(height: 25),

              TextFormField(
                obscureText: _obsurce,
                controller: _password,
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
                    hintText: "Password",
                    prefixIcon: Icon(CupertinoIcons.padlock),
                    border: OutlineInputBorder(
                        borderSide: BorderSide()
                    )
                ),
              ),

            ],
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: MaterialButton(
            onPressed: (){
              validasiUser();
            },
          color: Colors.green,
          height: 50,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none
          ),
          child: Text("Save", style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
