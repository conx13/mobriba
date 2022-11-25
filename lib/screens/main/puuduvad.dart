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

//Et listist saad unikaalsed
extension IterableExtension<T> on Iterable<T> {
  List<T> distinctBy(Object Function(T e) getCompareValue) {
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
  final List<String> _filters = [];
  List<MitteAktiivneGrupp>? _filteredList;
  final ScrollController _controller = ScrollController();

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
    log(prefs.getInt('asukoht').toString(), name: 'mitte tööl asukoht');
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

  void _scrollUp() {
    _controller.animateTo(
      _controller.position.minScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
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
            List<MitteAktiivneGrupp> tooGrupid =
                puuduList.distinctBy((e) => e.tgruppNimi);
            if (_filters.isNotEmpty) {
              _filteredList = puuduList
                  .where((element) => _filters.contains(element.tgruppNimi))
                  .toList();
            } else {
              _filteredList = puuduList;
            }
            //_controller.jumpTo(_controller.position.minScrollExtent);
            return Column(
              //mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      itemCount: tooGrupid.length,
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: FilterChip(
                            label: Text(tooGrupid[index].tgruppNimi),
                            selected:
                                _filters.contains(tooGrupid[index].tgruppNimi),
                            selectedColor: Theme.of(context).errorColor,
                            backgroundColor: Colors.green,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _filters.add(
                                      tooGrupid[index].tgruppNimi.toString());
                                } else {
                                  _filters.removeWhere((name) {
                                    return name ==
                                        tooGrupid[index].tgruppNimi.toString();
                                  });
                                }
                                //_controller.jumpTo(_controller.position
                                //    .minScrollExtent); //Igaksjuhuks kerime üles
                              });
                            },
                          ),
                        );
                      })),
                ),
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: ListView.builder(
                      //controller: _controller,
                      shrinkWrap: true,
                      itemCount: _filteredList!.length,
                      itemBuilder: (BuildContext context, int index) {
                        //log('tekitame puudujate listi', name: 'Puudujate list');
                        return MitteAktCard(
                            _filteredList![index].nimi,
                            _filteredList![index].enimi,
                            _filteredList![index].pnimi,
                            _filteredList![index].pilt,
                            _filteredList![index].tgruppNimi,
                            _filteredList![index].tid,
                            naitaUserInfot);
                      },
                    ),
                  ),
                ),
              ],
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
