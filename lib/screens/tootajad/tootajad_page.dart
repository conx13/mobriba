import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobriba/models/tootajad/user_model.dart';
import 'package:mobriba/screens/tootajad/user_info_page.dart';
import 'package:mobriba/services/api.dart' as api;
import 'package:mobriba/widgets/tootajad/tootjad_list_card.dart';

class Tootajad extends StatefulWidget {
  const Tootajad({Key? key}) : super(key: key);

  @override
  State<Tootajad> createState() => _TootajadState();
}

class _TootajadState extends State<Tootajad> {
  //bool otsib = false;
  final otsiCont = TextEditingController();
  bool aktiivsed = true;
  List<User>? _leitudKasutajad = [];
  bool _otsib = false;
  final FocusNode _focusNode = FocusNode();

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
    setState(() {
      _otsib = true;
      _leitudKasutajad!.clear();
    });
    if (aktiivsed) {
      aktOtsi = 1;
    } else {
      aktOtsi = 0;
    }
    //Otsib töötajaid:
    _leitudKasutajad = await api.otsiTootajat(otsiText, aktOtsi);
    setState(() {
      _otsib = false;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(slivers: [
      SliverAppBar(
        floating: true,
        pinned: true,
        snap: false,
        centerTitle: true,
        title: const Text('Töötajad'),
        bottom: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 200,
                child: TextField(
                  focusNode: _focusNode,
                  controller: otsiCont,
                  onSubmitted: getOtsiTootajat,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Otsi töötajat:',
                    //prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        otsiCont.clear();
                        _focusNode.nextFocus();
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                //width: 128,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Aktiivsed:',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Checkbox(
                        value: aktiivsed,
                        shape: const CircleBorder(),
                        onChanged: (valik) {
                          setState(() {
                            aktiivsed = valik!;
                          });
                        })
                  ],
                ),
              ),
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
              vunk: teated,
              naitaTootajaInfot: (int tid) => naitaUserInfot(tid));
        }, childCount: _leitudKasutajad?.length ?? 0),
      ),
    ]));
  }
}
