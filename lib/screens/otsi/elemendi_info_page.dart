import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../../models/otsiElementi/elem_stats.dart';
import '../../models/otsiElementi/elemendi_info.dart';
import '../../models/otsiElementi/kestegi_model.dart';
import '../../widgets/otsiElementi/avatar_pilt.dart';
import '../../widgets/otsiElementi/elem_pais.dart';
import '../../widgets/otsiElementi/elemendi_stats.dart';

import '../../services/api.dart' as api;

// Map-i lisa gruppeerimiseks
extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

class ElemendiInfoPage extends StatefulWidget {
  final int jid;

  const ElemendiInfoPage(this.jid, {Key? key}) : super(key: key);

  @override
  State<ElemendiInfoPage> createState() => _ElemendiInfoState();
}

class _ElemendiInfoState extends State<ElemendiInfoPage> {
  String _nimetus = 'Otsib...';
  String _gnimi = 'Otsib...';
  String _leping = '...';
  double? _m2 = 0.0;
  String _aeg = '00:00';
  String _tulemus = '0,0 m2/h';
  final String _keskmineAeg = '0.0';
  bool _isLoadedKesTegi = false;
  bool _statsTyhi = false;

  List<KesTegi> _kesTegiList = [];
  Map<Object, List<KesTegi>> _kesTegiGrupp = {};
  List<ElemInfo> _elemInfo = [];
  List<ElemStats> _elemStats = [];

  // Erinevate teadete näitamiseks
  teated(String txt, bool err) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(txt),
      backgroundColor: err
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).snackBarTheme.backgroundColor,
    ));
  }

//Arvutab kulutatud aega tundides ja minutites
  arvutaAeg(int value) {
    if (value != 0) {
      int h, m;
      h = value ~/ 60;
      m = value % 60;
      _aeg = '${h}h:${m}m';
    }
  }

// Arvutab kulunud aja m2 suhet
  arvutaKiirus(int aeg, double m2) {
    if ((aeg != 0)) {
      String tulem = ((m2 / aeg) * 60).toStringAsFixed(2);
      _tulemus = '$tulem m2/h';
    }
  }

//Korjab baasist infot, kes tegi
  getKesTegi(int jid) async {
    try {
      setState(() {
        _isLoadedKesTegi = true;
      });
      _kesTegiList = await api.kesTegi(jid);
      _kesTegiGrupp = _kesTegiList.groupBy(((p) => p.nimi));
      //log(kesTegiToJson(_kesTegiList), name: 'Kes tegi');
      setState(() {
        _isLoadedKesTegi = false;
      });
    } catch (e) {
      setState(() {
        _isLoadedKesTegi = false;
      });
      log(e.toString(), name: 'Error Kest tegi');
    }
  }

//Korjab baasist infot, elemendi kohta
  getElemendiInfo(int jid) async {
    try {
      _elemInfo = await api.elemendiInfo(jid);
      setState(() {
        _nimetus = _elemInfo.first.job;
        _leping = _elemInfo.first.lepnr;
        _gnimi = _elemInfo.first.gnimi;
        _m2 = _elemInfo.first.kogus;
      });
      //log(elemInfoToJson(_elemInfo), name: 'Elemendi info');
    } catch (e) {
      log(e.toString(), name: 'Error Elemendi info:');
    }
  }

//Arvutab statistikat elemendi kohta
  getElemendiStats(int jid) async {
    try {
      _elemStats = await api.elemendiStats(jid);
      if (_elemStats.isEmpty) {
        setState(() {
          _statsTyhi = true;
        });
      } else {
        setState(() {
          arvutaAeg(_elemStats.first.result ?? 0);
          arvutaKiirus(_elemStats.first.result ?? 0, _m2!);
        });
      }
    } catch (e) {
      log(e.toString(), name: 'Elemendi stats Error!');
    }
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    //futKesTegi = api.kesTegi(widget.jid);
    getElemendiInfo(widget.jid);
    getKesTegi(widget.jid);
    getElemendiStats(widget.jid);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          children: [
            AppBar(
              title: const Text('otsing'),
            ),
            ElemPais(
              nimetus: _nimetus,
              grupp: _gnimi,
              m2: _m2,
              leping: _leping,
            ),
            Visibility(
              visible: _statsTyhi,
              child: Text(
                'Ei ole töösse võetud!',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.redAccent),
              ),
            ),
            Visibility(
                visible: !_statsTyhi,
                child: Stats(
                    aeg: _aeg, tulemus: _tulemus, keskmineAeg: _keskmineAeg)),
            Expanded(
                child: !_isLoadedKesTegi
                    ? kesTegiList(_kesTegiGrupp)
                    : const Center(
                        child: CircularProgressIndicator(),
                      ))
          ],
        ),
      ),
    );
  }

  ListView kesTegiList(Map<Object, List<KesTegi>> listGrupp) {
    return ListView.builder(
      itemCount: listGrupp.length,
      itemBuilder: ((cont, index) {
        String nimi = listGrupp.keys.elementAt(index).toString();
        return Card(
          clipBehavior: Clip.hardEdge,
          child: ExpansionTile(
            childrenPadding: const EdgeInsets.only(bottom: 10),
            //tilePadding: EdgeInsets.all(10),
            leading: AvatarPilt(
              pilt: listGrupp[nimi]![0].pilt,
              tahed:
                  listGrupp[nimi]![0].enimi[0] + listGrupp[nimi]![0].pnimi[0],
              varv: Theme.of(context).primaryColor,
            ),
            title: Text(nimi),
            children: listGrupp[nimi]!
                .map((e) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('dd.MM.yy').format(e.start!),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        e.stop != null
                            ? Text(
                                DateFormat('HH.mm').format(e.start!) +
                                    DateFormat('-HH.mm').format(e.stop!),
                                style: Theme.of(context).textTheme.labelMedium)
                            : Text(
                                '${DateFormat('HH.mm').format(e.start!)} - töös',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .apply(color: Colors.red))
                      ],
                    ))
                .toList(),
          ),
        );
      }),
    );
  }
}
