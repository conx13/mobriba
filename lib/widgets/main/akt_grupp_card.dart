import 'package:flutter/material.dart';

class AktGruppCard extends StatelessWidget {
  @required
  String nimi = '';
  String leping = '';
  String job = '';
  String start;

  AktGruppCard(this.nimi, this.leping, this.job, this.start, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.all(2),
      child: ListTile(
        //contentPadding: const EdgeInsetsDirectional.fromSTEB(10, 4, 10, 0),
        leading: CircleAvatar(
          child: Text('AA'),
        ),
        title: Text(
          nimi,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.blue),
            ),
            Text(leping)
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              start,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
