import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mobriba/models/otsiElementi/otsi_koodi_list_model.dart';
import 'package:mobriba/widgets/otsiElementi/otsi_koodi_form.dart';
import 'package:mobriba/widgets/otsiElementi/otsi_list_card.dart';

import '../../services/api.dart' as api;

class OtsiKoodiPage extends StatefulWidget {
  const OtsiKoodiPage({Key? key}) : super(key: key);

  @override
  State<OtsiKoodiPage> createState() => _OtsiKoodiPageState();
}

class _OtsiKoodiPageState extends State<OtsiKoodiPage> {
  bool isOtsib = false;
  List<OtsiToodGrupp> _otsiTulem = [];

// Erinevate teadete näitamiseks
  teated(String txt, bool err) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(txt),
      backgroundColor: err
          ? Theme.of(context).errorColor
          : Theme.of(context).snackBarTheme.backgroundColor,
    ));
  }

// Otsime baasist andmeid
  nuppOtsiKoodiPage(String leping, String too, bool element) async {
    setState(() {
      _otsiTulem = [];
      isOtsib = true;
    });
    //final prefs = await SharedPreferences.getInstance();
    try {
      _otsiTulem = await api.otsiTood(leping, too, element);
      if (_otsiTulem.isEmpty) {
        teated('Ei leidnud midagi! Proovi % märke', true);
      }
      setState(() {
        isOtsib = false;
      });
    } catch (e) {
      teated('Võrgu viga! ${e.toString()}', true);
      setState(() {
        isOtsib = false;
      });
    }
  }

  kasUus(String txt) {
    int viimaneSonaPikkus = txt.split('_').last.length;
    int koguPikkus = txt.length;
    return txt.substring(0, (koguPikkus - 1) - viimaneSonaPikkus);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Otsi koodi'),
          backgroundColor: Theme.of(context).bottomAppBarColor,
          bottom: PreferredSize(
            preferredSize: const Size(0, 55),
            child: OtsiKoodiForm(nuppOtsiKoodiPage),
          )),
      body: isOtsib
          ? const Center(child: CircularProgressIndicator())
          : Column(children: [
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _otsiTulem.length,
                    itemBuilder: ((context, index) {
                      return OtsiListCard(
                          _otsiTulem[index].tulem,
                          _otsiTulem[index].jid,
                          _otsiTulem[index].too,
                          _otsiTulem[index].lepnr,
                          _otsiTulem[index].gnimi,
                          context);
                    })),
              )
            ]),
    );
  }
}
