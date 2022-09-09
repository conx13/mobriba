import 'package:flutter/material.dart';
import 'package:mobriba/screens/tootajad/tootaja_page.dart';

class MitteAktCard extends StatelessWidget {
  @required
  String nimi = '';
  String grupp = '';
  int tid;

  MitteAktCard(this.nimi, this.grupp, this.tid, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserPage(tid, nimi),
            ),
          );
        },
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).errorColor,
          child: Text(nimi[0]),
        ),
        title: Text(nimi),
        subtitle: Text(grupp),
      ),
    );
  }
}
