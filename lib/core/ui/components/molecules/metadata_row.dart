import 'package:cinematic/core/ui/components/atoms/styled_text.dart';
import 'package:flutter/material.dart';

class MetadataRow extends StatelessWidget {
  final List<String> items;

  const MetadataRow({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items
          .map((item) => Row(
                children: [
                  MetadataItem(text: item),
                  if (item != items.last) const MetadataDivider(),
                ],
              ))
          .expand((widget) => widget.children)
          .toList(),
    );
  }
}

class MetadataItem extends StatelessWidget {
  final String text;

  const MetadataItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return StyledText(text: text);
  }
}

class MetadataDivider extends StatelessWidget {
  const MetadataDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Text('•', style: TextStyle(color: Colors.white70, fontSize: 14)),
    );
  }
}