import 'package:flutter/material.dart';

class TeSpacer extends StatelessWidget {
  final double width;
  final double height;

  const TeSpacer({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}
