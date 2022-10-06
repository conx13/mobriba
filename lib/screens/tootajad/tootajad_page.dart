import 'package:flutter/material.dart';

class Tootajad extends StatelessWidget {
  const Tootajad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          pinned: true,
          snap: false,
          centerTitle: true,
          title: Text('Töötajad'),
          bottom: AppBar(
            title: Container(
              child: const Center(
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Otsi töötajat:',
                      suffixIcon: Icon(Icons.search)),
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
