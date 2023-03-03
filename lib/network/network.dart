import 'package:http/http.dart' as http;
import 'package:task8/constantfile/constantfile.dart';
import 'package:task8/model/listmodeluser.dart';
import 'package:task8/model/modeluser.dart';

class NetworkProvider{

  Future<ModelUser?> addSignup(
      String nama,
      String email,
      String password,
      ) async{

    final response = await http.post(Uri.parse(ConstantFile.url + "registrasi.php"),
    body: {
      "nama": nama,
      "email": email,
      "password": password
    }
    );

    ModelUser addUser = modelUserFromJson(response.body);
    return addUser;

  }


  Future<ModelUser?> getLoginPage(String email, String password,) async{

    final response = await http.post(Uri.parse(ConstantFile.url + "login.php"),
        body: {
          "email": email,
          "password": password
        },
        headers: {
        'Accept': 'application/json',
        }
    );

    try{
      ModelUser getUser = modelUserFromJson(response.body);
      if(getUser.status == 200){
        return getUser;
      }else{
        print("Data Error");
        return null;
      }
    }catch(exp){}
  }


  Future<List<DataUser>?> getShowUser() async{
    var response = await http.get(Uri.parse(ConstantFile.url + "select.php"));

    List<DataUser> listUser = await dataUserFromJson(response.body);
    return listUser;

  }

}