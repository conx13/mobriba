import 'dart:developer';

import 'package:flutter/material.dart';

class Tootajad extends StatefulWidget {
  const Tootajad({Key? key}) : super(key: key);

  @override
  State<Tootajad> createState() => _TootajadState();
}

class _TootajadState extends State<Tootajad> {
  bool aktiivsed = true;
  final otsiCont = TextEditingController();

  void otsiTootajat(String value) {
    log(otsiCont.text, name: 'otsiController');
    log(aktiivsed.toString(), name: 'otsiAkt');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          pinned: true,
          snap: false,
          centerTitle: true,
          title: const Text('Töötajad'),
          bottom: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: otsiCont,
                    onSubmitted: otsiTootajat,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Otsi töötajat:',
                      //prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          otsiCont.clear();
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  //width: 128,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Aktiivsed:',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      Checkbox(
                          value: aktiivsed,
                          shape: CircleBorder(),
                          onChanged: (valik) {
                            setState(() {
                              aktiivsed = valik!;
                            });
                          })
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
