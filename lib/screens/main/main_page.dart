import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobriba/services/api.dart';
import 'package:mobriba/widgets/main/aktiivsed_list.dart';
import 'package:mobriba/widgets/main/kokku_tool.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future? _tanaKokku;
  Future? _tanaToolList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tanaKokku = getTanaTool();
    _tanaToolList = getTanaToolList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  'Pärnu tootmises:',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ]),
              //PaisAeg(), //Paneme paika kellaja
              FutureBuilder(
                  //panem paika aktiivsed kokku
                  future: _tanaKokku,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasError) {
                        log(snapshot.error.toString(), name: 'Kodu1');
                        return const Center(child: Text('ERROR'));
                      } else if (snapshot.hasData) {
                        final aktiivsedList = snapshot.data as List;
                        return KokkuTool(aktiivsedList[1].data.toString(),
                            aktiivsedList[0].data.toString());
                      } else {
                        return const Text('Andmeid ei ole');
                      }
                    }
                    return Text('State: ${snapshot.connectionState}');
                  }),
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
                          log(snapshot.error.toString(), name: 'Kodu2');
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
}
