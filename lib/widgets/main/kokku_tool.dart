import 'package:flutter/material.dart';
import '../../screens/main/puuduvad.dart';

class KokkuTool extends StatelessWidget {
  @required
  String aktiivsedKokku = '0';
  @required
  String mitteAktiivsedKokku = '0';

  KokkuTool(this.aktiivsedKokku, this.mitteAktiivsedKokku, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 87,
      padding: const EdgeInsets.symmetric(vertical: 5),
      alignment: Alignment.center,
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.only(right: 10),
                // color: Colors.grey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Aktiivsed:',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      aktiivsedKokku,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
              ),
            ),
            const VerticalDivider(
              color: Colors.grey,
              thickness: 2,
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                child: InkWell(
                  splashColor: Colors.red,
                  onTap: () {
                    //Navigator.pushNamed(context, '/puuduvad');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const PuuduvadEkraan();
                    }));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mitteaktiivsed:',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        mitteAktiivsedKokku,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).errorColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
