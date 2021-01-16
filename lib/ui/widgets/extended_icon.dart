import 'package:flutter/material.dart';

class DefaultIcon extends Icon {
  DefaultIcon(
    IconData icon, {
    this.color,
    this.size,
  }) : super(icon);
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size ?? 28,
      color: color,
    );
  }
}
