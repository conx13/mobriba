import 'package:flutter/material.dart';
import 'package:mobriba/screens/main/akt_grupid.dart';

class AktiivsedList extends StatelessWidget {
  @required
  List aktlist = [];
  AktiivsedList(this.aktlist, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (aktlist.isNotEmpty) {
      return ListView.builder(
          itemCount: aktlist.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AktGrupidScreen(aktlist[index].gnimi.toString()),
                    ),
                  );
                },
                contentPadding: const EdgeInsets.all(10),
                leading: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 3),
                    shape: BoxShape.circle,
                  ),
                  height: 50.0,
                  width: 50.0,
                  child: Center(
                    child: Text(
                      //'100',
                      aktlist[index].kokku.toString(),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
                title: Text(
                  aktlist[index].gnimi,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            );
          });
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text('Hetkel registreerunuid töötajaid ei ole!'),
        ],
      );
    }
  }
}
