import 'package:flutter/material.dart';

class StudentScreen extends StatelessWidget {
  final Map student;

  const StudentScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student")),
      body: Center(
        child: Text(
          "Student Name: ${student['name']}",
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
