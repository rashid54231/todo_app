import 'package:flutter/material.dart';
import 'supabase_client.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({super.key});

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  List tasks = [];

  @override
  void initState() {
    super.initState();
    fetchAllTasks();
  }

  // 🔹 Fetch all tasks
  Future<void> fetchAllTasks() async {
    final List data = await SupabaseClientService.client
        .from('task')
        .select()
        .order('created_at', ascending: false);

    setState(() {
      tasks = data;
    });
  }

  // 🔹 Delete task (DB + UI)
  Future<void> deleteTask(String id) async {
    try {
      await SupabaseClientService.client
          .from('task')
          .delete()
          .eq('id', id);

      // remove from UI instantly
      setState(() {
        tasks.removeWhere((task) => task['id'].toString() == id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task Deleted")),
      );
    } catch (e) {
      debugPrint("DELETE ERROR: $e");
    }
  }

  // 🔹 Update task title
  Future<void> updateTask(String id, String title) async {
    await SupabaseClientService.client
        .from('task')
        .update({'title': title})
        .eq('id', id);

    fetchAllTasks();
  }

  // 🔹 Edit dialog
  void showEditDialog(String id, String oldTitle) {
    final controller = TextEditingController(text: oldTitle);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Task"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              updateTask(id, controller.text);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  String formatTime(String timestamp) {
    final dt = DateTime.parse(timestamp);
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View Tasks")),
      body: tasks.isEmpty
          ? const Center(child: Text("No tasks found"))
          : ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];

          return ListTile(
            title: Text(task['title']),
            subtitle: Text(
              "${formatTime(task['start_time'])} - ${formatTime(task['end_time'])}",
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => showEditDialog(
                    task['id'].toString(),
                    task['title'],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () =>
                      deleteTask(task['id'].toString()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
