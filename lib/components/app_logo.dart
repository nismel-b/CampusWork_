import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const AppLogo({
    super.key,
    this.size = 40,
    this.color,
  });

  const AppLogo.small({
    super.key,
    this.size = 24,
    this.color,
  });

  const AppLogo.large({
    super.key,
    this.size = 80,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color ?? Theme.of(context).primaryColor,
            (color ?? Theme.of(context).primaryColor).withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.2),
        boxShadow: [
          BoxShadow(
            color: (color ?? Theme.of(context).primaryColor).withValues(alpha: 0.3),
            blurRadius: size * 0.1,
            offset: Offset(0, size * 0.05),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'CW',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
            letterSpacing: -1,
          ),
        ),
      ),
    );
  }
}