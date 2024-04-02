import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
  
}

class _HomePageState extends State<HomePage>{
  DatabaseReference dataRef = FirebaseDatabase.instance.ref('Prova');

  @override
  Widget build(BuildContext context) => Container(child: Text('HomePage'));
}