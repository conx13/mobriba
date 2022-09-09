// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  User({
    required this.enimi,
    required this.pnimi,
    required this.tid,
    required this.ikood,
    required this.ajagupp,
    required this.aktiivne,
    required this.toogruppId,
    this.telefon = '',
    required this.toogruppNimi,
    required this.ajanimi,
    this.pilt = '',
  });

  String enimi;
  String pnimi;
  int tid;
  String ikood;
  int ajagupp;
  int aktiivne;
  int toogruppId;
  String telefon;
  String toogruppNimi;
  String ajanimi;
  String pilt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        enimi: json["ENIMI"],
        pnimi: json["PNIMI"],
        tid: json["TID"],
        ikood: json["IKOOD"],
        ajagupp: json["AJAGUPP"],
        aktiivne: json["Aktiivne"],
        toogruppId: json["toogrupp_id"],
        telefon: json["telefon"] ?? '',
        toogruppNimi: json["toogrupp_nimi"],
        ajanimi: json["Ajanimi"],
        pilt: json["pilt"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ENIMI": enimi,
        "PNIMI": pnimi,
        "TID": tid,
        "IKOOD": ikood,
        "AJAGUPP": ajagupp,
        "Aktiivne": aktiivne,
        "toogrupp_id": toogruppId,
        "telefon": telefon,
        "toogrupp_nimi": toogruppNimi,
        "Ajanimi": ajanimi,
        "pilt": pilt,
      };
}
