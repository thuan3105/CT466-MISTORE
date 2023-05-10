import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_ecommerce/ui/splash_screen.dart';

import '../admin/product_manager/product_manager.dart';
import '../ui/bottom_nav_pages/profile.dart';
import 'myTitle.dart';

class InfoDrawer extends StatelessWidget {
  InfoDrawer({Key? key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: myTitle('Admin Manager', 22),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.work_outline_outlined),
            title: myTitle('Products Manager', 16),
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (_) => ProductAdminManager()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: myTitle('Logout', 16),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.push(
                  context, CupertinoPageRoute(builder: (_) => SplashScreen()));
            },
          ),
        ],
      ),
    );
  }
}
