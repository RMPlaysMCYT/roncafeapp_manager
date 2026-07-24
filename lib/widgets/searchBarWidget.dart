import 'package:flutter/material.dart';

class Searchbarwidget extends StatelessWidget {
  const Searchbarwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500, // Give it a fixed width or use constraints
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF22BBAA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
