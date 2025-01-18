// lib/widgets/category_card.dart
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;  // Add this line

  const CategoryCard({
    super.key,
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
    this.onTap,  // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(  // Wrap with GestureDetector
        onTap: onTap,
        child: Container(
            width: 150,
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 30,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  count,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            ),
        );
    }
}