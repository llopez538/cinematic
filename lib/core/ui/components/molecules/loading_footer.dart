import 'package:flutter/material.dart';

class SliverLoadingFooter extends StatelessWidget {
  const SliverLoadingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}