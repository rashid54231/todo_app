import 'package:flutter/material.dart';
import 'supabase_client.dart';

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
    loadProfiles();
  }

  Future<void> loadProfiles() async {
    final data = await SupabaseClientService.client
        .from('profile')
        .select()
        .order('created_at');

    students = data.where((e) => e['role'] == 'student').toList();
    admins = data.where((e) => e['role'] == 'admin').toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profiles")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          /// STUDENT SECTION
          const Text(
            "Students",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),

          ...students.map((s) => ListTile(
            leading: const Icon(Icons.school),
            title: Text(s['name']),
          )),

          const SizedBox(height: 30),

          /// ADMIN SECTION
          const Text(
            "Admins",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),

          ...admins.map((a) => ListTile(
            leading: const Icon(Icons.admin_panel_settings),
            title: Text(a['name']),
          )),
        ],
      ),
    );
  }
}
