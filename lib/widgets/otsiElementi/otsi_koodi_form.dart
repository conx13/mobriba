import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtsiKoodiForm extends StatefulWidget {
  final Function(String otsiLeping, String otsiKood, bool element) otsi;
  const OtsiKoodiForm(this.otsi, {Key? key}) : super(key: key);

  @override
  State<OtsiKoodiForm> createState() => _OtsiKoodiFormState();
}

class _OtsiKoodiFormState extends State<OtsiKoodiForm> {
  final _otsiFormKey = GlobalKey<FormState>();
  final TextEditingController _otsiLepingCont = TextEditingController();
  final TextEditingController _otsiJobCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    loeAndmeid();
  }

//Kui päringu lõpus % märk siis võtame ära
  kustutaProtsent(String str) {
    if (str.isNotEmpty) {
      if (str.endsWith('%')) {
        return str.substring(0, str.length - 1);
      }
    }
    return (str);
  }

//Saadame otsingu tagasi
  nuppOtsi() async {
    if (_otsiFormKey.currentState!.validate()) {
      widget.otsi(_otsiLepingCont.text.trim(),
          '${kustutaProtsent(_otsiJobCont.text.trim())}%', true);
      //Võtame foocuse maha
      FocusScope.of(context).unfocus();
      final prefs = await SharedPreferences.getInstance();
      // Salvestame päringu kohalikku
      prefs.setString('otsiLeping', _otsiLepingCont.text.trim());
      prefs.setString('otsiToo', kustutaProtsent(_otsiJobCont.text.trim()));
    } else {
      log('Miksit valest', name: 'NuppOtsi error');
    }
  }

//Avamisel täidame andmeid
  Future loeAndmeid() async {
    final prefs = await SharedPreferences.getInstance();
    _otsiLepingCont.text = (prefs.getString('otsiLeping') ?? '');
    _otsiJobCont.text = (prefs.getString('otsiToo') ?? '');
  }

//Kontrollime kas on ok
  String? txtKontroll(String value) {
    if (value == '' || value.isEmpty) {
      log('$value on tühi!', name: 'Leping');
      return '';
    }
    return null;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _otsiJobCont.dispose();
    _otsiLepingCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _otsiFormKey,
      child: Padding(
        //height: 100,
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          SizedBox(
            width: 110,
            child: TextFormField(
              controller: _otsiLepingCont,
              textInputAction: TextInputAction.next,
              onTap: () => _otsiLepingCont.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _otsiLepingCont.value.text.length),
              validator: (value) => txtKontroll(value!),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                errorStyle: TextStyle(
                  fontSize: 0,
                ),
                isDense: true,
                label: Text('Leping'),
              ),
            ),
          ),
          SizedBox(
            width: 170,
            child: TextFormField(
              controller: _otsiJobCont,
              textInputAction: TextInputAction.search,
              onFieldSubmitted: (value) => nuppOtsi(),
              validator: (value) => txtKontroll(value!),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                errorStyle: TextStyle(
                  fontSize: 0,
                ),
                isDense: true,
                label: Text('Töö kood'),
                hintText: '%Kood',
              ),
            ),
          ),
          SizedBox(
            child: IconButton(
              icon: const Icon(Icons.search),
              //color: Colors.white,
              onPressed: () {
                nuppOtsi();
              },
            ),
          )
        ]),
      ),
    );
  }
}
