import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobriba/models/main/id_nimi.dart';
import 'package:mobriba/models/tootajad/user_model.dart';
import 'package:mobriba/screens/tootajad/tootaja_edit_page.dart';
import 'package:mobriba/screens/tootajad/user_info_page.dart';
import 'package:mobriba/services/abiks.dart';
import 'package:mobriba/services/api.dart' as api;
//import 'package:mobriba/services/debouncer.dart'; //tekitab väikese viivise
import 'package:mobriba/widgets/teated.dart';
import 'package:mobriba/widgets/tootajad/tootjad_list_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tootajad extends StatefulWidget {
  const Tootajad({Key? key}) : super(key: key);

  @override
  State<Tootajad> createState() => _TootajadState();
}

class _TootajadState extends State<Tootajad> {
  //bool otsib = false;
  //final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _otsiCont = TextEditingController();
  bool _aktiivsed = true;
  List<User> _leitudTootajad = [];
  List<IdNimi> _leitudAsukohad = [];
  bool _otsib = false;
  //late FocusNode _myFocusNode;
  //final _debouncer = Debouncer(delay: const Duration(milliseconds: 1000));
  String _asutusOtsiText = '';
  int _asutusOtsiId = 0;

  // Erinevate teadete näitamiseks
  void teated(String txt, bool err) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(txt),
      backgroundColor: err
          ? Theme.of(context).errorColor
          : Theme.of(context).snackBarTheme.backgroundColor,
    ));
  }

  void getOtsiTootajat(String otsiText) async {
    int aktOtsi;
    if (otsiText.isNotEmpty) {
      setState(() {
        _otsib = true;
        //_leitudTootajad!.clear();
      });
      if (_aktiivsed) {
        aktOtsi = 1;
      } else {
        aktOtsi = 0;
      }
      //Otsib töötajaid:
      try {
        _leitudTootajad =
            await api.otsiTootajat(otsiText, aktOtsi, _asutusOtsiId);
        _otsib = false;
        setState(() {});
      } catch (e) {
        _leitudTootajad = [];
        _otsib = false;
        YldTeated.naita(context, message: 'Miski võrgu Error!', err: true);
        setState(() {});
        log(e.toString(), name: 'Otsi töötaja error!');
        return;
      }
      if (!mounted) return;
      if (_leitudTootajad.isEmpty) {
        // Kui ei leidnud midagi siis teavitme
        YldTeated.naita(context, message: 'Ei leidnud kedagi!', err: true);
      } else {
        // sulgme teavituse
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    }
    //log(_leitudTootajad!.length.toString(), name: 'OtsiTootajat');
  }

//Võtame mä
  void vaikimisiAsukohtId() async {
    final prefs = await SharedPreferences.getInstance();
    _asutusOtsiId = prefs.getInt('asukoht') ?? 1;
    log(prefs.getInt('asukoht').toString(), name: 'asukoht mälust');
  }

  void getAsukoht() async {
    try {
      _leitudAsukohad = await api.getTootajaAsukoht();
      _asutusOtsiText = Abiks.findIdNimiById(_leitudAsukohad, _asutusOtsiId);
      setState(() {});
      log(_asutusOtsiText, name: 'Leitud asukoha text');
    } catch (e) {
      log(e.toString(), name: 'Osti asukohti error!');
    }
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

  // Muuda töötajat
  void editTootaja(int tid) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TootajaEditPage(
          tid: tid,
        ),
      ),
    );
  }

  // Sulge drawer
  void closeDrawer() async {
    //Pidurdame natuke, et oleks näha
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void initState() {
    //_myFocusNode = FocusNode();
    super.initState();
    vaikimisiAsukohtId();
    getAsukoht();
    //log('töötajad aktiivne');
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    //_myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: [Container()],
            floating: true,
            pinned: true,
            snap: false,
            centerTitle: true,
            title: const Text('Töötajad'),
            bottom: AppBar(
              toolbarHeight: 100,
              actions: [
                Container(),
              ],
              title: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      otsiText(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Näitame chipi ainult kui on midagi
                      _aktiivsed
                          ? Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Chip(
                                label: Text('Aktiivsed'),
                                backgroundColor: Colors.lightGreen[200],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Chip(
                                label: const Text('Mitte aktiivsed'),
                                backgroundColor: Colors.deepOrange[200],
                              ),
                            ),
                      if (_asutusOtsiText != '') asutusOtsiChip(),
                      const Spacer(),
                      Builder(builder: (context) {
                        return InkWell(
                          onTap: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                const Icon(Icons.filter_list),
                                Text(
                                  'Filter',
                                  style: Theme.of(context).textTheme.labelSmall,
                                )
                              ],
                            ),
                          ),
                        );
                      })
                    ],
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            // Otsimise indikaator
            child: Visibility(
              visible: _otsib,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.orangeAccent,
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                  minHeight: 2,
                ),
              ),
            ),
          ),
          SliverList(
            // Otsingu tulemus
            delegate: SliverChildBuilderDelegate((context, ind) {
              return TootajadListCard(
                  leitudKasutajad: _leitudTootajad,
                  indeks: ind,
                  editTootaja: ((tid) => editTootaja(tid)),
                  naitaTootajaInfot: (int tid) => naitaUserInfot(tid));
            }, childCount: _leitudTootajad.length),
          ),
        ],
      ),
      endDrawer: SizedBox(
        width: 150,
        child: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 140,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor,
                ),
                child: Text(
                  'Filter:',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Switch(
                          value: _aktiivsed,
                          onChanged: ((value) {
                            setState(() {
                              _aktiivsed = !_aktiivsed;
                              getOtsiTootajat(_otsiCont.text);
                              closeDrawer();
                              //Navigator.pop(context);
                            });
                          })),
                      const Text('Aktiivsed'),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('Töökoht:'),
                      ),
                    ],
                  ),
                  //Divider(),
                  Column(
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: _leitudAsukohad.length,
                          itemBuilder: ((context, index) {
                            return firmaValikNupp(_leitudAsukohad[index].nimi,
                                _leitudAsukohad[index].id);
                          })),
                    ],
                  ),
                  const Divider(),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

//Draweri nupp mis muutub vastavalt valikutele
  TextButton firmaValikNupp(String asutus, int id) {
    return TextButton(
      style: asutus == _asutusOtsiText
          ? TextButton.styleFrom(
              backgroundColor: Theme.of(context).selectedRowColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            )
          : TextButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
      child: Row(
        children: [
          Text(asutus),
        ],
      ),
      onPressed: () {
        _asutusOtsiText = asutus;
        _asutusOtsiId = id;
        setState(() {});
        getOtsiTootajat(_otsiCont.text);
        closeDrawer();
      },
    );
  }

  Expanded otsiText() {
    return Expanded(
      child: TextField(
        controller: _otsiCont,
/*         onChanged: (val) => _debouncer.run(() {
          getOtsiTootajat(val);
        }), */
        onSubmitted: getOtsiTootajat,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Otsi töötajat:',
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _otsiCont.clear();
              _leitudTootajad.clear();
              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  Chip asutusOtsiChip() {
    return Chip(
      label: Text(_asutusOtsiText),
      //deleteIcon: const Icon(Icons.clear),
      /* onDeleted: () {
        _asutusOtsiText = '';
        _otsiCont.text = '';
        setState(() {});
      }, */
    );
  }
}
