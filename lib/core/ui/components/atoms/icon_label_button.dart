import 'package:flutter/material.dart';

class IconLabelButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const IconLabelButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white, size: 28),
          onPressed: onPressed ?? () {},
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12
          ),
        ),
      ],
    );
  }
}