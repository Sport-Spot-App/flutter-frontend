import 'package:flutter/material.dart';

class RoleButton extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onPressed;

  const RoleButton({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF6F0),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 10),
            Image.asset(
              imagePath,
              height: 200,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}