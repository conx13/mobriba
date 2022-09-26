// To parse this JSON data, do
//
//     final elemInfo = elemInfoFromJson(jsonString);

import 'dart:convert';

List<ElemInfo> elemInfoFromJson(String str) =>
    List<ElemInfo>.from(json.decode(str).map((x) => ElemInfo.fromJson(x)));

String elemInfoToJson(List<ElemInfo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ElemInfo {
  ElemInfo({
    required this.lepnr,
    required this.job,
    required this.kogus,
    required this.markus,
    required this.ggrupp,
    required this.gnimi,
    required this.jid,
  });

  String lepnr;
  String job;
  double? kogus;
  dynamic markus;
  String ggrupp;
  String gnimi;
  int jid;

  factory ElemInfo.fromJson(Map<String, dynamic> json) => ElemInfo(
        lepnr: json["LEPNR"],
        job: json["JOB"],
        kogus: json["KOGUS"] == null ? 0 : json["KOGUS"].toDouble(),
        markus: json["Markus"],
        ggrupp: json["GGRUPP"],
        gnimi: json["GNIMI"],
        jid: json["JID"],
      );

  Map<String, dynamic> toJson() => {
        "LEPNR": lepnr,
        "JOB": job,
        "KOGUS": kogus,
        "Markus": markus,
        "GGRUPP": ggrupp,
        "GNIMI": gnimi,
        "JID": jid,
      };
}
