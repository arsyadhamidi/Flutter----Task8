import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task8/constantfile/constantfile.dart';
import 'package:task8/global/dataglobal.dart';
import 'package:task8/home/add_user.dart';
import 'package:task8/home/profile.dart';
import 'package:task8/home/update_data.dart';
import 'package:task8/model/listmodeluser.dart';
import 'package:task8/network/network.dart';
import 'package:http/http.dart' as http;

import '../model/modeluser.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  Future<void> getUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var users = prefs.getString("dataUser");
    print(jsonDecode(users ?? ''));
    setState(() {
      dataGlobal.user = modelUserFromJson(users ?? '');
    });
  }

  List<DataUser>? listUser;

  Future<List<DataUser>?> listDataUser() async{
    try{
      List<DataUser>? response = await NetworkProvider().getShowUser();
      setState(() {
        listUser = response;
      });
    }catch(exp){}

    return listUser;
  }

  Future<List<DataUser>?> hapusUser(String? id_users) async{
    try{
      final response = await http.post(Uri.parse(ConstantFile.url + "delete.php"),
          body: {
            "id_users": id_users,
          });
      List<DataUser> hapusdataUser = await dataUserFromJson(response.body);
      if(hapusdataUser == 200){
        Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPage()));
        print("Data Delete Successfully");
        return hapusdataUser;
      }else{
        print("Data Is Not Delete Successfully");
      }
    }catch(exp){}
  }

  @override
  void initState() {
    listDataUser();
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Udacoding"),
        actions: [
          dataGlobal?.user?.data?.fotoProfile == null
          ? IconButton(
              onPressed: (){
                setState(() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfilePage()));
                });
                if(mounted){
                  listDataUser();
                }
              },
              icon: Icon(CupertinoIcons.person_crop_circle, size: 30)
          ) : MaterialButton(onPressed: (){
            setState(() {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            });

            if(mounted){
              listDataUser();
            }
          },
            child: Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage("${ConstantFile.url + "upload/"}${dataGlobal?.user?.data?.fotoProfile}"),
                backgroundColor: Colors.transparent,
              ),
            )
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
            itemCount: listUser?.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                    onTap: () async{
                      await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          UpdateDataPage(data: listUser?[index]),
                      ));

                      if(mounted){
                        listDataUser();
                      }
                    },
                    leading: listUser?[index].fotoProfile == null
                        ? Image.asset("assets/images/foto-profile.png",)
                        : Image.network(
                        "${ConstantFile.url + "upload/"}${listUser?[index].fotoProfile}"
                    ),
                    title: Text(
                      listUser?[index].nama ??'',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    trailing: IconButton(
                        onPressed: (){
                         setState(() {
                           hapusUser(listUser?[index].idUsers ?? '');
                         });
                         listDataUser();
                        },
                        icon: Icon(Icons.delete)
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(listUser?[index].email ?? '')
                      ],
                    ),
                  ),
                ),
              );
            },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () async{

           await Navigator.push(context, MaterialPageRoute(builder:
              (context) => AddUserPage()));

          if(mounted){
            listDataUser();
          }

        },
        child: Icon(CupertinoIcons.add),
      ),
    );
  }
}
