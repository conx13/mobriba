import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobriba/screens/tootajad/user_info_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/main/aktiivsed_model.dart';
import '../../services/api.dart';
import '../../widgets/main/mitte_akt_card.dart';

class PuuduvadEkraan extends StatefulWidget {
  const PuuduvadEkraan({Key? key}) : super(key: key);

  @override
  State<PuuduvadEkraan> createState() => _PuuduvadEkraanState();
}

extension IterableExtension<T> on Iterable<T> {
  Iterable<T> distinctBy(Object Function(T e) getCompareValue) {
    var result = <T>[];
    forEach((element) {
      if (!result.any((x) => getCompareValue(x) == getCompareValue(element))) {
        result.add(element);
      }
    });

    return result;
  }
}

class _PuuduvadEkraanState extends State<PuuduvadEkraan> {
  late Future _tanaPoleList;
  int _asukoht = 1;

  @override
  void initState() {
    _tanaPoleList = getAsukoht();
    super.initState();
  }

  Future getAsukoht() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.reload();
    setState(() {
      _asukoht = prefs.getInt('asukoht') ?? 1;
    });
    //log(prefs.getInt('asukoht').toString(), name: 'mitte tööl asukoht');
    return getMitteAktList(_asukoht);
  }

// Näitab töötaja infot:
  void naitaUserInfot(int tid) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserInfoPage(tid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('Hetkel mitteaktiivsed'),
        backgroundColor: Theme.of(context).errorColor,
      ),
      body: FutureBuilder(
        future: _tanaPoleList,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final puuduList =
                snapshot.data.mitteAktGrupid as List<MitteAktiivneGrupp>;
            //TODO Kui thta gruppe filtreerida
            var tooGrupid = puuduList.distinctBy((e) => e.tgruppNimi);
/*             var seen = <List<String>>{};
            List<MitteAktiivneGrupp> tooGrupid =
                puuduList.where((t) => seen.add(t.tgruppNimi)).toList(); */
            //log(tooGrupid.toString(), name: 'Töögrupid');
            return Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                itemCount: puuduList.length,
                itemBuilder: (BuildContext context, int index) {
                  return MitteAktCard(
                      puuduList[index].nimi,
                      puuduList[index].enimi,
                      puuduList[index].pnimi,
                      puuduList[index].pilt,
                      puuduList[index].tgruppNimi,
                      puuduList[index].tid,
                      naitaUserInfot);
                },
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('ERROR"'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
