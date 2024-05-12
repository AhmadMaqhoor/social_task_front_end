import 'package:flutter/material.dart';

class SetGoalsPage extends StatefulWidget {
  @override
  _SetGoalsPageState createState() => _SetGoalsPageState();
}

class _SetGoalsPageState extends State<SetGoalsPage> {
  final TextEditingController _dailyGoalsController = TextEditingController();
  final TextEditingController _weeklyGoalsController = TextEditingController();

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
              controller: _dailyGoalsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Daily Goals',
                hintText: 'Enter your daily goals',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _weeklyGoalsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Weekly Goals',
                hintText: 'Enter your weekly goals',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveGoals();
              },
              child: Text('Save Goals'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveGoals() {
    // Get the entered values from the text fields
    final dailyGoals = int.tryParse(_dailyGoalsController.text) ?? 0;
    final weeklyGoals = int.tryParse(_weeklyGoalsController.text) ?? 0;

    // Process the goals, e.g., save to database or perform other actions
    // Here, we simply print the entered values
    print('Daily Goals: $dailyGoals');
    print('Weekly Goals: $weeklyGoals');

    // Optionally, you can navigate back to the previous screen after saving
    Navigator.pop(context);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _dailyGoalsController.dispose();
    _weeklyGoalsController.dispose();
    super.dispose();
  }
}
