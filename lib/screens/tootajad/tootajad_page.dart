import 'package:flutter/material.dart';

class Tootajad extends StatelessWidget {
  const Tootajad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => Scaffold(
                      appBar: AppBar(
                        title: const Text('Next Page to Create Post'),
                      ),
                    )));
          },
          child: const Text("Move to Next page"),
        ),
      ),
    );
  }
}
