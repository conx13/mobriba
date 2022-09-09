import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobriba/models/main/tana_grupid.dart';
import 'package:mobriba/services/api.dart';
import 'package:mobriba/widgets/main/akt_grupp_card.dart';
import 'package:mobriba/widgets/main/akt_grupp_too_card.dart';

// Map-i lisa gruppeerimiseks
extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

// Map-i lisa sorteerimiseks
extension MyIterable<E> on Iterable<E> {
  Iterable<E> sortedBy(Comparable Function(E e) key) =>
      toList()..sort((a, b) => key(a).compareTo(key(b)));
}

class AktGrupidScreen extends StatefulWidget {
  String ggrupp;
  AktGrupidScreen(this.ggrupp, {Key? key}) : super(key: key);

  @override
  State<AktGrupidScreen> createState() => _AktGrupidScreenState();
}

class _AktGrupidScreenState extends State<AktGrupidScreen> {
  List<Grupp> _aktTootajadGrupid = [];
  // late var _sortedGrupp;
  Map<Object, List<Grupp>> _aktTooGrupid = {};
  bool isLoading = false;

  @override
  void initState() {
    getAktiivsedGrupid(widget.ggrupp);
    super.initState();
  }

  getAktiivsedGrupid(grupp) async {
    setState(() {
      isLoading = true;
    });
    _aktTootajadGrupid =
        await getAktGrupp(widget.ggrupp); // võtab baasist andmed
    _aktTooGrupid =
        _aktTootajadGrupid.groupBy((p) => p.too); // grupeerib töö järgi
    //_sortedGrupp =
    //    _aktGrupid.sortedBy((e) => e.nimi); //testiks sorteerisin nime järgi
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.ggrupp),
          //backgroundColor: Theme.of(context).secondaryHeaderColor,
        ),
        bottomNavigationBar: Container(
          //color: Theme.of(context).colorScheme.primary,
          child: const TabBar(
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.grey,
            labelColor: Colors.grey,
            tabs: [
              Tab(
                icon: Icon(Icons.group),
                //text: 'Töötajad',
              ),
              Tab(
                icon: Icon(Icons.apps),
                //text: 'Tööd',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _aktTootajadGrupid.length,
                    itemBuilder: (_, int index) {
                      return AktGruppCard(
                        _aktTootajadGrupid[index].nimi,
                        _aktTootajadGrupid[index].lepnr,
                        _aktTootajadGrupid[index].too,
                        DateFormat('kk:mm')
                            .format(_aktTootajadGrupid[index].start),
                      );
                    },
                  ),
            ListView.builder(
              itemCount: _aktTooGrupid.length,
              itemBuilder: (_, int index) {
                String keyNimi = _aktTooGrupid.keys.elementAt(index).toString();
                return AktGruppTooCard(
                  _aktTooGrupid.keys.elementAt(index).toString(),
                  _aktTooGrupid[keyNimi]![0].lepnr.toString(),
                  (_aktTooGrupid[keyNimi]![0].kogus / 36),
                  DateFormat('kk:mm').format(_aktTootajadGrupid[index].start),
                  _aktTooGrupid[keyNimi],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
