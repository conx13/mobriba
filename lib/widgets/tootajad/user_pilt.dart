import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:image_picker/image_picker.dart';
import '../../services/api.dart';
import '../../services/http_service.dart';

class UserPilt extends StatefulWidget {
  @required
  final String userPilt;
  final String nimeTahed;
  final int tid;

  const UserPilt(this.userPilt, this.nimeTahed, this.tid, {Key? key})
      : super(key: key);

  @override
  State<UserPilt> createState() => _UserPiltState();
}

class _UserPiltState extends State<UserPilt> {
  bool _piltLaeb = false;
  String _pilt = '';

  @override
  void initState() {
    super.initState();
    _pilt = widget.userPilt;
  }

// Negatiivne teade
  negSnackBar(String teade) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).errorColor,
      content: Text(teade),
    ));
  }

// Positiivne teade
  posSnackBar(String teade) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: Text(teade),
    ));
  }

// Muudame pilt ja võtame pildi galeriist
  Future valiPilt() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      setState(() {
        _piltLaeb = true;
      });
      _pilt = await postPicture(image.path, widget.tid);
      setState(() {
        _piltLaeb = false;
      });
      // Igaksjuhuks kontrollime kas on mounted
      if (!mounted) return;
      posSnackBar('Pilt on muudetud');
    } catch (e) {
      negSnackBar('Pildi muutmine nurjus!');
      log('Pildi muutmine nurjus: $e');
    }
  }

// Kustutame pildi
  Future kustutaPilt(String photo) async {
    try {
      if (photo == '') return;
      setState(() {
        _piltLaeb = true;
      });
      await delPilt(photo);
      setState(() {
        _pilt = '';
        _piltLaeb = false;
      });
      if (!mounted) return;
      posSnackBar('Pilt on kustutatud!');
    } catch (e) {
      negSnackBar('Pildi muutmine nurjus!');
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
                child: naitaPilti(_pilt)),
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
                  primary: Theme.of(context).primaryColor,
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
  Widget naitaPilti(photo) {
    if (_piltLaeb) {
      return const CircularProgressIndicator();
    } else if (photo == '') {
      return Text(
        widget.nimeTahed,
        style: Theme.of(context).textTheme.displayMedium,
      );
    } else {
      return CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage('$url/pics/$photo', headers: httpPais),
      );
    }
  }

  //Pildi muutmise dialoog
  Widget muudaPilti(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(0),
      //actionsAlignment: MainAxisAlignment.spaceEvenly,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.red,
                size: 25,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          const Center(
            child: Text('Kas soovid muuta pilti?'),
          )
        ],
      ),
      //title: const Text('Kas soovid muuta pilti?'),
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
            kustutaPilt(_pilt);
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
