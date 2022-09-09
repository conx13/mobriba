// To parse this JSON data, do
//
//     final grupp = gruppFromJson(jsonString);

import 'dart:convert';

List<Grupp> gruppFromJson(String str) =>
    List<Grupp>.from(json.decode(str).map((x) => Grupp.fromJson(x)));

String gruppToJson(List<Grupp> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Grupp {
  Grupp(
      {required this.nimi,
      required this.enimi,
      required this.pnimi,
      required this.lepnr,
      required this.too,
      required this.gnimi,
      required this.start,
      required this.gid,
      required this.tid,
      required this.ggrupp,
      required this.kogus});

  String nimi;
  String enimi;
  String pnimi;
  String lepnr;
  String too;
  String gnimi;
  DateTime start;
  int gid;
  int tid;
  String ggrupp;
  double kogus;

  factory Grupp.fromJson(Map<String, dynamic> json) => Grupp(
        nimi: json["Nimi"],
        enimi: json["ENIMI"],
        pnimi: json["PNIMI"],
        lepnr: json["LEPNR"],
        too: json["TOO"],
        gnimi: json["GNIMI"],
        start: DateTime.parse(json["START"]),
        gid: json["GID"],
        tid: json["TID"],
        ggrupp: json["GGRUPP"],
        kogus: json["KOGUS"] == null ? 0 : json["KOGUS"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "NIMI": nimi,
        "LEPNR": lepnr,
        "TOO": too,
        "GNIMI": gnimi,
        "START": start.toIso8601String(),
        "GID": gid,
        "TID": tid,
        "GGRUPP": ggrupp,
      };
}
