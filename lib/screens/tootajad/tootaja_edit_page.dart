// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobriba/models/main/id_nimi.dart';
import 'package:mobriba/models/tootajad/user_model.dart';
//import 'package:mobriba/services/abiks.dart';
import 'package:mobriba/services/api.dart';
import 'package:mobriba/services/http_service.dart';
import 'package:mobriba/widgets/teated.dart';
import 'package:mobriba/widgets/tootajad/tootaja_dropbox.dart';
import 'package:mobriba/widgets/tootajad/tootaja_textfield.dart';

class TootajaEditPage extends StatefulWidget {
  final int tid;
  const TootajaEditPage({required this.tid, Key? key}) : super(key: key);

  @override
  State<TootajaEditPage> createState() => _TootajaEditPageState();
}

class _TootajaEditPageState extends State<TootajaEditPage> {
  final _formKey = GlobalKey<FormState>();
  late User tootaja;
  List<IdNimi> _userTooGrupp = [IdNimi(id: 0, nimi: 'Vali grupp')];
  List<IdNimi>? _userAjaGrupp = [IdNimi(id: 0, nimi: 'Vali grupp')];
  List<IdNimi>? _userAsukoht = [IdNimi(id: 0, nimi: 'Vali grupp')];
  List<IdNimi>? _userFirma = [IdNimi(id: 0, nimi: 'Vali grupp')];

  int _userTooGruppId = 0;
  int _userAjaGruppId = 0;
  int _userAsukohtId = 0;
  int _userFirmaId = 0;
  bool _aktiivne = true;
  bool _isLoading = false;

  final TextEditingController tootajaEnimiCont = TextEditingController();
  final TextEditingController tootajaPnimiCont = TextEditingController();
  final TextEditingController tootajaIkoodCont = TextEditingController();
  final TextEditingController tootajaEmailCont = TextEditingController();
  final TextEditingController tootajaTelefonCont = TextEditingController();

//Täidame gruppide valikud
  Future grupidInit() async {
    try {
      _userTooGrupp = await getTootajaTooGrupp();
      _userAjaGrupp = await getTootajaAjaGrupp();
      _userAsukoht = await getTootajaAsukoht();
      _userFirma = await getTootajaFirma();
    } catch (e) {
      log(e.toString(), name: 'Töötaja grupid Error');
    }
  }

//Täidame töötja modeli
  Future tootjaInit(int tid) async {
    try {
      tootaja = await getUser(tid);
    } catch (e) {
      log(e.toString(), name: 'Töötaja ERROR');
    }
  }

//Täidame vormi
  void formInit() {
    _userTooGruppId = tootaja.toogruppId;
    _userAjaGruppId = tootaja.ajagruppId;
    _userAsukohtId = tootaja.asukohtId;
    _userFirmaId = tootaja.firmaId;
    tootajaEnimiCont.text = tootaja.enimi;
    tootajaPnimiCont.text = tootaja.pnimi;
    tootajaIkoodCont.text = tootaja.ikood;
    tootajaEmailCont.text = tootaja.email;
    tootajaTelefonCont.text = tootaja.telefon;
    _aktiivne = tootaja.aktiivne == 1;
  }

  void startInit() async {
    setState(() {
      _isLoading = true;
    });
    await grupidInit();
    await tootjaInit(widget.tid);
    formInit();
    setState(() {
      _isLoading = false;
    });
  }

  void tootajaUpdate(context) async {
    Map userUpdateMap = {};
    String tulemus = '';
    bool kasMuutus = false;
    bool aktiivneKontr;

    //paneme klaveri kinni
    FocusManager.instance.primaryFocus?.unfocus();
    //Lisame ainult need väljad mis muutunud
    //Kui enimi või pnimi muutuvad siis muutub ka nimi
    if (tootaja.enimi != tootajaEnimiCont.text.trim()) {
      userUpdateMap['enimi'] = tootajaEnimiCont.text.trim();
      kasMuutus = true;
    }
    if (tootaja.pnimi != tootajaPnimiCont.text) {
      userUpdateMap['pnimi'] = tootajaPnimiCont.text.trim();
      kasMuutus = true;
    }
    if (tootaja.ikood != tootajaIkoodCont.text.trim()) {
      userUpdateMap['ikood'] = tootajaIkoodCont.text;
      kasMuutus = true;
    }
    if (tootaja.telefon != tootajaTelefonCont.text.trim()) {
      userUpdateMap['telefon'] = tootajaTelefonCont.text.trim();
      kasMuutus = true;
    }
    if (tootaja.email != tootajaEmailCont.text.trim()) {
      userUpdateMap['email'] = tootajaEmailCont.text.trim();
      kasMuutus = true;
    }
    if (tootaja.ajagruppId != _userAjaGruppId) {
      userUpdateMap['ajagupp'] = _userAjaGruppId;
      kasMuutus = true;
    }
    if (tootaja.toogruppId != _userTooGruppId) {
      userUpdateMap['toogrupp_id'] = _userTooGruppId;
      kasMuutus = true;
    }
    if (tootaja.firmaId != _userFirmaId) {
      userUpdateMap['firma_id'] = _userFirmaId;
      kasMuutus = true;
    }
    if (tootaja.asukohtId != _userAsukohtId) {
      userUpdateMap['asukoht_id'] = _userAsukohtId;
      kasMuutus = true;
    }
    aktiivneKontr = (tootaja.aktiivne == 0 ? false : true);
    if (_aktiivne != aktiivneKontr) {
      userUpdateMap['aktiivne'] = _aktiivne ? 1 : 0;
      kasMuutus = true;
    }
    if (kasMuutus) {
      try {
        tulemus = await updateTootaja(widget.tid, userUpdateMap);
        await tootjaInit(widget.tid);
        formInit();
        setState(() {});
        YldTeated.naita(context,
            message: 'Töötaja andmed on muudetud', err: false);
      } catch (e) {
        log(e.toString(), name: 'Töötaja update error');
        YldTeated.naita(context,
            message: 'Midagi läks valesti! Andmeid ei muudetud!', err: true);
      }
    }

// TODO aktiivne veel lisada
  }

//Tee esimene täht suureks
  String capitalizeAllWord(String value) {
    var result = value[0].toUpperCase();
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " ") {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
      }
    }
    return result;
  }

// Kontrollime kas ainult tähed
  String? _poleTyhiTxt(String? value) {
    String pattern = r"^([ \u00c0-\u01ffa-zA-Z'\-])+$";
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return 'Ei tohi olla tühi!';
    } else if (!regExp.hasMatch(value)) {
      return 'Ainult tähed!';
    } else {
      return null;
    }
  }

// TODO tekita siis ID kontroll
  String? _poleTyhiNr(String? value) {
    String pattern = r"^[0-9]*$";
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return 'Ei tohi olla tühi!';
    } else if (!regExp.hasMatch(value)) {
      return 'Ainult numbrid!';
    } else {
      return null;
    }
  }

  String? _poleKnt(String? value) {
    return null;
  }

  @override
  void initState() {
    super.initState();
    startInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        //toolbarHeight: 80,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: (() => Navigator.of(context).pop()),
          color: Theme.of(context).primaryColor,
        ),
        title: Text('Muuda töötajat:'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (() {
              tootajaUpdate(context);
            }),
            icon: Icon(Icons.done),
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
      body: _isLoading
          ? Column(
              children: const [
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              ],
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.always,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          TootajaTextField(
                            cont: tootajaEnimiCont,
                            labelTxt: 'Eesnimi:',
                            ikoon: Icons.person,
                            aktiivne: false,
                            valid: _poleTyhiTxt,
                            inputType: TextInputType.text,
                          ),
                          const SizedBox(height: 2),
                          TootajaTextField(
                            cont: tootajaPnimiCont,
                            labelTxt: 'Perenimi:',
                            ikoon: Icons.people,
                            aktiivne: false,
                            valid: _poleTyhiTxt,
                            inputType: TextInputType.text,
                          ),
                          /*            const SizedBox(height: 10),
                          TootajaTextField(
                            cont: tootajaIkoodCont,
                            labelTxt: 'Isikukood:',
                            ikoon: Icons.pin,
                            aktiivne: false,
                            inputType: TextInputType.number,
                            valid: _poleTyhiNr,
                          ), */
                          const SizedBox(height: 10),
                          TootajaTextField(
                            cont: tootajaTelefonCont,
                            labelTxt: 'Telefon:',
                            ikoon: Icons.phone,
                            inputType: TextInputType.phone,
                            valid: _poleKnt,
                          ),
                          const SizedBox(height: 3),
                          TootajaTextField(
                            cont: tootajaEmailCont,
                            labelTxt: 'Email:',
                            ikoon: Icons.email,
                            inputType: TextInputType.emailAddress,
                            valid: _poleKnt,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TootajaValikField(
                            labelTxt: 'Töögrupp:',
                            valikGruppId: _userTooGruppId,
                            valikGrupp: _userTooGrupp,
                            ikoon: Icons.category,
                            kuiMuutus: (val) {
                              setState(() {
                                _userTooGruppId = val;
                              });
                            },
                          ),
                          const SizedBox(height: 3),
                          TootajaValikField(
                            valikGruppId: _userAjaGruppId,
                            valikGrupp: _userAjaGrupp,
                            labelTxt: 'AjaGrupp:',
                            ikoon: Icons.schedule,
                            kuiMuutus: (val) {
                              setState(() {
                                _userAjaGruppId = val;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          TootajaValikField(
                            valikGruppId: _userFirmaId,
                            valikGrupp: _userFirma,
                            labelTxt: 'Asutus:',
                            ikoon: Icons.store,
                            kuiMuutus: (val) {
                              setState(() {
                                _userFirmaId = val;
                              });
                            },
                          ),
                          const SizedBox(height: 2),
                          TootajaValikField(
                            valikGruppId: _userAsukohtId,
                            valikGrupp: _userAsukoht,
                            labelTxt: 'Töökoht:',
                            ikoon: Icons.public,
                            kuiMuutus: (val) {
                              setState(() {
                                _userAsukohtId = val;
                              });
                            },
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const SizedBox(
                                width: 90,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text('Aktiivne:'),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: Icon(
                                  Icons.done,
                                  color: Theme.of(context).primaryColor,
                                  size: 15,
                                ),
                              ),
                              Switch(
                                  value: _aktiivne,
                                  onChanged: ((value) {
                                    setState(() {
                                      _aktiivne = !_aktiivne;
                                    });
                                  }))
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
