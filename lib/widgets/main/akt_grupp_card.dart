import 'package:flutter/material.dart';

class AktGruppCard extends StatelessWidget {
  @required
  final String nimi;
  final String leping;
  final String job;
  final String start;

  const AktGruppCard(this.nimi, this.leping, this.job, this.start, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.all(2),
      child: ListTile(
        //contentPadding: const EdgeInsetsDirectional.fromSTEB(10, 4, 10, 0),
        // TODO pane iia pilt kui on
        leading: const CircleAvatar(
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
