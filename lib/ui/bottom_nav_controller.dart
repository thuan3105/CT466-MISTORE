import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/const/AppColors.dart';
import 'package:flutter_ecommerce/ui/bottom_nav_pages/cart.dart';
import 'package:flutter_ecommerce/ui/bottom_nav_pages/favourite.dart';
import 'package:flutter_ecommerce/ui/bottom_nav_pages/home.dart';
import 'package:flutter_ecommerce/ui/bottom_nav_pages/profile.dart';
import '../widgets/myTitle.dart';

class BottomNavController extends StatefulWidget {
  @override
  _BottomNavControllerState createState() => _BottomNavControllerState();
}

User? user = FirebaseAuth.instance.currentUser;

class _BottomNavControllerState extends State<BottomNavController> {
  final _pages = [
    Home(),
    Favourite(),
    Cart(),
    Profile(),
  ];
  var _currentIndex = 0;
  Future<void> reloadUser() async {
    if (user != null) {
      await user?.reload();
      user = FirebaseAuth.instance.currentUser;
      print(user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('//');
    print(user!.uid);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: myTitle('MiStore', 30),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        selectedItemColor: AppColors.deep_orange,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        selectedLabelStyle:
            TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: 'Favarite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) async {
          if (index == 3) {
            await reloadUser();
          }
          setState(() {
            _currentIndex = index;
            reloadUser();
            print(_currentIndex);
          });
        },
      ),
      body: _pages[_currentIndex],
    );
  }
}
