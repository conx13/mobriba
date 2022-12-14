import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../config/route_paths.dart';
import '../../screens/home/home_page.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    log('Route: ${settings.name}');
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            settings: const RouteSettings(name: '/'),
            builder: (_) => const Scaffold());

      case RoutePaths.home:
        return CupertinoPageRoute(
            builder: (context) => const HomePage(),
            settings: const RouteSettings(name: RoutePaths.home));

      default:
        return _errorRoute();
    }
  }

  static Route onGenerateNestedRoute(RouteSettings settings) {
    // this is where you define the nested routes.
    switch (settings.name) {
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Something went wrong'),
        ),
      ),
    );
  }
}
