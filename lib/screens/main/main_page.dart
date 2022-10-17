import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/api.dart';
import '../../widgets/main/aktiivsed_list.dart';
import '../../widgets/main/kokku_tool.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _tanaKokku = '0';
  String _tanaPoleKokku = '0';
  Future? _tanaToolList;
  int _asukoht = 1;
  bool _otsib = false;

  void getData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _otsib = true;
    });
    await getTanaTool(_asukoht).then((value) {
      if (value.isNotEmpty) {
        _tanaKokku = value.first.tulem.toString();
      }
    });
    await getTanaPoleTool(_asukoht).then(((value) {
      if (value.isNotEmpty) {
        _tanaPoleKokku = value.first.tulem.toString();
      }
    }));
    setState(() {
      _otsib = false;
    });
    prefs.setInt('asukoht', _asukoht);
    //log(prefs.getInt('asukoht').toString(), name: 'main asukoht');
  }

  @override
  void initState() {
    super.initState();
    getData();
    _tanaToolList = getTanaToolList(_asukoht);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                // TODO võta pealkiri firmade tabelist jne
                Text(
                  'Pärnu tootmine:',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ]),
              //PaisAeg(), //Paneme paika kellaja
              KokkuTool(_tanaKokku, _tanaPoleKokku),
              //lisama Divideri
              const Divider(
                color: Colors.grey,
                thickness: 2,
                indent: 10,
                endIndent: 10,
                height: 0,
              ),
              Expanded(
                child: SizedBox(
                  height: 480,
                  child: FutureBuilder(
                      future: _tanaToolList,
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          log(snapshot.error.toString(), name: 'Kodu2 ERROR');
                          return const Center(
                            child: Text('ERROR'),
                          );
                        }
                        if (snapshot.hasData) {
                          return AktiivsedList(snapshot.data.aktGrupid as List);
                        }
                        return const Text('Pole miskit');
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      getData();
      //_tanaKokku = getTanaTool(asukoht);
      _tanaToolList = getTanaToolList(_asukoht);
      //log('REFRESH', name: 'kodu3');
    });
  }
}
