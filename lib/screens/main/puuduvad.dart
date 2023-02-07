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

//Et listist saad unikaalsed välja
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
  //String _kokkuPuudu = '0';
  final List<String> _filters = [];
  List<MitteAktiivneGrupp>? _filteredList;
  List<MitteAktiivneGrupp>? _puuduList;
  List<MitteAktiivneGrupp>? _tooGrupid;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    _tanaPoleList = getAsukoht();
    super.initState();
  }

// Võtame vaikimisi asukoha ja siis seal puudujad
  Future getAsukoht() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.reload();
    setState(() {
      _asukoht = prefs.getInt('asukoht') ?? 1;
    });
    // log(prefs.getInt('asukoht').toString(), name: 'mitte tööl asukoht');
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
        //TODO title: Text('Hetkel mitteaktiivsed $_kokkuPuudu'),
        backgroundColor: Theme.of(context).errorColor,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: _tanaPoleList,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            // tekitame puudujate listi baasist
            _puuduList = snapshot.data.mitteAktGrupid;
            // tekitame töögruppide listi
            _tooGrupid = _puuduList!.distinctBy((e) => e.tgruppNimi);
            // Kui on valitud mõni grupp siis filtreerime välja
            if (_filters.isNotEmpty) {
              _filteredList = _puuduList!
                  .where((element) => _filters.contains(element.tgruppNimi))
                  .toList();
            } else {
              // kui filter on tühi siis = _puuduList
              _filteredList = _puuduList;
            }
            //_kokkuPuudu = _filteredList!.length.toString();
            //log('Kokku puudujaid filtris: ${_filteredList!.length}');
            //_kokkuPuudu = _filteredList!.length.toString();
            //_controller.jumpTo(_controller.position.minScrollExtent);
            return Column(
              //mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 60,
                  //TODO palju lihtsam oleks võtta otse baasist jne
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      itemCount: _tooGrupid!.length,
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: FilterChip(
                            label: Text(_tooGrupid![index].tgruppNimi),
                            selected: _filters
                                .contains(_tooGrupid![index].tgruppNimi),
                            //selectedColor: Theme.of(context).errorColor,
                            //backgroundColor: Colors.green,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  //kui on selected, siis puhastame listi ja märgime uue selecti
                                  _filters.clear();
                                  _filters.add(
                                      _tooGrupid![index].tgruppNimi.toString());
                                } else {
                                  _filters.removeWhere((name) {
                                    return name ==
                                        _tooGrupid![index]
                                            .tgruppNimi
                                            .toString();
                                  });
                                }
                                if (_controller.hasClients) {
                                  _controller.jumpTo(_controller.position
                                      .minScrollExtent); //Igaksjuhuks kerime üles
                                }
                              });
                            },
                          ),
                        );
                      })),
                ),
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: _controller,
                    child: ListView.builder(
                      controller: _controller,
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
