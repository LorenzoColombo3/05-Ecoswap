import 'package:flutter/material.dart';

class ListViewProfilePage extends StatelessWidget {
  final String title;
  final String description;

  const ListViewProfilePage({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.favorite, color: Colors.red),
              SizedBox(width: 4),
            ],
          ),
        ],
      ),
    );
  }
}
