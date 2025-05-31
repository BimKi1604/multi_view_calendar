import 'package:flutter/material.dart';

class ColorUtils {
  static Color mixColors(List<Color> colors) {
    if (colors.isEmpty) return Colors.transparent;

    int totalR = 0, totalG = 0, totalB = 0, totalA = 0;

    for (final color in colors) {
      totalR += color.red;
      totalG += color.green;
      totalB += color.blue;
      totalA += color.alpha;
    }

    int count = colors.length;

    return Color.fromARGB(
      (totalA / count).round(),
      (totalR / count).round(),
      (totalG / count).round(),
      (totalB / count).round(),
    );
  }
}