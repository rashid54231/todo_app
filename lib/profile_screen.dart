import 'package:flutter/material.dart';
import 'supabase_client.dart';
import 'student_screen.dart';
import 'admin_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List students = [];
  List admins = [];

  @override
  void initState() {
    super.initState();
    fetchProfiles();
  }

  Future<void> fetchProfiles() async {
    final data = await SupabaseClientService.client
        .from('profile')
        .select();

    setState(() {
      students = data.where((e) => e['role'] == 'student').toList();
      admins = data.where((e) => e['role'] == 'admin').toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profiles")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// STUDENT SECTION
              const Text("Students",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              ...students.map((s) => Card(
                child: ListTile(
                  title: Text(s['name']),
                  trailing: ElevatedButton(
                    child: const Text("View"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StudentScreen(student: s),
                        ),
                      );
                    },
                  ),
                ),
              )),

              const SizedBox(height: 30),

              /// ADMIN SECTION
              const Text("Admins",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              ...admins.map((a) => Card(
                child: ListTile(
                  title: Text(a['name']),
                  trailing: ElevatedButton(
                    child: const Text("View"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminScreen(admin: a),
                        ),
                      );
                    },
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
