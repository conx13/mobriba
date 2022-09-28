import 'package:flutter/material.dart';
import '../../screens/tootajad/tootaja_page.dart';

class MitteAktCard extends StatelessWidget {
  @required
  final String nimi;
  final String grupp;
  final int tid;

  const MitteAktCard(this.nimi, this.grupp, this.tid, {Key? key})
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
