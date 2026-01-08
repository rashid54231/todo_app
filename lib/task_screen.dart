import 'package:flutter/material.dart';
import 'supabase_client.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final title = TextEditingController();
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  DateTime _combine(TimeOfDay time) {
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
  }

  Future<void> pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => startTime = picked);
    }
  }

  Future<void> pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => endTime = picked);
    }
  }

  Future<void> addTask() async {
    if (title.text.isEmpty || startTime == null || endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields")),
      );
      return;
    }

    final startDateTime = _combine(startTime!);
    final endDateTime = _combine(endTime!);

    await SupabaseClientService.client.from('task').insert({
      'title': title.text,
      'start_time': startDateTime.toIso8601String(),
      'end_time': endDateTime.toIso8601String(),
    });

    title.clear();
    setState(() {
      startTime = null;
      endTime = null;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Task Added")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: "Task Title"),
            ),
            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: pickStartTime,
              child: Text(
                startTime == null
                    ? "Select Start Time"
                    : "Start: ${startTime!.format(context)}",
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: pickEndTime,
              child: Text(
                endTime == null
                    ? "Select End Time"
                    : "End: ${endTime!.format(context)}",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: addTask,
              child: const Text("Add Task"),
            ),
          ],
        ),
      ),
    );
  }
}
