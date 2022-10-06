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
        child: SingleChildScrollView(
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
                              '*${snapshot.data![0].ikood}*',
                              style: const TextStyle(
                                  fontFamily: 'Ribakood', fontSize: 20),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          UserPilt(
                              snapshot.data![0].pilt,
                              snapshot.data![0].pnimi[0] +
                                  snapshot.data![0].enimi[0],
                              snapshot.data![0].tid),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${snapshot.data![0].pnimi} ${snapshot.data![0].enimi}',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                              child: Divider()),
                          InfoRida(
                            infoLabel: 'Telefon:',
                            infoText: snapshot.data![0].telefon,
                          ),
                          InfoRida(
                            infoLabel: 'Email:',
                            infoText: snapshot.data![0].email,
                          ),
                          const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                              child: Divider()),
                          InfoRida(
                            infoLabel: 'Töö grupp:',
                            infoText: snapshot.data![0].toogruppNimi,
                          ),
                          InfoRida(
                            infoLabel: 'Aja grupp:',
                            infoText: snapshot.data![0].ajanimi,
                          ),
                          const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                              child: Divider()),
                          InfoRida(
                            infoLabel: 'Asutus:',
                            infoText: snapshot.data![0].firma,
                          ),
                        ],
                      );
                    } else {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoRida extends StatelessWidget {
  final String infoLabel;
  final String infoText;

  const InfoRida({
    required this.infoLabel,
    required this.infoText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 2, 16, 0),
      child: Row(
        children: [
          SizedBox(
              width: 80,
              child: Align(
                  alignment: Alignment.centerRight, child: Text(infoLabel))),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              padding: const EdgeInsets.all(8),
              //color: Colors.white,
              child: Text(
                infoText,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}
