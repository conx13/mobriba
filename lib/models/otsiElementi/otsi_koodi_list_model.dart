// To parse this JSON data, do
//
//     final otsiToodGrupp = otsiToodGruppFromJson(jsonString);

import 'dart:convert';

List<OtsiToodGrupp> otsiToodGruppFromJson(String str) =>
    List<OtsiToodGrupp>.from(
        json.decode(str).map((x) => OtsiToodGrupp.fromJson(x)));

String otsiToodGruppToJson(List<OtsiToodGrupp> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OtsiToodGrupp {
  String lepnr;
  String too;
  int jid;
  double kogus;
  String gnimi;
  bool ontoos;
  bool onresult;
  int tulem;

  OtsiToodGrupp(
      {required this.lepnr,
      required this.too,
      required this.jid,
      required this.kogus,
      required this.gnimi,
      required this.ontoos,
      required this.onresult,
      tulem}) //et paneme märgid kõlge kui on töös või mitte
      : tulem = (ontoos
            ? 1 // kui on töös
            : onresult
                ? 2 // kui ei ole töös aga on tehtud
                : 3); // ei ole töösse võetud

  factory OtsiToodGrupp.fromJson(Map<String, dynamic> json) => OtsiToodGrupp(
        lepnr: json["LEPNR"],
        too: json["TOO"],
        jid: json["JID"],
        kogus: json["KOGUS"],
        gnimi: json["GNIMI"],
        ontoos: json["ontoos"] == 0 ? false : true,
        onresult: json["onresult"] == 0 ? false : true,
      );

  Map<String, dynamic> toJson() => {
        "LEPNR": lepnr,
        "TOO": too,
        "JID": jid,
        "KOGUS": kogus,
        "GNIMI": gnimi,
        "ontoos": ontoos,
        "onresult": onresult,
        "tulem": tulem,
      };
}
