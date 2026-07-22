import 'package:flutter/material.dart';

class ApplicationScreen extends StatelessWidget {
  const ApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application'),
      ),
      body: const Center(
        child: Text('Welcome to the Application!'),
      ),
    );
  }
}