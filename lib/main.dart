import 'package:mobriba/theme/input_dec.dart';

import '../../config/custom_router.dart';
import '../../config/route_paths.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        //inputDecorationTheme: MinuInputTheme().theme(),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            side: BorderSide(color: Theme.of(context).colorScheme.outline),
          ),
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 4),
        ),
      ),
      title: 'rKood',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: CustomRouter.onGenerateRoute,
      initialRoute: RoutePaths.home,
    );
  }
}
