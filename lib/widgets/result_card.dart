
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ResultCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final Color color;
  final bool isPositive;

  const ResultCard({
    Key? key,
    required this.title,
    required this.value,
    this.subtitle,
    this.color = Colors.blue,
    this.isPositive = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: color.withOpacity(0.5), width: 1.5),
          boxShadow: [
             BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
             )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
             if (subtitle != null) ...[
               const SizedBox(height: 4),
               Text(
                 subtitle!,
                 style: TextStyle(
                   color: isPositive ? Colors.green : Colors.red,
                   fontWeight: FontWeight.w600,
                   fontSize: 12,
                 ),
               ),
             ]
          ],
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "Masukkan data untuk mulai simulasi",
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
