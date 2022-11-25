import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobriba/models/tootajad/user_model.dart';
import 'package:mobriba/screens/tootajad/tootaja_edit_page.dart';
import 'package:mobriba/screens/tootajad/user_info_page.dart';
import 'package:mobriba/services/api.dart' as api;
import 'package:mobriba/services/debouncer.dart'; //tekitab väikese viivise
import 'package:mobriba/widgets/tootajad/tootjad_list_card.dart';

class Tootajad extends StatefulWidget {
  const Tootajad({Key? key}) : super(key: key);

  @override
  State<Tootajad> createState() => _TootajadState();
}

class _TootajadState extends State<Tootajad> {
  //bool otsib = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _otsiCont = TextEditingController();
  bool _aktiivsed = true;
  List<User>? _leitudKasutajad = [];
  bool _otsib = false;
  //late FocusNode _myFocusNode;
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 1000));
  String _asutusOtsiText = 'Matek';

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
        //_leitudKasutajad!.clear();
      });
      if (_aktiivsed) {
        aktOtsi = 1;
      } else {
        aktOtsi = 0;
      }
      //Otsib töötajaid:
      _leitudKasutajad = await api.otsiTootajat(otsiText, aktOtsi);
      setState(() {
        _otsib = false;
      });
    }
    //log(_leitudKasutajad!.length.toString(), name: 'OtsiTootajat');
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

  @override
  void initState() {
    //_myFocusNode = FocusNode();
    super.initState();
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
                Container()
                /* Builder(builder: (context) {
                  return InkWell(
                    onTap: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
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
                }), */
              ],
              title: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 40, child: Icon(Icons.search)),
                      _asutusOtsiText == '' ? otsiText() : AsutusOtsiChip()

                      //otsiText(),
                      ,
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
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Chip(
                        label: Text('Matek'),
                        onDeleted: () {},
                      ),
                      Chip(
                        label: Text('Aktiivsed'),
                        onDeleted: () {},
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
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
            delegate: SliverChildBuilderDelegate((context, ind) {
              return TootajadListCard(
                  leitudKasutajad: _leitudKasutajad,
                  indeks: ind,
                  editTootaja: ((tid) => editTootaja(tid)),
                  naitaTootajaInfot: (int tid) => naitaUserInfot(tid));
            }, childCount: _leitudKasutajad?.length ?? 0),
          ),
        ],
      ),
      endDrawer: SizedBox(
        width: 200,
        child: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 100,
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
                children: [
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Switch(
                          value: _aktiivsed,
                          onChanged: ((value) {
                            setState(() {
                              _aktiivsed = !_aktiivsed;
                            });
                          })),
                      const Text('Aktiivsed'),
                    ],
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).selectedRowColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                    ),
                    child: Row(
                      children: const [
                        Text('Kõik asutused'),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _asutusOtsiText = '';
                      setState(() {});
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                    ),
                    child: Row(
                      children: const [
                        Text('Matek'),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _asutusOtsiText = 'Matek';
                      setState(() {});
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Text('Matek'),
                      ],
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

  Expanded otsiText() {
    return Expanded(
      child: TextField(
        controller: _otsiCont,
        onChanged: (val) => _debouncer.run(() {
          getOtsiTootajat(val);
        }),
        onSubmitted: getOtsiTootajat,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Otsi töötajat:',
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _otsiCont.clear();
            },
          ),
        ),
      ),
    );
  }

  Chip AsutusOtsiChip() {
    return Chip(
      label: Text(_asutusOtsiText),
      deleteIcon: const Icon(Icons.clear),
      onDeleted: () {
        _asutusOtsiText = '';
        _otsiCont.text = '';
        setState(() {});
      },
    );
  }
}
