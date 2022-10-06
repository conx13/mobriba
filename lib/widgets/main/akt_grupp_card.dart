import 'package:flutter/material.dart';
import 'package:mobriba/screens/tootajad/tootaja_page.dart';
import 'package:mobriba/screens/tootajad/user_info_page.dart';
import 'package:mobriba/widgets/otsiElementi/avatar_pilt.dart';

class AktGruppCard extends StatelessWidget {
  @required
  final int tid;
  final String enimi;
  final String pnimi;
  final String pilt;
  final String leping;
  final String job;
  final String start;

  const AktGruppCard(
    this.tid,
    this.enimi,
    this.pnimi,
    this.pilt,
    this.leping,
    this.job,
    this.start, {
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.all(2),
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AvatarPilt(
              pilt: pilt,
              tahed: enimi[0] + pnimi[0],
              varv: Theme.of(context).primaryColor,
            ),
          ],
        ),
        title: Text(
          '$enimi $pnimi',
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserInfoPage(tid),
            ),
          );
        },
      ),
    );
  }
}
