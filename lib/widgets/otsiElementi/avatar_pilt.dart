import 'package:flutter/material.dart';

import '../../services/http_service.dart';

class AvatarPilt extends StatelessWidget {
  final String pilt;
  final String tahed;
  final Color varv;
  const AvatarPilt(
      {required this.pilt, required this.tahed, required this.varv, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //String tahed = kesTegi![0].pnimi[0] + kesTegi![0].enimi[0];
    //tring pilt = kesTegi![0].pilt;
    //log(pilt, name: 'PILT');
    return CircleAvatar(
      foregroundColor: Colors.white,
      backgroundColor: varv,
      backgroundImage: pilt != ''
          ? NetworkImage('$url/pics/$pilt', headers: httpPais)
          : null,
      child: pilt == '' ? Text(tahed) : null,
    );
  }
}
