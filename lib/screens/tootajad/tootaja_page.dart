import 'dart:developer';
import 'package:flutter/material.dart';
import '../../models/main/id_nimi.dart';
import '../../models/tootajad/user_model.dart';
import '../../services/api.dart';
import '../../widgets/main/text_input.dart';
import '../../widgets/tootajad/user_pilt.dart';

class UserPage extends StatefulWidget {
  @required
  final int tid;

  const UserPage(this.tid, {Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool _userAktiivne = false;
  bool _isEdit = false;
  late FocusNode minuFookus;

  final TextEditingController userEnimeController = TextEditingController();
  final TextEditingController userPnimeController = TextEditingController();
  final TextEditingController userIkoodController = TextEditingController();
  final TextEditingController userTelefonController = TextEditingController();
  final TextEditingController userGruppController = TextEditingController();
  final TextEditingController userAegController = TextEditingController();
  String _nimeTahed = '';
  late User _user;
  List<IdNimi>? _userGrupp;
  late int _selectedValue = 1;
  String _disabledUserGrupp = '';
  String _userPilt = '';

  @override
  void initState() {
    super.initState();
    getKasutaja();
    minuFookus = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    minuFookus.dispose();

    super.dispose();
  }

// Võtame andmebaasist tootaja andmed
  getKasutaja() async {
    setState(() {
      isLoading = true;
    });
    _user = await getUser(widget.tid);
    //_userGrupp = await httpService.getTootajaGrupp();
    userInitial();
    setState(() {
      isLoading = false;
    });
  }

// Sätime paika esialgsed andmed
  userInitial() {
    setState(() {
      userEnimeController.text = _user.enimi;
      userPnimeController.text = _user.pnimi;
      _nimeTahed = '${_user.enimi}${_user.pnimi}';
      userIkoodController.text = _user.ikood;
      userTelefonController.text = _user.telefon;
      userGruppController.text = _user.toogruppNimi;
      userAegController.text = _user.ajanimi;
      _userAktiivne = _user.aktiivne == 0 ? false : true;
      _selectedValue = _user.toogruppId;
      _disabledUserGrupp = _user.toogruppNimi;
      _userGrupp?.clear();
      _userPilt = _user.pilt;
    });
  }

//kui muudame või tyhistame
  muudaCancel() async {
    if (_isEdit) {
      log('Ei muuda');
      userInitial(); //taastame esialgsed väärtused
      setState(() {
        _isEdit = !_isEdit;
      });
    } else {
      log('muudame');
      setState(() {
        _isEdit = !_isEdit;
      });
      //minuFookus.unfocus();
      _userGrupp = await getTootajaTooGrupp();
      minuFookus.requestFocus(); // ei funka
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          /* actions: [
          // TODO vaja puutumise väli suuremaks teha
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                child: Text(
                  _isEdit == true ? 'Tühista' : 'Muuda',
                ),
                onTap: () {
                  muudaCancel();
                },
              ),
            ),
          )
        ], */
          ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Visibility(
                      visible: isLoading,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    Visibility(
                        visible: !isLoading,
                        child: Column(
                          children: [
                            Visibility(
                              visible: !_isEdit,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  UserPilt(_userPilt, _nimeTahed, widget.tid),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    '${userEnimeController.text} ${userPnimeController.text}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                ],
                              ),
                            ),
                            //EESNIMI
                            Visibility(
                              visible: _isEdit,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 16, 16, 0),
                                child: TextFormField(
                                  controller: userEnimeController,
                                  onChanged: (muutus) =>
                                      {userEnimeController.text = muutus},
                                  decoration: const InputDecoration(
                                    labelText: 'Eesnimi',
                                    hintText: 'Eesnimi',
                                  ),
                                  autofocus: true,
                                  focusNode: minuFookus,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  enabled: _isEdit,
                                  //readOnly: _isEdit,
                                  autocorrect: false,
                                  keyboardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.words,
                                ),
                              ),
                            ),
                            //Perenimi
                            Visibility(
                              visible: _isEdit,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 16, 16, 0),
                                child: TextFormField(
                                  controller: userPnimeController,
                                  decoration: const InputDecoration(
                                    labelText: 'Perenimi',
                                    hintText: 'Perenimi',
                                  ),
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  autocorrect: false,
                                  keyboardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.words,
                                  enabled: _isEdit,
                                ),
                              ),
                            ),
                            //Isikukood
                            Visibility(
                              visible: _isEdit,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 16, 16, 0),
                                child: TextFormField(
                                  controller: userIkoodController,
                                  decoration: const InputDecoration(
                                    labelText: 'Isikukood',
                                    counterText: '',
                                  ),
                                  textAlign: TextAlign.start,
                                  maxLength: 11,
                                  keyboardType: TextInputType.number,
                                  enabled: _isEdit,
                                ),
                              ),
                            ),
                            //Telefon email
                            Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 16, 16, 0),
                                child: TekstInput(
                                  isEdit: _isEdit,
                                  textController: userTelefonController,
                                  label: 'Telefon, email',
                                )),
                            //Grupp
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 16, 16, 0),
                              child: TextFormField(
                                controller: userGruppController,
                                decoration: const InputDecoration(
                                  labelText: 'Töö grupp',
                                ),
                                enabled: _isEdit,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 16, 16, 0),
                              child: TekstInput(
                                textController: userAegController,
                                isEdit: _isEdit,
                                label: 'Aja grupp',
                              ),
                            ),
                            Visibility(
                              visible: _isEdit,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 16, 16, 0),
                                child: CheckboxListTile(
                                    title: const Text('Aktiivne'),
                                    value: _userAktiivne,
                                    onChanged: (val) {
                                      setState(() => _userAktiivne = false);
                                    }),
                              ),
                            ),
                            Visibility(
                              visible: _isEdit,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 16, 16, 0),
                                child: DropdownButtonFormField(
                                  hint: const Text('Vali grupp!'),
                                  decoration: const InputDecoration(
                                    labelText: 'Aja grupp',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(80, 158, 158, 158),
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                  ),
                                  value: _selectedValue,
                                  //disabledHint: Text(_disabledUserGrupp),
                                  disabledHint: Text(
                                    _disabledUserGrupp,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  // kui on disabled, siis ei täida listi
                                  onChanged: _isEdit
                                      ? (int? value) {
                                          setState(() {
                                            _selectedValue = value!;
                                          });
                                        }
                                      : null,
                                  // täidame listi
                                  items: _userGrupp
                                      ?.map<DropdownMenuItem<int>>((value) {
                                    return DropdownMenuItem(
                                      value: value.id,
                                      child: Text(value.nimi,
                                          style: const TextStyle(height: 0.0)),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
