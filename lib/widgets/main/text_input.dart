import 'package:flutter/material.dart';

class TekstInput extends StatelessWidget {
  const TekstInput({
    Key? key,
    required this.textController,
    required bool isEdit,
    this.label = '',
    this.keyboard = TextInputType.text,
    this.kontroll = false,
  })  : _isEdit = isEdit,
        super(key: key);

  final TextEditingController textController;
  final bool _isEdit;
  final String label;
  final TextInputType keyboard;
  final bool kontroll;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      decoration: InputDecoration(
        labelText: label,
      ),
      keyboardType: keyboard,
      enabled: _isEdit,
      autocorrect: kontroll,
    );
  }
}
