import 'package:flutter/material.dart';

import 'package:mobriba/widgets/otsiElementi/avatar_pilt.dart';
import '../../screens/tootajad/tootaja_page.dart';

class MitteAktCard extends StatelessWidget {
  @required
  final String nimi;
  final String enimi;
  final String pnimi;
  final String pilt;
  final String grupp;
  final int tid;

  const MitteAktCard(
      this.nimi, this.enimi, this.pnimi, this.pilt, this.grupp, this.tid,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserPage(tid),
            ),
          );
        },
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
