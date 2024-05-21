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
    if (widget.selectedDate != oldWidget.selectedDate) {
      fetchUpcomingTasks();
    }
  }

  bool isCompleted = false;

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
      fetchUpcomingTasks();
    } else {
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
                Navigator.of(context).pop();
                final response = await http.delete(
                  Uri.parse(
                      'http://127.0.0.1:8000/api/taskapp/remove-task/$taskId'),
                  headers: <String, String>{
                    'Authorization': 'Bearer $accessToken',
                  },
                );
                if (response.statusCode == 200) {
                  fetchUpcomingTasks();
                } else {
                  print('Failed to delete task');
                }
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }

  void viewTaskDetails(dynamic task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TaskDetailsDialog(
          task: task,
          onSave: () {
            fetchUpcomingTasks(); // Fetch tasks again after updating
          },
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
                    viewTaskDetails(task);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
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

class TaskDetailsDialog extends StatefulWidget {
  final dynamic task;
  final Function onSave;

  TaskDetailsDialog({required this.task, required this.onSave});

  @override
  _TaskDetailsDialogState createState() => _TaskDetailsDialogState();
}

class _TaskDetailsDialogState extends State<TaskDetailsDialog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.task['title'];
    descriptionController.text = widget.task['description'];
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _saveEditedTask() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.put(
      Uri.parse('http://127.0.0.1:8000/api/taskapp/update-task/${widget.task['id']}'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': titleController.text,
        'description': descriptionController.text,
      }),
    );

    if (response.statusCode == 200) {
      widget.onSave();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task updated successfully')),
      );
      Navigator.pop(context);
    } else {
      print('Failed to update task');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Task Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          SizedBox(height: 8),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          SizedBox(height: 16),
          Text('Priority: ${widget.task['priority']}'),
          SizedBox(height: 8),
          Text('Due Date: ${widget.task['due_date']}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveEditedTask,
          child: Text('Save'),
        ),
      ],
    );
  }
}
