// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobriba/models/main/id_nimi.dart';
import 'package:mobriba/models/tootajad/user_model.dart';
import 'package:mobriba/services/api.dart';

class TootajaEditPage extends StatefulWidget {
  final int tid;
  const TootajaEditPage({required this.tid, Key? key}) : super(key: key);

  @override
  State<TootajaEditPage> createState() => _TootajaEditPageState();
}

class _TootajaEditPageState extends State<TootajaEditPage> {
  late User tootaja;
  List<IdNimi>? _userTooGrupp;
  List<IdNimi>? _userAjaGrupp;
  List<IdNimi>? _userAsukoht;
  List<IdNimi>? _userFirma;

  final _formKey = GlobalKey<FormState>();
  String _eTitle = '';
  String _pTitle = '';
  int? _userTooGruppId;
  int? _userAjaGruppId;
  int? _userAsukohtId;
  int? _userFirmaId;
  bool _isLoading = false;

  final TextEditingController tootajaEnimiCont = TextEditingController();
  final TextEditingController tootajaPnimiCont = TextEditingController();
  final TextEditingController tootajaIkoodCont = TextEditingController();
  final TextEditingController tootajaEmailCont = TextEditingController();
  final TextEditingController tootajaTelefonCont = TextEditingController();

  void muudaPealkirja() {
    _eTitle = tootajaEnimiCont.text;
    _pTitle = tootajaPnimiCont.text;
    setState(() {});
  }

  void tootjaInit(int tid) async {
    setState(() {
      _isLoading = true;
    });
    tootaja = await getUser(tid);
    _userTooGrupp = await getTootajaTooGrupp();
    _userAjaGrupp = await getTootajaAjaGrupp();
    _userAsukoht = await getTootajaAsukoht();
    _userFirma = await getTootajaFirma();

    _eTitle = tootaja.enimi;
    _pTitle = tootaja.pnimi;
    _userTooGruppId = tootaja.toogruppId;
    _userAjaGruppId = tootaja.ajagrupp_id;
    _userAsukohtId = tootaja.asukoht_id;
    _userFirmaId = tootaja.firma_id;
    tootajaEnimiCont.text = tootaja.enimi;
    tootajaPnimiCont.text = tootaja.pnimi;
    tootajaIkoodCont.text = tootaja.ikood;
    tootajaEmailCont.text = tootaja.email;
    tootajaTelefonCont.text = tootaja.telefon;
    setState(() {
      _isLoading = false;
    });
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
    tootjaInit(widget.tid);
    tootajaEnimiCont.addListener(muudaPealkirja);
    tootajaPnimiCont.addListener(muudaPealkirja);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          toolbarHeight: 80,
          title: Row(
            children: [
              Flexible(child: Text('${_eTitle} ${_pTitle}')),
            ],
          )),
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
                            valid: _poleTyhiTxt,
                            inputType: TextInputType.text,
                          ),
                          const SizedBox(height: 2),
                          TootajaTextField(
                            cont: tootajaPnimiCont,
                            labelTxt: 'Perenimi:',
                            ikoon: Icons.people,
                            valid: _poleTyhiTxt,
                            inputType: TextInputType.text,
                          ),
                          const SizedBox(height: 20),
                          TootajaTextField(
                            cont: tootajaIkoodCont,
                            labelTxt: 'Isikukood:',
                            ikoon: Icons.pin,
                            inputType: TextInputType.number,
                            valid: _poleTyhiNr,
                          ),
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
                            height: 20,
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
                          const SizedBox(height: 5),
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
                          const SizedBox(height: 5),
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
                          const SizedBox(height: 5),
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
                          const SizedBox(height: 10),
                          ElevatedButton(
                              onPressed: (() {
                                if (_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Ajagrupp - $_userAjaGruppId')),
                                  );
                                }
                              }),
                              child: const Text('Salvesta'))
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

class TootajaValikField extends StatelessWidget {
  const TootajaValikField({
    Key? key,
    required int? valikGruppId,
    required List<IdNimi>? valikGrupp,
    required String labelTxt,
    IconData? ikoon,
    required Function kuiMuutus,
  })  : _valikGruppId = valikGruppId,
        _valikGrupp = valikGrupp,
        _labelTxt = labelTxt,
        _ikoon = ikoon,
        _kuiMuutus = kuiMuutus,
        super(key: key);

  final int? _valikGruppId;
  final List<IdNimi>? _valikGrupp;
  final String _labelTxt;
  final IconData? _ikoon;
  final Function _kuiMuutus;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            width: 90,
            child: Align(
                alignment: Alignment.centerRight, child: Text(_labelTxt))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Icon(
            _ikoon,
            color: Theme.of(context).primaryColor,
            size: 15,
          ),
        ),
        Expanded(
          child: DropdownButtonFormField(
            hint: const Text('Vali grupp!'),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10, 8, 10, 8),
              errorStyle: TextStyle(height: 0),
              fillColor: Colors.white,
              filled: true,
              isDense: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            value: _valikGruppId,
            //disabledHint: Text(_disabledUserGrupp),

            // kui on disabled, siis ei täida listi
            onChanged: ((value) {
              _kuiMuutus(value);
            }),
            //Seda näitab ekraanil
            selectedItemBuilder: ((BuildContext context) {
              return _valikGrupp!.map<Widget>((value) {
                return DropdownMenuItem(
                    value: value.id, child: Text(value.nimi));
              }).toList();
            }),
            // Seda näitab listis
            items: _valikGrupp?.map<DropdownMenuItem<int>>((value) {
              if (value.id == _valikGruppId) {
                return DropdownMenuItem(
                  value: value.id,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Theme.of(context).selectedRowColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(value.nimi,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor)),
/*                         Text('Märkus',
                            style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).disabledColor)) */
                      ],
                    ),
                  ),
                );
              } else {
                return DropdownMenuItem(
                  value: value.id,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(value.nimi),
/*                         Text('Märkus',
                            style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).disabledColor)) */
                      ],
                    ),
                  ),
                );
              }
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class TootajaTextField extends StatelessWidget {
  const TootajaTextField({
    Key? key,
    required this.cont,
    required this.labelTxt,
    this.ikoon,
    required this.valid,
    required this.inputType,
  }) : super(key: key);

  final TextEditingController cont;
  final String labelTxt;
  final IconData? ikoon;
  final String? Function(String?) valid;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            width: 90,
            child:
                Align(alignment: Alignment.centerRight, child: Text(labelTxt))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Icon(
            ikoon,
            color: Theme.of(context).primaryColor,
            size: 15,
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: cont,
            keyboardType: inputType,
            textCapitalization: TextCapitalization.sentences,
            validator: valid,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10, 8, 10, 8),
              errorStyle: TextStyle(height: 0),
              isDense: true,
              fillColor: Colors.white,
              filled: true,
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
