import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const SearchInput({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: controller,
      onChanged: onChanged,
      hintText: 'Search movies...',
      leading: const Icon(Icons.search, color: Colors.grey),
      padding: const WidgetStatePropertyAll<EdgeInsets>(
        EdgeInsets.symmetric(horizontal: 16),
      ),
      elevation: MaterialStateProperty.all(0),
      backgroundColor: MaterialStateProperty.all(Colors.grey[800]),
      hintStyle: MaterialStateProperty.all(
        const TextStyle(color: Colors.grey),
      ),
      textStyle: MaterialStateProperty.all(
        const TextStyle(color: Colors.white),
      ),
    );
  }
}