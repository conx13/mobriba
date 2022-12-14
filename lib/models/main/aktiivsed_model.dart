import 'dart:convert';

/* -------------------------------------------------------------------------- */
/*                               Klass Aktiivsed                              */
/* -------------------------------------------------------------------------- */
// To parse this JSON data, do
//
//     final aktiivsed = aktiivsedFromJson(jsonString);

List<Aktiivsed> aktiivsedFromJson(String str) =>
    List<Aktiivsed>.from(json.decode(str).map((x) => Aktiivsed.fromJson(x)));

String aktiivsedToJson(List<Aktiivsed> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Aktiivsed {
  Aktiivsed({
    required this.tulem,
  });

  int tulem;

  factory Aktiivsed.fromJson(Map<String, dynamic> json) => Aktiivsed(
        tulem: json["tulem"],
      );

  Map<String, dynamic> toJson() => {
        "data": tulem,
      };
}

/* -------------------------------------------------------------------------- */
/*                            Klass AktiivsedGrupid                           */
/* -------------------------------------------------------------------------- */
class AktiivsedGrupid {
  final List<AktiivneGrupp> aktGrupid;

  AktiivsedGrupid({
    required this.aktGrupid,
  });

  factory AktiivsedGrupid.fromJson(List<dynamic> parsedJson) {
    var aktGrupid = <AktiivneGrupp>[];
    aktGrupid = parsedJson.map((i) => AktiivneGrupp.fromJson(i)).toList();
    return AktiivsedGrupid(aktGrupid: aktGrupid);
  }
}

class AktiivneGrupp {
  final String gnimi;
  final int kokku;

  AktiivneGrupp({
    required this.gnimi,
    required this.kokku,
  });

  factory AktiivneGrupp.fromJson(Map<String, dynamic> json) {
    return AktiivneGrupp(
      gnimi: json['GGRUPP'].toString(),
      kokku: json['Kokku'],
    );
  }
}
/* -------------------------------------------------------------------------- */
/*                         Klass MitteAktiivsedGrupid                         */
/* -------------------------------------------------------------------------- */

class MitteAktiivsedGrupid {
  final List<MitteAktiivneGrupp> mitteAktGrupid;

  MitteAktiivsedGrupid({
    required this.mitteAktGrupid,
  });

  factory MitteAktiivsedGrupid.fromJson(List<dynamic> parsedJson) {
    var mitteAktGrupid = <MitteAktiivneGrupp>[];
    mitteAktGrupid =
        parsedJson.map((i) => MitteAktiivneGrupp.fromJson(i)).toList();
    return MitteAktiivsedGrupid(mitteAktGrupid: mitteAktGrupid);
  }
}

class MitteAktiivneGrupp {
  final String nimi;
  final String enimi;
  final String pnimi;
  final String pilt;
  final int tid;
  final int tgruppId;
  final String tgruppNimi;

  MitteAktiivneGrupp(
      {required this.nimi,
      required this.enimi,
      required this.pnimi,
      required this.pilt,
      required this.tid,
      required this.tgruppId,
      required this.tgruppNimi});

  factory MitteAktiivneGrupp.fromJson(Map<String, dynamic> json) {
    return MitteAktiivneGrupp(
      nimi: json['nimi'],
      enimi: json['ENIMI'],
      pnimi: json['PNIMI'],
      pilt: json['pilt'] ?? '',
      tid: json['TID'],
      tgruppId: json['toogrupp_id'],
      tgruppNimi: json['toogrupp_nimi'],
    );
  }
}
