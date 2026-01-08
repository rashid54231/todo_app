import 'package:flutter/material.dart';
import 'supabase_client.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List tasks = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    tasks = await SupabaseClientService.client
        .from('task')
        .select()
        .order('created_at', ascending: false)
        .limit(5);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recent Tasks")),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (_, i) => ListTile(
          title: Text(tasks[i]['title']),
        ),
      ),
    );
  }
}
