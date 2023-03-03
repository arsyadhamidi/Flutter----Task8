import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task8/constantfile/constantfile.dart';
import 'package:task8/model/listmodeluser.dart';
import 'package:http/http.dart' as http;

class UpdateDataPage extends StatefulWidget {

  final DataUser? data;

  UpdateDataPage({Key? key, this.data}) : super(key: key);

  @override
  State<UpdateDataPage> createState() => _UpdateDataPageState();
}

class _UpdateDataPageState extends State<UpdateDataPage> {

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
    request.fields['id_users'] = widget.data?.idUsers ?? '';
    var res = await request.send();
    log(res.toString());
    Navigator.pop(context);
    return res.reasonPhrase;
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
    _nama.text = widget.data?.nama ?? '';
    _email.text = widget.data?.email ?? '';
    _password.text = widget.data?.password ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Center(child: Text("Update Data")),
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
                    "${ConstantFile.url + "upload/"}${widget.data?.fotoProfile}"
                )  :
                Image.file(File(_imageFile?.path ?? ''), fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: 25),
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
          height: 50,
          shape: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(50),
          ),
          onPressed: () async{
            await updateDataUser();
            setState(() {

            });
          },
          color: Colors.green,
          child: Text("Save Change", style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
