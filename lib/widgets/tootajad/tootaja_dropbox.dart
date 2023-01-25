//import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobriba/models/main/id_nimi.dart';

class TootajaValikField extends StatelessWidget {
  const TootajaValikField({
    Key? key,
    required int? valikGruppId,
    List<IdNimi>? valikGrupp,
    required String labelTxt,
    IconData? ikoon,
    required Function kuiMuutus,
  })  : _valikGruppId = valikGruppId ?? 0,
        _valikGrupp = valikGrupp,
        _labelTxt = labelTxt,
        _ikoon = ikoon,
        _kuiMuutus = kuiMuutus,
        super(key: key);

  final int? _valikGruppId;
  final List<IdNimi>? _valikGrupp;
  final String _labelTxt;
  final IconData? _ikoon;
  final Function _kuiMuutus;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            width: 90,
            child: Align(
                alignment: Alignment.centerRight, child: Text(_labelTxt))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Icon(
            _ikoon,
            color: Theme.of(context).primaryColor,
            size: 15,
          ),
        ),
        Expanded(
          child: DropdownButtonFormField(
            hint: const Text('Vali grupp!'),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10, 8, 10, 8),
              errorStyle: TextStyle(height: 0),
              fillColor: Colors.white,
              filled: true,
              isDense: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            value: _valikGruppId,
            //disabledHint: Text(_disabledUserGrupp),

            // kui on disabled, siis ei täida listi
            onChanged: ((value) {
              _kuiMuutus(value);
            }),
            //Seda näitab ekraanil
            selectedItemBuilder: ((BuildContext context) {
              return _valikGrupp!.map<Widget>((value) {
                return DropdownMenuItem(
                    value: value.id, child: Text(value.nimi));
              }).toList();
            }),
            // Seda näitab listis
            items: _valikGrupp?.map<DropdownMenuItem<int>>((value) {
              if (value.id == _valikGruppId) {
                //log('on sama', name: 'Töötaja dropbox on');
                return DropdownMenuItem(
                  value: value.id,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Theme.of(context).selectedRowColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(value.nimi,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor)),
/*                         Text('Märkus',
                            style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).disabledColor)) */
                      ],
                    ),
                  ),
                );
              } else {
                //log('ei ole sama', name: 'Töötaja dropbox ei');
                return DropdownMenuItem(
                  value: value.id,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(value.nimi),
/*                         Text('Märkus',
                            style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).disabledColor)) */
                      ],
                    ),
                  ),
                );
              }
            }).toList(),
          ),
        ),
      ],
    );
  }
}
