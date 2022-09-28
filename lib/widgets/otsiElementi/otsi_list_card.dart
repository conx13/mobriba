import 'package:flutter/material.dart';
import '../../screens/otsi/elemendi_info_page.dart';

class OtsiListCard extends StatelessWidget {
  final int tulem;
  final int jid;
  final String tiitel;
  final String subtiitel;
  final num kogus;

  final BuildContext context;
  const OtsiListCard(this.tulem, this.jid, this.tiitel, this.subtiitel,
      this.kogus, this.context,
      {Key? key})
      : super(key: key);

//valime tuelmile vastava värvi
  kaardiVarv() {
    switch (tulem) {
      case 1:
        return const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: Colors.green),
        );
      case 2:
        return const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: Colors.green),
        );
      default:
        return RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: Theme.of(context).errorColor),
        );
    }
  }

// valime tulemile vastava ikooni
  ikoon() {
    switch (tulem) {
      case 1:
        return const Icon(
          Icons.schedule_outlined,
          color: Colors.green,
        );
      case 2:
        return const Icon(
          Icons.done_outlined,
          color: Colors.blue,
        );
      default:
        return const Icon(
          Icons.highlight_off_outlined,
          color: Colors.red,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: kaardiVarv(),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ElemendiInfoPage(jid)),
          );
        },
        dense: false,
        leading: Column(
            mainAxisAlignment: MainAxisAlignment.center, children: [ikoon()]),
        title: Text(tiitel),
        // Kui võtta el nimetus välja:
        //title: Text(_otsiTulem[index].too.split('_').last),
        subtitle: Text(subtiitel),
        trailing: Text('$kogus m2'),
      ),
    );
  }
}
