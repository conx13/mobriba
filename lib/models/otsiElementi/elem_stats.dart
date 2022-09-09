// To parse this JSON data, do
//
//     final elemStats = elemStatsFromJson(jsonString);

import 'dart:convert';

List<ElemStats> elemStatsFromJson(String str) =>
    List<ElemStats>.from(json.decode(str).map((x) => ElemStats.fromJson(x)));

String elemStatsToJson(List<ElemStats> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ElemStats {
  ElemStats({
    required this.jid,
    required this.kogus,
    required this.result,
  });

  int jid;
  double? kogus;
  int? result;

  factory ElemStats.fromJson(Map<String, dynamic> json) => ElemStats(
        jid: json["JID"],
        kogus: json["KOGUS"] == null ? 0 : json["KOGUS"].toDouble(),
        result: json["Result"] == null ? 0 : json["Result"].toInt(),
      );

  Map<String, dynamic> toJson() => {
        "JID": jid,
        "KOGUS": kogus,
        "Result": result,
      };
}
