import 'package:flutter/material.dart';

class SuccessfullNotification extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final String imagePath;
  final VoidCallback onClose;

  SuccessfullNotification({
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
      margin: EdgeInsets.all(16.0),
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
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            SizedBox(height: 4.0),
            Text(
              description,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.close),
          onPressed: onClose,
        ),
      ),
    );
  }
}



