import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../Views/shopping_cart_page.dart';
import '../Views/home_page.dart';

class LandingPage extends StatefulWidget {
  static const routeName = 'landingPage';

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: currentScreen(_currentIndex),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            selectedColor: Colors.purple,
          ),
          /// Likes
          SalomonBottomBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            title: Text("Likes"),
            selectedColor: Colors.pink,
          ),
          /// Profile
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
            selectedColor: Colors.teal,
          ),
          /// Profile
          SalomonBottomBarItem(
            icon: Icon(Icons.history),
            title: Text("History"),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }


  Widget currentScreen(int index){
    Widget _screen = Container(color: Colors.white,);

    if(index == 0)
      _screen = HomePage();
    if(index == 1)
      _screen = ShoppingCart(false);

    return _screen;
  }

}
