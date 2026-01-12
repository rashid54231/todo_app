import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  final Map admin;

  const AdminScreen({super.key, required this.admin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin")),
      body: Center(
        child: Text(
          "Admin Name: ${admin['name']}",
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
