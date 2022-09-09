/* -------------------------------------------------------------------------- */
/*                               Klass Aktiivsed                              */
/* -------------------------------------------------------------------------- */
class Aktiivsed {
  final int data;

  const Aktiivsed({
    required this.data,
  });
  //factory Aktiivsed.fromJson(String str) => Aktiivsed.fromMap(json.decode(str));

  //factory Aktiivsed.fromMap(Map<String, dynamic> json) => Aktiivsed(
  factory Aktiivsed.fromJson(Map<String, dynamic> json) {
    return Aktiivsed(
      data: json["data"],
    );
  }
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
  final int tid;
  final int tgruppId;
  final String tgruppNimi;

  MitteAktiivneGrupp(
      {required this.nimi,
      required this.tid,
      required this.tgruppId,
      required this.tgruppNimi});

  factory MitteAktiivneGrupp.fromJson(Map<String, dynamic> json) {
    return MitteAktiivneGrupp(
      nimi: json['Nimi'].toString(),
      tid: json['TID'],
      tgruppId: json['toogrupp_id'],
      tgruppNimi: json['toogrupp_nimi'],
    );
  }
}
