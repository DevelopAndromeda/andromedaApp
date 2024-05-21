import 'package:flutter/material.dart';

class ReservationNotification extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final String imagePath;
  final VoidCallback onClose;

  ReservationNotification({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imagePath,
    required this.onClose,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(16.0),
      child: ListTile(
        leading: Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(imagePath),
            ),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            const SizedBox(height: 4.0),
            Text(
              description,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close),
          onPressed: onClose,
        ),
      ),
    );
  }
}
