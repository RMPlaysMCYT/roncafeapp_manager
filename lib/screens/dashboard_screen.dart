import 'package:flutter/material.dart';
import 'package:roncafeapp_manager/widgets/dashboardCards0.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Container(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Column(
            children: [
              Text('Welcome to the Dashboard!'),
              Row(
                children: [
                  dashboardCards0(text: "Total Launches", value: "1223"),
                  Spacer(),
                  dashboardCards0(text: "Total Launches", value: "1223"),
                  Spacer(),
                  dashboardCards0(text: "Total Launches", value: "1223"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
