import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpcomingTasksScreen extends StatefulWidget {
  final DateTime selectedDate;

  const UpcomingTasksScreen({
    required this.selectedDate,
  });

  @override
  _UpcomingTasksScreenState createState() => _UpcomingTasksScreenState();
}

class _UpcomingTasksScreenState extends State<UpcomingTasksScreen> {
  List<dynamic> tasks = [];

  @override
  void didUpdateWidget(covariant UpcomingTasksScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget) {
      fetchUpcomingTasks();
    }
  }

  bool iscompleted = false;

  @override
  void initState() {
    super.initState();
    fetchUpcomingTasks();
  }

  Future<void> fetchUpcomingTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';
    final formattedDueDate =
        DateFormat('yyyy-MM-dd').format(widget.selectedDate);

    final response = await http.post(
      Uri.parse(
          'http://127.0.0.1:8000/api/taskapp/tasks-for-upcoming?_method=GET'),
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

  void updateTaskCompletion(int taskId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.put(
      Uri.parse(
          'http://127.0.0.1:8000/api/taskapp/update-task-completion/$taskId'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, bool>{'completed': true}),
    );

    if (response.statusCode == 200) {
      // Task updated successfully
      // Refresh task list
      fetchUpcomingTasks();
    } else {
      // Failed to update task
      print('Failed to update task completion');
    }
  }

  void deleteTask(int taskId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Are you sure you want to delete this task?"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Close the dialog
                Navigator.of(context).pop();
                // Proceed with task deletion
                final response = await http.delete(
                  Uri.parse(
                      'http://127.0.0.1:8000/api/taskapp/remove-task/$taskId'),
                  headers: <String, String>{
                    'Authorization': 'Bearer $accessToken',
                  },
                );
                if (response.statusCode == 200) {
                  // Task deleted successfully
                  // Refresh task list
                  fetchUpcomingTasks();
                } else {
                  // Failed to delete task
                  print('Failed to delete task');
                }
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            leading: IconButton(
              onPressed: () {
                // Update task completion status
                updateTaskCompletion(task['id']);
              },
              icon: task['completed']
                  ? Icon(Icons.check_circle)
                  : Icon(Icons.circle_outlined),
            ),
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
                    // Show delete confirmation dialog
                    deleteTask(task['id']);
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
