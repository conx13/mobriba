import 'package:flutter/material.dart';

class ElemPais extends StatelessWidget {
  const ElemPais(
      {required String nimetus, required String grupp, double? m2, Key? key})
      : _nimetus = nimetus,
        _grupp = grupp,
        _m2 = m2,
        super(key: key);

  final String _nimetus;
  final String _grupp;
  final double? _m2;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        dense: true,
        title: Text(
          _nimetus,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(_grupp),
        //subtitle: Text(_elemInfo.first.ggrupp),
        trailing: Text(
          '${_m2.toString()} m2',
        ),
      ),
    );
  }
}
