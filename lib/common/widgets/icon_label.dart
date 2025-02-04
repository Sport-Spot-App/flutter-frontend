import 'package:flutter/material.dart';
import 'package:sport_spot/common/constants/app_colors.dart';

class IconWithLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const IconWithLabel({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.darkOrange : const Color.fromARGB(133, 0, 0, 0),
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.darkOrange : const Color.fromARGB(133, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}