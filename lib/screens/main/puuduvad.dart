import 'package:flutter/material.dart';
import '../../models/main/aktiivsed_model.dart';
import '../../services/api.dart';
import '../../widgets/main/mitte_akt_card.dart';

class PuuduvadEkraan extends StatefulWidget {
  const PuuduvadEkraan({Key? key}) : super(key: key);

  @override
  State<PuuduvadEkraan> createState() => _PuuduvadEkraanState();
}

class _PuuduvadEkraanState extends State<PuuduvadEkraan> {
  late Future _tanaPoleList;

  @override
  void initState() {
    super.initState();
    _tanaPoleList = getMitteAktList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('Hetkel mitteaktiivsed'),
        backgroundColor: Theme.of(context).errorColor,
      ),
      body: FutureBuilder(
        future: _tanaPoleList,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final puuduList =
                snapshot.data.mitteAktGrupid as List<MitteAktiivneGrupp>;
            //TODO Kui thta gruppe filtreerida
/*             var seen = <String>{};
            List<MitteAktiivneGrupp> test =
                puuduList.where((t) => seen.add(t.tgruppNimi)).toList(); */
            //print(test[0].tgruppNimi);
            return ListView.builder(
                itemCount: puuduList.length,
                itemBuilder: (BuildContext context, int index) {
                  return MitteAktCard(
                    puuduList[index].nimi,
                    puuduList[index].enimi,
                    puuduList[index].pnimi,
                    puuduList[index].pilt,
                    puuduList[index].tgruppNimi,
                    puuduList[index].tid,
                  );
                });
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('ERROR"'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
