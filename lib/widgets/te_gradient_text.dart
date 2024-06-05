import 'package:flutter/material.dart';

Widget teGradientText(String text, List<Color> colors, double fontSize, double angle) {
  return ShaderMask(
    blendMode: BlendMode.srcIn,
    shaderCallback: (Rect bounds) {
      return LinearGradient(
        colors: colors,
        transform: GradientRotation(angle * (3.141592653589793 / 180)), // Convert degrees to radians
      ).createShader(bounds);
    },
    child: Text(
      text,
      style: TextStyle(
        fontSize: fontSize, // Adjust font size as needed
        fontWeight: FontWeight.bold, // Adjust font weight as needed
        color: Colors.white, // The base color of the text
      ),
    ),
  );
}
