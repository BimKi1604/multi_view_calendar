import 'package:flutter/material.dart';

class ColorUtils {
  static Color mixColors(List<Color> colors) {
    if (colors.isEmpty) return Colors.transparent;

    double totalR = 0, totalG = 0, totalB = 0, totalA = 0;

    for (final color in colors) {
      totalR += (color.value >> 16) & 0xFF;
      totalG += (color.value >> 8) & 0xFF;
      totalB += (color.value) & 0xFF;
      totalA += (color.value >> 24) & 0xFF;
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
