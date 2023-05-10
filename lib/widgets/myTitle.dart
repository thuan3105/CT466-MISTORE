import 'package:flutter/material.dart';

Widget myTitle(String title, double size) {
  return ShaderMask(
    shaderCallback: (bounds) => LinearGradient(
      colors: [Color.fromARGB(255, 0, 64, 255), Colors.red],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      tileMode: TileMode.mirror,
    ).createShader(bounds),
    child: Text(
      title,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}
