import 'package:flutter/material.dart';
import 'package:isd_project/taskmanager/navigationbar.dart';
import 'package:isd_project/taskmanager/setgoals.dart';

class ProductivityPage extends StatefulWidget {
  const ProductivityPage({super.key});

  @override
  State<ProductivityPage> createState() => _ProductivityPageState();
}

class _ProductivityPageState extends State<ProductivityPage> {
  String _selectedSection = 'Daily Goals'; // Default selected section
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Productivity'),
        leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: Icon(Icons.hide_source)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSectionButton('Daily Goals'),
                _buildSectionButton('Weekly Goals'),
                _buildSectionButton('Karma'),
              ],
            ),
            SizedBox(height: 20),
            if (_selectedSection == 'Daily Goals')
              _buildGoalWidget(
                title: 'Daily Goals',
                completed: 3,
                total: 5,
                motivationText: 'Keep up the good work!',
                streak: 2,
                icon: Icons.emoji_events, // Medal icon
              ),
            if (_selectedSection == 'Weekly Goals')
              _buildGoalWidget(
                title: 'Weekly Goals',
                completed: 7,
                total: 10,
                motivationText: 'You can do it!',
                streak: 1,
                icon: Icons.emoji_events, // Medal icon
              ),
            if (_selectedSection == 'Karma')
              _buildKarmaWidget(
                points: 350,
                rank: 'Gold',
              ),
          ],
        ),
      ),
      drawer: const NavSideBar(),
    );
  }

  Widget _buildSectionButton(String section) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedSection = section;
        });
      },
      child: Text(section),
    );
  }

  Widget _buildGoalWidget({
    required String title,
    required int completed,
    required int total,
    required String motivationText,
    required int streak,
    required IconData icon,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Icon(icon, size: 50), // Medal icon
        SizedBox(height: 10),
        Text(
          '$completed / $total Completed',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
        Text(
          motivationText,
          style: TextStyle(fontSize: 14),
        ),
        Divider(),
        Text(
          'Streak: $streak',
          style: TextStyle(fontSize: 16),
        ),
        TextButton(
          onPressed: () {
            // Navigate to the edit goals page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SetGoalsPage(),
              ),
            );
          },
          child: Text('Edit Goals'),
        ),
      ],
    );
  }

  Widget _buildKarmaWidget({required int points, required String rank}) {
    return Column(
      children: [
        Text(
          'Karma',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          'Points: $points',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
        Text(
          'Rank: $rank',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
