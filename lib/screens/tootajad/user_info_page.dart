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
  Future<User>? _user;

  @override
  void initState() {
    super.initState();
    _user = getUser(widget.tid);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<User>(
                  future: _user,
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          AppBar(
                            title: SizedBox(
                              height: 50,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: Text(
                                  '*${snapshot.data!.ikood}*',
                                  style: const TextStyle(
                                    fontFamily: 'Ribakood',
                                    //fontSize: 30,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          UserPilt(
                              snapshot.data!.pilt,
                              snapshot.data!.pnimi[0] + snapshot.data!.enimi[0],
                              snapshot.data!.tid),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${snapshot.data!.pnimi} ${snapshot.data!.enimi}',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                              child: Divider()),
                          InfoRida(
                            infoLabel: 'Telefon:',
                            infoText: snapshot.data!.telefon,
                          ),
                          InfoRida(
                            infoLabel: 'Email:',
                            infoText: snapshot.data!.email,
                          ),
                          const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                              child: Divider()),
                          InfoRida(
                            infoLabel: 'Töö grupp:',
                            infoText: snapshot.data!.toogruppNimi,
                          ),
                          InfoRida(
                            infoLabel: 'Aja grupp:',
                            infoText: snapshot.data!.ajanimi,
                          ),
                          const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                              child: Divider()),
                          InfoRida(
                            infoLabel: 'Asutus:',
                            infoText: snapshot.data!.firma,
                          ),
                          InfoRida(
                            infoLabel: 'Töökoht:',
                            infoText: snapshot.data!.asukoht,
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
              child: SelectableText(
                infoText,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}
