import 'package:flutter/material.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Games Section'),
      ),
      body: const Center(
        child: Text('Welcome to the Games Section!'),
      ),
    );
  }
}