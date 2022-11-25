import 'package:flutter/material.dart';

class TootajaTextField extends StatelessWidget {
  const TootajaTextField({
    Key? key,
    required this.cont,
    required this.labelTxt,
    this.ikoon,
    this.aktiivne = true,
    required this.valid,
    required this.inputType,
  }) : super(key: key);

  final TextEditingController cont;
  final String labelTxt;
  final IconData? ikoon;
  final String? Function(String?) valid;
  final bool aktiivne;
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
            enabled: aktiivne,
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
