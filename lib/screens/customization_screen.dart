import 'package:flutter/material.dart';

class CustomizeScreen extends StatelessWidget {
  const CustomizeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customization Section'),
      ),
      body: const Center(
        child: Text('Welcome to the Customization Section!'),
      ),
    );
  }
}