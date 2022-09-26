// To parse this JSON data, do
//
//     final kesTegi = kesTegiFromJson(jsonString);

import 'dart:convert';

List<KesTegi> kesTegiFromJson(String str) =>
    List<KesTegi>.from(json.decode(str).map((x) => KesTegi.fromJson(x)));

String kesTegiToJson(List<KesTegi> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class KesTegi {
  KesTegi({
    required this.jid,
    required this.kpv,
    required this.start,
    required this.stop,
    required this.nimi,
    required this.enimi,
    required this.pnimi,
    required this.pilt,
    required this.tid,
    required this.koguAeg,
  });

  int jid;
  String kpv;
  DateTime? start;
  DateTime? stop;
  String nimi;
  String enimi;
  String pnimi;
  String pilt;
  int? tid;
  int? koguAeg;
  DateTime get praegu {
    return DateTime.now().toLocal();
  }

  int? get lisaAeg {
    if (stop == null) {
      return praegu.difference(start!).inMinutes;
    } else {
      return 0;
    }
  }

  factory KesTegi.fromJson(Map<String, dynamic> json) => KesTegi(
        jid: json["JID"],
        kpv: json["kpv"],
        start: json["START"] == null ? null : DateTime.parse(json["START"]),
        stop: json["STOP"] == null ? null : DateTime.parse(json["STOP"]),
        nimi: json["nimi"],
        enimi: json["ENIMI"],
        pnimi: json["PNIMI"],
        pilt: json["pilt"] ?? '',
        tid: json["TID"],
        koguAeg: json["sum_aeg"],
      );

  Map<String, dynamic> toJson() => {
        "JID": jid,
        "kpv": kpv,
        "START": start?.toIso8601String(),
        "STOP": stop?.toIso8601String(),
        "NIMI": nimi,
        "ENIMI": enimi,
        "PNIMI": pnimi,
        "PILT": pilt,
        "TID": tid,
        "koguAeg": koguAeg,
        "lisaAeg": lisaAeg,
        "praegu": praegu.toIso8601String(),
      };
}
