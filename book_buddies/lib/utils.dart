import 'package:flutter/material.dart';

Widget buildPhotoIcon(Color color) => ClipOval(
      child: Container(
        padding: const EdgeInsets.all(8),
        color: color,
        child: const Icon(
          Icons.upload,
          color: Colors.white,
          size: 20,
        ),
      ),
    );

class MyClip extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return const Rect.fromLTWH(0, 0, 200, 200);
  }

  @override
  bool shouldReclip(oldClipper) {
    return true;
  }
}
