import 'package:flutter/material.dart';
import '../../models/main/tana_grupid.dart';

class AktGruppTooCard extends StatelessWidget {
  @required
  final String elemGrupp;
  final String lepNr;
  final String startAeg;
  final double kokkuM2;
  final List<Grupp>? grupiTootajad;

  const AktGruppTooCard(this.elemGrupp, this.lepNr, this.kokkuM2, this.startAeg,
      this.grupiTootajad,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
          childrenPadding: const EdgeInsets.symmetric(horizontal: 15),
          expandedAlignment: Alignment.centerLeft,
          title: Text(
            elemGrupp,
            style: Theme.of(context).textTheme.titleLarge,
            maxLines: 1,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lepNr),
              LinearProgressIndicator(
                value: kokkuM2,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[300]!),
              )
            ],
          ),
          children: [
            Wrap(
              spacing: 10,
              children: grupiTootajad!
                  .map(
                    (e) => Chip(
                      elevation: 1,
                      backgroundColor: Colors.white,
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.secondary),
                      label: Text(
                        '${e.pnimi}.${e.enimi[0]} ($startAeg)',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ]),
    );
  }
}
