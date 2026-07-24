import 'package:flutter/material.dart';

class dashboardCards0 extends StatelessWidget {
  final String text;
  final String value;

  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final double borderRadius;

  const dashboardCards0({
    super.key,
    required this.text,
    required this.value,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: 160.0, // Fixed height
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.blue,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 5.0,
                    color: Colors.black.withAlpha(128),
                    offset: const Offset(2.0, 2.0),
                  ),
                ],
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(
                      blurRadius: 8.0,
                      color: Colors.black.withAlpha(128),
                      offset: const Offset(3.0, 3.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
