import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('USERNAME', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Container(),
    );
  }
}