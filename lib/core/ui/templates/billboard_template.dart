import 'package:flutter/material.dart';

class BillboardTemplate extends StatelessWidget {
  final List<Widget> slivers;
  final String title;
  final VoidCallback? onRefresh;
  final ScrollController scrollController;

  const BillboardTemplate({
    super.key,
    required this.slivers,
    required this.title,
    this.onRefresh,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [/* ... */],
      ),
      body: CustomScrollView(
        controller: scrollController, // Usa el controller aquí
        slivers: slivers,
      ),
    );
  }
}