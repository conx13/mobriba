import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:image_picker/image_picker.dart';
import 'package:mobriba/services/api.dart';
import 'package:mobriba/services/http_service.dart';

class UserPilt extends StatefulWidget {
  @required
  String userPilt = '';
  final String nimeTahed;
  final int tid;

  UserPilt(this.userPilt, this.nimeTahed, this.tid, {Key? key})
      : super(key: key);

  @override
  State<UserPilt> createState() => _UserPiltState();
}

// Negatiivne teade
negSnackBar(String teade, context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Theme.of(context).errorColor,
    content: Text(teade),
  ));
}

// Positiivne teade
posSnackBar(String teade, context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.green,
    content: Text(teade),
  ));
}

class _UserPiltState extends State<UserPilt> {
  bool _piltLaeb = false;

// Muudame pilt ja võtame pildi galeriist
  Future valiPilt() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      setState(() {
        _piltLaeb = true;
      });
      widget.userPilt = await postPicture(image.path, widget.tid);
      setState(() {
        _piltLaeb = false;
      });
      // Igaksjuhuks kontrollime kas on mounted
      if (!mounted) return;
      posSnackBar('Pilt on muudetud', context);
    } catch (e) {
      negSnackBar('Pildi muutmine nurjus!', context);
      log('Pildi muutmine nurjus: $e');
    }
  }

// Kustutame pildi
  Future kustutaPilt(String pilt) async {
    try {
      if (pilt == '') return;
      setState(() {
        _piltLaeb = true;
      });
      await delPilt(pilt);
      setState(() {
        _piltLaeb = false;
        widget.userPilt = '';
      });
      if (!mounted) return;
      posSnackBar('Pilt on kustutatud!', context);
    } catch (e) {
      negSnackBar('Pildi muutmine nurjus!', context);
      log('Pildi muutmine nurjus: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
                alignment: Alignment.center,
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 4,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 2,
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 10),
                    ),
                  ],
                  shape: BoxShape.circle,
                ),
                child: naitaPilti(context)),
            Positioned(
              bottom: 0,
              right: 0,
              //TODO IconButton

              child: ElevatedButton(
                //onPressed: () => {valiPilt()},
                onPressed: (() {
                  showDialog(
                      context: context,
                      builder: ((context) => muudaPilti(context)));
                }),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(30, 30),
                  side: BorderSide(
                      width: 2,
                      color: Theme.of(context).scaffoldBackgroundColor),
                  shape: const CircleBorder(),
                ),
                child: const Icon(Icons.edit, color: Colors.white),
              ),
            )
          ],
        ),
      ],
    );
  }

// Vastavalt kas on pilt ja kas laeb pilti, näitab pilti või infot
  Widget naitaPilti(context) {
    if (_piltLaeb) {
      return const CircularProgressIndicator();
    } else if (widget.userPilt == '') {
      return Text(
        widget.nimeTahed,
        style: Theme.of(context).textTheme.displayMedium,
      );
    } else {
      return CircleAvatar(
        radius: 60,
        backgroundImage:
            NetworkImage('$url/pics/${widget.userPilt}', headers: http_pais),
      );
    }
  }

  //Pildi muutmise dialoog
  Widget muudaPilti(BuildContext context) {
    return AlertDialog(
      title: const Text('Kas soovid muuta pilti?'),
      actions: [
        TextButton.icon(
          onPressed: () {
            valiPilt();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.camera),
          label: const Text('Muuda'),
          style: TextButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              side: BorderSide(color: Theme.of(context).primaryColor)),
        ),
        TextButton.icon(
          onPressed: () {
            kustutaPilt(widget.userPilt);
            Navigator.pop(context);
          },
          icon: const Icon(Icons.delete),
          label: const Text('Kustuta'),
          style: TextButton.styleFrom(
              primary: Theme.of(context).errorColor,
              side: BorderSide(color: Theme.of(context).errorColor)),
        )
      ],
    );
  }
}
