//import 'dart:developer';

import 'dart:developer';

import 'package:intl/intl.dart';
//import 'package:collection/collection.dart';
import 'package:mobriba/models/main/id_nimi.dart';

class Abiks {
  void arvutaId() {
    const String id = '50105030076';
    const List kont1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 1];
    const List kont2 = [3, 4, 5, 6, 7, 8, 9, 1, 2, 3];
    //bool ok = false;
    num tulem = 0;
    //int tul = 0;
    String yy = '';
    num sajand = 0;
    String aasta = '';
    String kuu = '';
    String paev = '';
    var now = DateTime.now();
    var formatter = DateFormat('yyyyMMdd');
    int tanaDate = 0;
    int synniDate = 0;
    for (var i = 0; i < 10; i++) {
      tulem += kont1[i] * (int.parse((id[i])));
    }
    tulem = tulem % 11;
    if (tulem == 10) {
      //print('vers2');
      tulem = 0;
      for (var i = 0; i < 10; i++) {
        tulem += kont2[i] * (int.parse((id[i])));
      }
      tulem = tulem % 11;
      if (tulem == 10) {
        tulem = 0;
      }
    }

    sajand = int.parse((id[0]));
    yy = id[1] + id[2];
    aasta =
        (((17 + (sajand + 1) / 2).floor()) * 100 + int.parse(yy)).toString();
    kuu = '${id[3]}${id[4]}';
    paev = '${id[5]}${id[6]}';

    synniDate = int.parse(aasta + kuu + paev);
    tanaDate = int.parse(formatter.format(now));
    log(((tanaDate - synniDate).toString()).substring(0, 2),
        name: 'Vanus'); //Vanus

    log((tulem.toString() == id[10]).toString(),
        name: 'Kas ID on ok'); //kas ID on õige
  }

// Otsib listist IdNimi id järgi, tagastab nime
  static findIdNimiById(List<IdNimi> list, int id) {
    findById(obj) => obj.id == id;
    var result = list.where(findById);
    return result.isNotEmpty ? result.first.nimi : null;
  }
}
