import 'dart:developer';
import 'dart:convert';

import '../../models/otsiElementi/elem_stats.dart';
import '../../models/otsiElementi/elemendi_info.dart';
import '../../models/otsiElementi/kestegi_model.dart';
import '../../models/otsiElementi/otsi_koodi_list_model.dart';

import '../services/http_service.dart';

import '../models/main/tana_grupid.dart';
import '../models/main/tootaja_grupp.dart';
import '../models/tootajad/user_model.dart';
import '../models/main/aktiivsed_model.dart';

/* -------------------------------------------------------------------------- */
/*                     Hetkel aktiivsed                                       */
/* -------------------------------------------------------------------------- */
Future<List<Aktiivsed>> getTanaTool(int asuk) async {
  var results = await
      //getData('/rkood/tanapoletool/$asuk').then((val) => aktiivsedFromJson(val)),
      getData('/rkood/tanatool/$asuk')
          .then((value) => aktiivsedFromJson(value));
  //log(results[0].toString(), name: 'gettanatool');
  return results;
/*   List<dynamic> aktiivsedList = [];
  aktiivsedList.add(results[0]);
  aktiivsedList.add(results[1]);
  return aktiivsedList; */
}

/* -------------------------------------------------------------------------- */
/*                            Hetkel mitteaktiivsed                           */
/* -------------------------------------------------------------------------- */
Future<List<Aktiivsed>> getTanaPoleTool(int asuk) async {
  var results = await getData('/rkood/tanapoletool/$asuk')
      .then((val) => aktiivsedFromJson(val));
  //getData('/rkood/tanatool/$asuk').then((value) => aktiivsedFromJson(value)),
  //log(results[0].toString(), name: 'gettanatool');
  return results;
/*   List<dynamic> aktiivsedList = [];
  aktiivsedList.add(results[0]);
  aktiivsedList.add(results[1]);
  return aktiivsedList; */
}

/* -------------------------------------------------------------------------- */
/*                              Aktiivsed grupid                              */
/* -------------------------------------------------------------------------- */
Future getTanaToolList(int asuk) async {
  //log('GETTÄNATÖÖL');
  var result = await getData('/rkood/tanatoollist/$asuk')
      .then((value) => AktiivsedGrupid.fromJson(json.decode(value)));
  //log(result.toString(), name: 'getTanaTööl');
  return result;
}

/* -------------------------------------------------------------------------- */
/*                          Mitte aktiivsed tootajad                          */
/* -------------------------------------------------------------------------- */
Future getMitteAktList(int asuk) async {
  var result = await getData('/rkood/tanapolelist/$asuk')
      .then((value) => MitteAktiivsedGrupid.fromJson(json.decode(value)));
  return result;
}

/* -------------------------------------------------------------------------- */
/*                                  User info                                 */
/* -------------------------------------------------------------------------- */
Future<User> getUser(int tid) async {
  var result =
      await getData('/users/$tid').then((value) => (userFromJson(value)));
  return result[0];
}

/* -------------------------------------------------------------------------- */
/*                               Töötajad grupis                              */
/* -------------------------------------------------------------------------- */
Future getAktGrupp(String ggrupp) async {
  //log(ggrupp, name: 'GGRUPP');
  var result = await getData('/rkood/tanagrupp/$ggrupp')
      .then((value) => gruppFromJson(value));
  return result;
}

/* -------------------------------------------------------------------------- */
/*                             Töötaja töö grupid                             */
/* -------------------------------------------------------------------------- */
Future getTootajaGrupp() async {
  log('getTootajaGrupp', name: 'GetTootajadGrupp');
  var result = await getData('/rkood/tootajagrupid')
      .then((value) => tootajagruppFromJson(value));
  //log(tootajagruppToJson(result), name: 'TOOTAJAGRUPP');
  return result;
}

/* -------------------------------------------------------------------------- */
/*                                Kustuta pilt                                */
/* -------------------------------------------------------------------------- */
Future delPilt(String pilt) async {
  log('delete pilt $pilt', name: 'Delete pilt');
  var result = await delData('/users/delpic/$pilt');
  //log(result.toString(), name: 'Pilt result');
  return result;
}

/* -------------------------------------------------------------------------- */
/*                                Otsi töötajat                               */
/* -------------------------------------------------------------------------- */
Future<List<User>> otsiTootajat(String otsiText, int akt) async {
  var result = await getData('/users/otsi/$otsiText/$akt')
      .then((value) => userFromJson(value));
  //log(otsiToodGruppToJson(result), name: 'OTSI TOOD');
  return result;
}

/* -------------------------------------------------------------------------- */
/*                                 Otsi koodi                                 */
/* -------------------------------------------------------------------------- */
Future<List<OtsiToodGrupp>> otsiTood(
    String leping, String too, bool elemendid) async {
  var result = await getData(
          '/rkood/otsiKoodi/leping/$leping/too/$too/elemendid/$elemendid')
      .then((value) => otsiToodGruppFromJson(value));
  //log(otsiToodGruppToJson(result), name: 'OTSI TOOD');
  return result;
}

/* -------------------------------------------------------------------------- */
/*                                  KES TEGI                                  */
/* -------------------------------------------------------------------------- */
Future<List<KesTegi>> kesTegi(int jid) async {
  var result = await getData('/rkood/kestegi/$jid')
      .then((value) => kesTegiFromJson(value));
  if (result.isEmpty) {
    //log('Kes tegi tühi');
    throw Exception("Ei ole andmeid!");
  } else {
    return result;
  }
}

/* -------------------------------------------------------------------------- */
/*                                Elemendi info                               */
/* -------------------------------------------------------------------------- */
Future<List<ElemInfo>> elemendiInfo(int jid) async {
  var result = await getData('/rkood/eleminfo/$jid')
      .then((value) => elemInfoFromJson(value));
  //log(elemInfoToJson(result), name: 'Elemendi info');
  return result;
}

/* -------------------------------------------------------------------------- */
/*                            Elemendi satatistika                            */
/* -------------------------------------------------------------------------- */
Future<List<ElemStats>> elemendiStats(int jid) async {
  var result = await getData('/rkood/elemstats/$jid').then(
    (value) => elemStatsFromJson(value),
  );
  return result;
}
