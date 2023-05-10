import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/const/AppColors.dart';
import 'package:flutter_ecommerce/ui/bottom_nav_pages/home.dart';
import 'package:flutter_ecommerce/ui/login_screen.dart';
import 'package:flutter_ecommerce/widgets/myTitle.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bottom_nav_controller.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        Duration(seconds: 3),
        () => Navigator.push(
            // context, CupertinoPageRoute(builder: (_) => LoginScreen())));
            context,
            CupertinoPageRoute(builder: (_) => LoginScreen())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              myTitle('MiStore', 40),
              SizedBox(
                height: 20.h,
              ),
              CircularProgressIndicator(
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
