import 'package:flutter/material.dart';

class MinuInputTheme {
  TextStyle _builtTextStyle(Color color, {double size = 20}) {
    return TextStyle(
      color: color,
      fontSize: size,
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(color: color, width: 1.0),
      //borderSide: BorderSide.none,
    );
  }

  InputDecorationTheme theme() => InputDecorationTheme(
        //Yldised
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        //Borders
        enabledBorder: _buildBorder(Colors.grey[200]!),
        focusedBorder: _buildBorder(Colors.blue),
        disabledBorder: _buildBorder(const Color.fromARGB(80, 158, 158, 158)),
        errorBorder: _buildBorder(Colors.red),
        focusedErrorBorder: _buildBorder(Colors.red),
        fillColor: Colors.white,
        filled: true,

        //TextStyle
        errorStyle: _builtTextStyle(Colors.red, size: 12),
      );
}
