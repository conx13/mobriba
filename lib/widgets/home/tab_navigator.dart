import 'package:flutter/material.dart';
import '../../config/custom_router.dart';
import '../../enums/bottom_nav_item.dart';
import '../../screens/main/main_page.dart';
import '../../screens/otsi/otsi_koodi_page.dart';
import '../../screens/tootajad/tootajad_page.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';

  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;

  const TabNavigator({Key? key, required this.navigatorKey, required this.item})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilder();
    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoot,
      onGenerateInitialRoutes: (_, initialRoute) {
        return [
          MaterialPageRoute(
              settings: const RouteSettings(name: tabNavigatorRoot),
              builder: (context) => routeBuilders[initialRoute]!(context))
        ];
      },
      onGenerateRoute: CustomRouter.onGenerateNestedRoute,
    );
  }

  Map<String, WidgetBuilder> _routeBuilder() {
    return {tabNavigatorRoot: (context) => _getScren(context, item)};
  }

  _getScren(BuildContext context, BottomNavItem item) {
    switch (item) {
      case BottomNavItem.one:
        return const MainPage();
      case BottomNavItem.two:
        return const Tootajad();
      case BottomNavItem.three:
        return const OtsiKoodiPage();
      default:
        return const Scaffold();
    }
  }
}
