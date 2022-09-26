import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobriba/models/otsiElementi/kestegi_model.dart';

import '../../services/http_service.dart';

class AvatarPilt extends StatelessWidget {
  final List<KesTegi>? kesTegi;
  const AvatarPilt(this.kesTegi, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String tahed = kesTegi![0].pnimi[0] + kesTegi![0].enimi[0];
    String pilt = kesTegi![0].pilt;
    log(pilt, name: 'PILT');
    return CircleAvatar(
      backgroundImage: pilt != ''
          ? NetworkImage('$url/pics/$pilt', headers: httpPais)
          : null,
      child: pilt == '' ? Text(tahed) : null,
    );
  }
}
