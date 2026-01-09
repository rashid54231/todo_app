import 'package:flutter/material.dart';
import 'supabase_client.dart';
import 'home_screen.dart';
import 'task_screen.dart';
import 'view_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseClientService.init(); // Supabase initialize
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODO App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NavBar(),
    );
  }
}

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const TaskScreen(),
    const ViewScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add_task), label: "Task"),
          BottomNavigationBarItem(icon: Icon(Icons.view_list), label: "View"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
