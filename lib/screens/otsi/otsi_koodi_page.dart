//import 'dart:developer';

import 'package:flutter/material.dart';
//import 'package:flutter_speed_dial/flutter_speed_dial.dart';
//import 'package:mobriba/screens/otsi/otsi_ribakoodi_form.dart';
import 'package:mobriba/screens/otsi/ribakood_page.dart';
import 'package:mobriba/widgets/f_w_icon_icons.dart';
//import 'package:mobriba/screens/otsi/ribakood_page.dart';
import '../../models/otsiElementi/otsi_koodi_list_model.dart';
//import '../../widgets/otsiElementi/otsi_koodi_form.dart';
import '../../widgets/otsiElementi/otsi_list_card.dart';

import '../../services/api.dart' as api;

class OtsiKoodiPage extends StatefulWidget {
  const OtsiKoodiPage({Key? key}) : super(key: key);

  @override
  State<OtsiKoodiPage> createState() => _OtsiKoodiPageState();
}

class _OtsiKoodiPageState extends State<OtsiKoodiPage> {
  bool _isOtsib = false;
  List<OtsiToodGrupp> _otsiTulem = [];
  String _ribakoodTextField = '';
  //String _skanniQrKood = '';

// Erinevate teadete näitamiseks
  teated(String txt, bool err) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(txt),
      backgroundColor: err
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).snackBarTheme.backgroundColor,
    ));
  }

// Otsime baasist elemendi või mooduli andmeid
  otsiElementi(String leping, String too, bool element) async {
    setState(() {
      _otsiTulem = [];
      _isOtsib = true;
    });
    try {
      _otsiTulem = await api.otsiTood(leping, too, element);
      if (_otsiTulem.isEmpty) {
        teated('Ei leidnud midagi! Proovi % märke', true);
      }
      setState(() {
        _isOtsib = false;
      });
    } catch (e) {
      teated('Võrgu viga! ${e.toString()}', true);
      setState(() {
        _isOtsib = false;
      });
    }
  }

  // Otsime baasist ribakoodi
  otsiRibakoodi(String ribakood) async {
    _otsiTulem = [];
    _isOtsib = true;
    _ribakoodTextField = ribakood;
    FocusScope.of(context).unfocus();
    setState(() {});
    try {
      _otsiTulem = await api.otsiRibakoodi(ribakood);
      if (_otsiTulem.isEmpty) {
        teated('Kahjuks ei leidnud sellist ribakoodi!', true);
        _ribakoodTextField = '';
      }
      _isOtsib = false;
      setState(() {});
    } catch (e) {
      teated('Meil on probleeme!', true);
      _ribakoodTextField = '';
      setState(() {
        _isOtsib = false;
      });
    }
  }

  //Nupp otsi ribakood
  Future<void> _nuppRibakood() async {
    Future.delayed(Duration.zero, () async {
      final tulem = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RibakoodPage()),
      );
      //if (!mounted) return;
      //_ostiKoodCont.text = result;
      // Kui kasutaja vajutas ise kinni
      if (tulem == null) {
        return;
      }
      // Kui tulem on code39 siis edasi
      if (tulem['format']! == true) {
        otsiRibakoodi(tulem['kood'].toString());
      } else {
        teated('Kahjuks vale formaat', true);
        _otsiTulem.clear();
        _ribakoodTextField = '';
      }
    });
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
        //title: const Text('Otsi koodi'),
        title: Text('Otsi koodi: $_ribakoodTextField'),
        //backgroundColor: BottomAppBarTheme.of(context).color,
        //Paneme ajutiselt kinni
        /*  bottom: PreferredSize(
            preferredSize: const Size(0, 100),
            child: Column(
              children: [
                OtsiRibakoodiForm(otsiRibakoodi, _ribakoodTextField),
                OtsiKoodiForm(otsiElementi, _skanniQrKood),
              ],
            ),
          ), */
      ),
      body: _isOtsib
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              shrinkWrap: true,
              itemCount: _otsiTulem.length,
              itemBuilder: ((context, index) {
                return OtsiListCard(
                    _otsiTulem[index].tulem,
                    _otsiTulem[index].jid,
                    _otsiTulem[index].too,
                    _otsiTulem[index].lepnr,
                    _otsiTulem[index].kogus,
                    context);
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _nuppRibakood(),
        heroTag: null,
        child: const Icon(FWIcon.barcode),
      ),
    );
  }
}
