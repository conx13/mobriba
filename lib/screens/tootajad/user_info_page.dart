import 'package:flutter/material.dart';

import '../../models/tootajad/user_model.dart';
import '../../services/api.dart';
import '../../widgets/tootajad/user_pilt.dart';

class UserInfoPage extends StatefulWidget {
  @required
  final int tid;

  const UserInfoPage(this.tid, {Key? key}) : super(key: key);

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  bool isLoading = false;
  Future<List<User>>? _user;

// Võtame andmebaasist tootaja andmed
  void getKasutaja() async {
    setState(() {
      isLoading = true;
    });
    //_user = await getUser(widget.tid);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _user = getUser(widget.tid);
    //getKasutaja();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          children: [
            FutureBuilder<List<User>>(
                future: _user,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        AppBar(
                          title: Text(
                            '${snapshot.data![0].pnimi} ${snapshot.data![0].enimi}',
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        UserPilt(
                            snapshot.data![0].pilt,
                            snapshot.data![0].pnimi[0] +
                                snapshot.data![0].enimi[0],
                            snapshot.data![0].tid),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          '${snapshot.data![0].pnimi} ${snapshot.data![0].enimi}',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 16, 16, 0),
                          child: Row(
                            children: [
                              const SizedBox(
                                  width: 130, child: Text('Telefon/email:')),
                              // TODO venita rida lõpuni
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.white),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                padding: const EdgeInsets.all(10),
                                //color: Colors.white,
                                child: Text(
                                  snapshot.data![0].telefon,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ],
        ),
      ),
    );
  }
}
