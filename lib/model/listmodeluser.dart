// To parse this JSON data, do
//
//     final dataUser = dataUserFromJson(jsonString);

import 'dart:convert';

List<DataUser> dataUserFromJson(String str) => List<DataUser>.from(json.decode(str).map((x) => DataUser.fromJson(x)));

String dataUserToJson(List<DataUser> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DataUser {
  DataUser({
    this.the0,
    this.the1,
    this.the2,
    this.the3,
    this.the4,
    this.idUsers,
    this.nama,
    this.email,
    this.password,
    this.fotoProfile,
  });

  String? the0;
  String? the1;
  String? the2;
  String? the3;
  dynamic the4;
  String? idUsers;
  String? nama;
  String? email;
  String? password;
  dynamic fotoProfile;

  factory DataUser.fromJson(Map<String, dynamic> json) => DataUser(
    the0: json["0"],
    the1: json["1"],
    the2: json["2"],
    the3: json["3"],
    the4: json["4"],
    idUsers: json["id_users"],
    nama: json["nama"],
    email: json["email"],
    password: json["password"],
    fotoProfile: json["foto_profile"],
  );

  Map<String, dynamic> toJson() => {
    "0": the0,
    "1": the1,
    "2": the2,
    "3": the3,
    "4": the4,
    "id_users": idUsers,
    "nama": nama,
    "email": email,
    "password": password,
    "foto_profile": fotoProfile,
  };
}
