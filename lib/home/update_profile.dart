import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task8/constantfile/constantfile.dart';
import 'package:task8/global/dataglobal.dart';
import 'package:task8/model/modeluser.dart';
import 'package:http/http.dart' as http;

class UpdateProfilePage extends StatefulWidget {

  final ModelUser? data;

  UpdateProfilePage({Key? key, this.data}) : super(key: key);

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {

  TextEditingController _nama = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  PickedFile? _imageFile;

  Future<String?> updateDataUser() async{
    final uri = Uri.parse(ConstantFile.url + "update.php");
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
    request.fields['id_users'] = widget?.data?.data?.idUsers ?? '';
    var res = await request.send();

    var prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    ModelUser userData = ModelUser(data: dataGlobal.user?.data);
    userData.data?.nama = _nama.text;
    userData.data?.email = _email.text;
    userData.data?.password = _password.text;

    dataGlobal.user?.data = userData?.data;

    await sharedPreferences(userData);

    log(res.toString());
    Navigator.pop(context);
    return res.reasonPhrase;
  }

  Future<void> sharedPreferences(ModelUser? userData)async{
    SharedPreferences prefsUser = await SharedPreferences.getInstance();
    prefsUser.setString('userData', jsonEncode(userData));
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

  @override
  void initState() {
    _nama.text = widget?.data?.data?.nama ?? '';
    _email.text = widget?.data?.data?.email ?? '';
    _password.text = widget?.data?.data?.password ?? '';
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Center(
          child: Text("Update Profile"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(
              height: 250,
              width: 250,
              child: InkWell(
                onTap: (){
                  pilihGalery();
                },
                child: _imageFile == null ? Image.network(
                    "${ConstantFile.url + "upload/"}${widget.data?.data?.fotoProfile ?? ''}",
                  fit: BoxFit.fill,
                )  :
                Image.file(File(_imageFile?.path ?? ''), fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: _nama,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide()
                )
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _email,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide()
                  )
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _password,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide()
                  )
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: MaterialButton(
            onPressed: (){
              updateDataUser();
            },
          color: Colors.green,
          height: 50,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none
          ),
          child: Text("Save Change", style: TextStyle(color: Colors.white),),
        ),
      ),

    );
  }
}
