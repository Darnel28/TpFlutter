import 'package:flutter/material.dart';

class StatKpiCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const StatKpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: color.withOpacity(0.1),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87,
                      )),
                  const SizedBox(height: 6),
                  Text(value,
                      style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: color,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
