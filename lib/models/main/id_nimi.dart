// To parse this JSON data, do
//
//     final tootajagrupp = tootajagruppFromJson(jsonString);

import 'dart:convert';

List<IdNimi> idNimiFromJson(String str) =>
    List<IdNimi>.from(json.decode(str).map((x) => IdNimi.fromJson(x)));

String idNimiToJson(List<IdNimi> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IdNimi {
  IdNimi({
    required this.id,
    required this.nimi,
  });

  int id;
  String nimi;

  factory IdNimi.fromJson(Map<String, dynamic> json) => IdNimi(
        id: json["id"],
        nimi: json["nimi"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nimi": nimi,
      };
}
