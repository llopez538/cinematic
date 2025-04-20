import 'package:cinematic/core/ui/components/atoms/icon_label_button.dart';
import 'package:flutter/material.dart';

class ActionButtonsRow extends StatelessWidget {
  const ActionButtonsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        IconLabelButton(
          icon: Icons.add, 
          label: 'Añadir'
        ),
        IconLabelButton(
          icon: Icons.share, 
          label: 'Compartir'
        ),
        IconLabelButton(
          icon: Icons.star_border, 
          label: 'Valorar'
        ),
        IconLabelButton(
          icon: Icons.more_vert, 
          label: 'Más'
        ),
      ],
    );
  }
}