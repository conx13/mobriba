import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobriba/screens/otsi/ribakood_page.dart';

class OtsiRibakoodiForm extends StatefulWidget {
  final Function(String ribakood) otsiRibakoodi;
  final String? ribakoodText;
  const OtsiRibakoodiForm(this.otsiRibakoodi, this.ribakoodText, {super.key});

  @override
  State<OtsiRibakoodiForm> createState() => _OtsiRibakoodiFormState();
}

class _OtsiRibakoodiFormState extends State<OtsiRibakoodiForm> {
  final _otsiFormKey = GlobalKey<FormState>();
  final TextEditingController _ostiKoodCont = TextEditingController();

  void _nuppOtsi() {
    widget.otsiRibakoodi(_ostiKoodCont.text.trim());
    //FocusScope.of(context).unfocus();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _ostiKoodCont.text = widget.ribakoodText!;
    //FocusScope.of(context).unfocus();
    return Form(
      key: _otsiFormKey,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        SizedBox(
          width: 290,
          child: TextFormField(
            controller: _ostiKoodCont,
            textInputAction: TextInputAction.search,
            onFieldSubmitted: (value) => _nuppOtsi(),
            decoration:
                const InputDecoration(isDense: true, label: Text('Ribakood:')),
          ),
        ),
        IconButton(
            onPressed: (() => _nuppOtsi()),
            icon: const Icon(Icons.search_sharp))
      ]),
    );
  }
}
