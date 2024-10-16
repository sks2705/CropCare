import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    super.key,
    required this.label,
    this.fontSize = 18,
    this.color,
    this.fontWeight,
  });

  final String label;
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        label,
        style: TextStyle(
          color: color ?? const Color.fromARGB(255, 0, 0, 0),
          fontSize: fontSize,
          fontWeight: fontWeight ?? FontWeight.w500,
        ),
      ),
    );
  }
}
