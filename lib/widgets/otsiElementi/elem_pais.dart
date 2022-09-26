import 'package:flutter/material.dart';

class ElemPais extends StatelessWidget {
  const ElemPais(
      {required String nimetus,
      required String grupp,
      double? m2,
      required String leping,
      Key? key})
      : _nimetus = nimetus,
        _grupp = grupp,
        _m2 = m2,
        _leping = leping,
        super(key: key);

  final String _nimetus;
  final String _grupp;
  final double? _m2;
  final String _leping;

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
        subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(_grupp), Text(_leping)]),
        //subtitle: Text(_elemInfo.first.ggrupp),
        trailing: Text(
          '${_m2.toString()} m2',
        ),
      ),
    );
  }
}
