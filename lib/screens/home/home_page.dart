import 'package:flutter/material.dart';
import 'package:mobriba/enums/bottom_nav_item.dart';
import 'package:mobriba/widgets/home/tab_navigator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BottomNavItem selectedItem = BottomNavItem.one;

  final Map<BottomNavItem, GlobalKey<NavigatorState>> navigatorKeys = {
    BottomNavItem.one: GlobalKey<NavigatorState>(),
    BottomNavItem.two: GlobalKey<NavigatorState>(),
    BottomNavItem.three: GlobalKey<NavigatorState>(),
  };

  final Map<BottomNavItem, List> items = const {
    BottomNavItem.one: [Icons.home, 'Kodu'],
    BottomNavItem.two: [Icons.group, 'Töötajad'],
    BottomNavItem.three: [Icons.find_in_page, 'Otsi'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          // This is when you want to remove all the pages from the
          // stack for the specific BottomNav item.
          navigatorKeys[selectedItem]
              ?.currentState
              ?.popUntil((route) => route.isFirst);

          return false;
        },
        child: Stack(
          children: items
              .map(
                (item, _) => MapEntry(
                  item,
                  _buildOffstageNavigator(item, item == selectedItem),
                ),
              )
              .values
              .toList(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: Colors.white,
        //selectedItemColor: Theme.of(context).primaryColor,
        //unselectedItemColor: Colors.grey,
        currentIndex: BottomNavItem.values.indexOf(selectedItem),
        //showSelectedLabels: false,
        //showUnselectedLabels: false,
        onTap: (index) {
          final currentSelectedItem = BottomNavItem.values[index];
          if (selectedItem == currentSelectedItem) {
            navigatorKeys[selectedItem]
                ?.currentState
                ?.popUntil((route) => route.isFirst);
          }
          setState(() {
            selectedItem = currentSelectedItem;
          });
        },
        items: items
            .map((
              item,
              values,
            ) =>
                MapEntry(
                    item.toString(),
                    BottomNavigationBarItem(
                        label: values[1],
                        icon: Icon(
                          values[0],
                          //size: 30.0,
                        ))))
            .values
            .toList(),
      ),
    );
  }

  Widget _buildOffstageNavigator(BottomNavItem currentItem, bool isSelected) {
    return Offstage(
      offstage: !isSelected,
      child: TabNavigator(
        navigatorKey: navigatorKeys[currentItem]!,
        item: currentItem,
      ),
    );
  }
}
