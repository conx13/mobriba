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
    required this.ajagrupp_id,
    required this.aktiivne,
    required this.toogruppId,
    this.telefon = '',
    required this.toogruppNimi,
    required this.ajanimi,
    this.pilt = '',
    required this.email,
    required this.firma,
    required this.firma_id,
    required this.asukoht,
    required this.asukoht_id,
  });

  String enimi;
  String pnimi;
  int tid;
  String ikood;
  int ajagrupp_id;
  int aktiivne;
  int toogruppId;
  String telefon;
  String toogruppNimi;
  String ajanimi;
  String pilt;
  String email;
  String firma;
  int firma_id;
  String asukoht;
  int asukoht_id;
  String get ntahed => '${enimi[0]}${pnimi[0]}';
  String get nimi => '$pnimi $enimi';

  factory User.fromJson(Map<String, dynamic> json) => User(
        enimi: json["ENIMI"],
        pnimi: json["PNIMI"],
        tid: json["TID"],
        ikood: json["IKOOD"],
        ajagrupp_id: json["AJAGUPP"] ?? 0,
        aktiivne: json["Aktiivne"],
        toogruppId: json["toogrupp_id"] ?? 0,
        telefon: json["telefon"] ?? '',
        toogruppNimi: json["toogrupp_nimi"],
        ajanimi: json["Ajanimi"],
        pilt: json["pilt"] ?? '',
        email: json['email'] ?? '',
        firma: json['firma'] ?? '',
        firma_id: json['firma_id'] ?? 0,
        asukoht: json['asukoht'] ?? '',
        asukoht_id: json['asukoht_id'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "ENIMI": enimi,
        "PNIMI": pnimi,
        "TID": tid,
        "IKOOD": ikood,
        "AJAGRUPP_ID": ajagrupp_id,
        "Aktiivne": aktiivne,
        "toogrupp_id": toogruppId,
        "telefon": telefon,
        "toogrupp_nimi": toogruppNimi,
        "Ajanimi": ajanimi,
        "pilt": pilt,
        'email': email,
        'firma': firma,
        'firma_id': firma_id,
        'asukoht': asukoht,
        'asukoht_id': asukoht_id,
        'ntahed': ntahed,
        'nimi': nimi
      };
}
