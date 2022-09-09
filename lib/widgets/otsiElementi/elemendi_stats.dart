import 'package:flutter/material.dart';

class Stats extends StatelessWidget {
  const Stats({
    Key? key,
    required String aeg,
    required String tulemus,
    required String keskmineAeg,
  })  : _aeg = aeg,
        _tulemus = tulemus,
        _keskmineAeg = keskmineAeg,
        super(key: key);

  final String _aeg;
  final String _tulemus;
  final String _keskmineAeg;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: ExpansionTile(
          leading: const Icon(Icons.timeline),
          title: const Text('Statistikat'),
          children: [
            Column(
              children: [
                ListTile(
                  dense: true,
                  //shape: ShapeBorder(Dimension()),
                  title: const Text('Kokku kulunud aeg:'),
                  trailing: Text(_aeg),
                ),
                ListTile(
                  dense: true,
                  //shape: ShapeBorder(Dimension()),
                  title: const Text('Tulemus m2/h:'),
                  trailing: Text(_tulemus),
                ),
                Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Theme.of(context).shadowColor,
                ),
                ListTile(
                  dense: true,
                  title: const Text('Keskmiselt selle grupi tulemus:'),
                  trailing: Text('$_keskmineAeg m2/h'),
                ),
              ],
            ),
          ]),
    );
  }
}
