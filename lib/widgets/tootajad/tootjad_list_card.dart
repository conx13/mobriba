import 'package:flutter/material.dart';

import '../../models/tootajad/user_model.dart';
import '../otsiElementi/avatar_pilt.dart';

class TootajadListCard extends StatelessWidget {
  final Function(int tid) editTootaja;
  final Function(int tid) naitaTootajaInfot;

  const TootajadListCard(
      {Key? key,
      required List<User>? leitudKasutajad,
      required int indeks,
      required this.editTootaja,
      required this.naitaTootajaInfot})
      : _leitudKasutajad = leitudKasutajad,
        _indeks = indeks,
        _editTootaja = editTootaja,
        _naitaTootajaInfot = naitaTootajaInfot,
        super(key: key);

  final List<User>? _leitudKasutajad;
  final int _indeks;
  final Function _editTootaja;
  final Function _naitaTootajaInfot;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      dense: false,
      onLongPress: () => _editTootaja(_leitudKasutajad![_indeks].tid),
      onTap: () => _naitaTootajaInfot(_leitudKasutajad![_indeks].tid),
      leading: AvatarPilt(
        pilt: _leitudKasutajad![_indeks].pilt,
        tahed: _leitudKasutajad![_indeks].ntahed,
        varv: Theme.of(context).primaryColor,
      ),
      title: Text(_leitudKasutajad![_indeks].nimi),
      subtitle: Text(_leitudKasutajad![_indeks].firma),
    ));
  }
}
