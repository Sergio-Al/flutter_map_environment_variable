import 'package:flutter/material.dart';

class CircularFAB extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const CircularFAB({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0,2),
          )
        ]
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black87),
        onPressed: onPressed
      )
    );
  }
}
