import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:isd_project/taskmanager/productivity.dart';

class SetGoalsPagePerWeek extends StatefulWidget {
  final String productivityId;
  final Function fetchProductivity;
  const SetGoalsPagePerWeek({required this.productivityId,required this.fetchProductivity,});

  @override
  _SetGoalsPagePerWeekState createState() => _SetGoalsPagePerWeekState();
}

class _SetGoalsPagePerWeekState extends State<SetGoalsPagePerWeek> {
  final TextEditingController _weeklyGoalsController = TextEditingController();

  Future<void> updateWeeklyGoal() async {
    final String weeklyGoal = _weeklyGoalsController.text.trim();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.put(
      Uri.parse('http://192.168.0.105:8000/api/taskapp/update-max-prodactivity-per-week/${widget.productivityId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(<String, String>{
        'max_tasks_per_week': weeklyGoal,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
     Navigator.pop(context);
      widget.fetchProductivity();
    } else {
      // Display error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to update goal'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Goals'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _weeklyGoalsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Weekly Goals',
                hintText: 'Enter your daily goals',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                updateWeeklyGoal();
              },
              style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.blue,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5, // Adds a shadow for a 3D effect
      ),
              child: Text('Save Goals'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _weeklyGoalsController.dispose();
    super.dispose();
  }
}
