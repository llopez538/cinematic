import 'package:flutter/material.dart';

class GradientOverlay extends StatelessWidget {
  final BorderRadius? borderRadius;
  final List<double> stops;
  final List<Color> colors;

  const GradientOverlay({
    super.key,
    this.borderRadius,
    this.stops = const [0.6, 0.95],
    this.colors = const [Colors.transparent, Colors.black],
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: stops,
            colors: colors.map((c) => c.withOpacity(0.7)).toList(),
          ),
        ),
      ),
    );
  }
}