import 'dart:async';
//import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mobile_scanner/mobile_scanner.dart';

class RibakoodPage extends StatefulWidget {
  const RibakoodPage({super.key});

  @override
  State<RibakoodPage> createState() => _RibakoodPageState();
}

class _RibakoodPageState extends State<RibakoodPage> {
  bool _isEnabled = true;
  String ribakood = '';

  _leidsinKoodi(
    context,
    kood,
  ) {
    _isEnabled = false;
    if (kood.rawValue == null) {
      debugPrint('Failed to scan Barcode');
    } else {
      HapticFeedback.heavyImpact();
      final String code = kood.rawValue!;
      Map<String, Object> data = {};
      data['kood'] = code;
      data['format'] = BarcodeFormat.code39 == kood.format;
      debugPrint('Barcode found! $code');
      //debugPrint('Barcode type: $tuup.text');
      Navigator.pop(context, data);
    }
    Timer(const Duration(seconds: 2), (() => _isEnabled = true));
    //log(_isEnabled.toString(), name: 'isEnabled');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Koodi skänner:')),
      body: MobileScanner(
          allowDuplicates: false,
          onDetect: (barcode, args) =>
              _isEnabled ? _leidsinKoodi(context, barcode) : null
          /* {
          if (barcode.rawValue == null) {
            debugPrint('Failed to scan Barcode');
          } else {
            HapticFeedback.heavyImpact();
            final String code = barcode.rawValue!;
            Navigator.pop(context, code);
          }
        }, */
          ),
    );
  }
}
