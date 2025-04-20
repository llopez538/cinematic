import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final TextAlign? align;

  const StyledText({
    super.key,
    required this.text,
    this.color = Colors.white70,
    this.fontSize = 14,
    this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
      ),
      textAlign: align,
    );
  }
}