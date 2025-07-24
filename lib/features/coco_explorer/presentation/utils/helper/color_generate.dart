import 'package:flutter/material.dart';

Color getColorByIndex(int index) {
  final colors = [
    Colors.green.withAlpha(125),
    Colors.red.withAlpha(125),
    Colors.blue.withAlpha(125),
    Colors.orange.withAlpha(125),
    Colors.purple.withAlpha(125),
    Colors.indigo.withAlpha(125),
    Colors.cyan.withAlpha(125),
    Colors.pink.withAlpha(125),
    Colors.teal.withAlpha(125),
    Colors.yellow.withAlpha(125),
  ];

  return colors[index % colors.length];
}
