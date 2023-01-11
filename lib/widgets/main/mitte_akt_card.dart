import 'package:flutter/material.dart';

//import 'package:mobriba/screens/tootajad/user_info_page.dart';
import 'package:mobriba/widgets/otsiElementi/avatar_pilt.dart';

class MitteAktCard extends StatelessWidget {
  @required
  final String nimi;
  final String enimi;
  final String pnimi;
  final String pilt;
  final String grupp;
  final int tid;
  final Function(int tid) naitaTootajatInfot;

  const MitteAktCard(this.nimi, this.enimi, this.pnimi, this.pilt, this.grupp,
      this.tid, this.naitaTootajatInfot,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => naitaTootajatInfot(tid),
        leading: AvatarPilt(
            pilt: pilt,
            tahed: enimi[0] + pnimi[0],
            varv: Theme.of(context).errorColor),
        title: Text(nimi),
        subtitle: Text(grupp),
      ),
    );
  }
}
