import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpcomingTasksScreen extends StatefulWidget {
  final DateTime selectedDate;

  const UpcomingTasksScreen({required this.selectedDate,});

  @override
  _UpcomingTasksScreenState createState() => _UpcomingTasksScreenState();
}

class _UpcomingTasksScreenState extends State<UpcomingTasksScreen> {
  List<dynamic> tasks = [];

@override
void didUpdateWidget(covariant UpcomingTasksScreen oldWidget){
  super.didUpdateWidget(oldWidget);
  if (widget.selectedDate != oldWidget){
    fetchUpcomingTasks();
  }
}
  @override
  void initState() {
    super.initState();
    fetchUpcomingTasks();
  }
 
  Future<void> fetchUpcomingTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';
    final formattedDueDate = DateFormat('yyyy-MM-dd').format(widget.selectedDate);

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/taskapp/tasks-for-upcoming?_method=GET'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
      body: {
        'due_date': formattedDueDate,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        tasks = jsonDecode(response.body)['tasks_for_selected_date'];
      });
    } else {
      print('Failed to load tasks');
    }
  }

  void viewTaskDetails(int taskId) {
    // Navigate to task details screen using taskId
    // Implement your navigation logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upcoming\'s Tasks'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            leading: Icon(Icons.circle_outlined),
            title: Text(task['title']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.visibility),
                  onPressed: () {
                    viewTaskDetails(task['id']);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Implement delete functionality
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}