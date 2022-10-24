// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:developer';

import 'package:flutter/material.dart';
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
  final _formKey = GlobalKey<FormState>();
  String _eTitle = '';
  String _pTitle = '';

  final TextEditingController tootajaEnimiCont = TextEditingController();
  final TextEditingController tootajaPnimiCont = TextEditingController();
  final TextEditingController tootajaIkoodCont = TextEditingController();
  final TextEditingController tootajaEmailCont = TextEditingController();
  final TextEditingController tootajaTelefonCont = TextEditingController();

  void getTootaja(int tid) async {
    try {
      tootaja = await getUser(tid);
      tootjaInit();
      log(tootaja.enimi, name: 'Töötaja edit enimi!');
    } catch (e) {
      log(e.toString(), name: 'User edit error');
    }
  }

  void muudaPealkirja() {
    _eTitle = tootajaEnimiCont.text;
    _pTitle = tootajaPnimiCont.text;
    setState(() {});
  }

  void tootjaInit() {
    _eTitle = tootaja.enimi;
    _pTitle = tootaja.pnimi;
    tootajaEnimiCont.text = tootaja.enimi;
    tootajaPnimiCont.text = tootaja.pnimi;
    tootajaIkoodCont.text = tootaja.ikood;
    tootajaEmailCont.text = tootaja.email;
    tootajaTelefonCont.text = tootaja.telefon;
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
    getTootaja(widget.tid);
    tootajaEnimiCont.addListener(muudaPealkirja);
    tootajaPnimiCont.addListener(muudaPealkirja);
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
      body: SingleChildScrollView(
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
                    ),
                    const SizedBox(height: 2),
                    TootajaTextField(
                      cont: tootajaPnimiCont,
                      labelTxt: 'Perenimi:',
                      ikoon: Icons.people,
                      valid: _poleTyhiTxt,
                    ),
                    const SizedBox(height: 10),
                    TootajaTextField(
                      cont: tootajaIkoodCont,
                      labelTxt: 'Isikukood:',
                      ikoon: Icons.pin,
                      valid: _poleTyhiNr,
                    ),
                    const SizedBox(height: 10),
                    TootajaTextField(
                      cont: tootajaTelefonCont,
                      labelTxt: 'Telefon:',
                      ikoon: Icons.phone,
                      valid: _poleKnt,
                    ),
                    const SizedBox(height: 3),
                    TootajaTextField(
                      cont: tootajaEmailCont,
                      labelTxt: 'Email:',
                      ikoon: Icons.email,
                      valid: _poleKnt,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: (() {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
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

class TootajaTextField extends StatelessWidget {
  const TootajaTextField({
    Key? key,
    required this.cont,
    required this.labelTxt,
    this.ikoon,
    required this.valid,
  }) : super(key: key);

  final TextEditingController cont;
  final String labelTxt;
  final IconData? ikoon;
  final String? Function(String?) valid;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            width: 80,
            child:
                Align(alignment: Alignment.centerRight, child: Text(labelTxt))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Icon(
            ikoon,
            color: Theme.of(context).disabledColor,
            size: 15,
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: cont,
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
