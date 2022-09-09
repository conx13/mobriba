// To parse this JSON data, do
//
//     final tootajagrupp = tootajagruppFromJson(jsonString);

import 'dart:convert';

List<Tootajagrupp> tootajagruppFromJson(String str) => List<Tootajagrupp>.from(
    json.decode(str).map((x) => Tootajagrupp.fromJson(x)));

String tootajagruppToJson(List<Tootajagrupp> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Tootajagrupp {
  Tootajagrupp({
    required this.toogruppId,
    required this.toogruppNimi,
  });

  int toogruppId;
  String toogruppNimi;

  factory Tootajagrupp.fromJson(Map<String, dynamic> json) => Tootajagrupp(
        toogruppId: json["toogrupp_id"],
        toogruppNimi: json["toogrupp_nimi"],
      );

  Map<String, dynamic> toJson() => {
        "toogrupp_id": toogruppId,
        "toogrupp_nimi": toogruppNimi,
      };
}
