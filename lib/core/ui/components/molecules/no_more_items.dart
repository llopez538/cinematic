import 'package:flutter/material.dart';

class SliverNoMoreItems extends StatelessWidget {
  const SliverNoMoreItems({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            'No more movies to show',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}