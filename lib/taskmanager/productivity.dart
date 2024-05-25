import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:isd_project/taskmanager/navigationbar.dart';
import 'package:isd_project/taskmanager/setgoals.dart';
import 'package:isd_project/taskmanager/setgoalperweek.dart';

class ProductivityPage extends StatefulWidget {
  const ProductivityPage({super.key});

  @override
  State<ProductivityPage> createState() => _ProductivityPageState();
}

class _ProductivityPageState extends State<ProductivityPage> {
  String _selectedSection = 'Daily'; // Default selected section
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  int minTasksPerDay = 0;
  int maxTasksPerDay = 0;
  int minTasksPerWeek = 0;
  int maxTasksPerWeek = 0;
  int score = 0;
  String rank = '';
  String productivityId = ''; // Add productivity ID

  @override
  void initState() {
    super.initState();
    fetchProductivity();
  }

  Future<void> fetchProductivity() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.get(
      Uri.parse('http://192.168.0.105:8000/api/taskapp/show-prodactivity'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        minTasksPerDay = data['prodactivity']['min_tasks_per_day'];
        maxTasksPerDay = data['prodactivity']['max_tasks_per_day'];
        minTasksPerWeek = data['prodactivity']['min_tasks_per_week'];
        maxTasksPerWeek = data['prodactivity']['max_tasks_per_week'];
        score = data['score'];
        rank = data['rank'];
        productivityId =
            data['prodactivity']['id'].toString(); // Convert ID to string
      });
    } else {
      print('Failed to load tasks');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Productivity'),
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.hide_source),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 10.0, // Space between buttons
              children: [
                _buildSectionButton('Daily'),
                _buildSectionButton('Weekly'),
                _buildSectionButton('Karma'),
              ],
            ),
            const SizedBox(height: 20),
            if (_selectedSection == 'Daily')
              _buildGoalWidget(
                title: 'Daily',
                completed: minTasksPerDay,
                total: maxTasksPerDay,
                motivationText: 'Keep up the good work!',
                streak: 2,
                icon: Icons.emoji_events, // Medal icon
                isDaily: true, // Pass the flag to identify daily goals
              ),
            if (_selectedSection == 'Weekly')
              _buildGoalWidget(
                title: 'Weekly',
                completed: minTasksPerWeek,
                total: maxTasksPerWeek,
                motivationText: 'You can do it!',
                streak: 1,
                icon: Icons.emoji_events, // Medal icon
                isDaily: false, // Pass the flag to identify weekly goals
              ),
            if (_selectedSection == 'Karma')
              _buildKarmaWidget(
                points: score,
                rank: rank,
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
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        textStyle: const TextStyle(fontSize: 16,),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5, // Adds a shadow for a 3D effect
      ),
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
    required bool isDaily, // Add a flag to identify if it's daily or weekly
  }) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Icon(icon, size: 50), // Medal icon
        const SizedBox(height: 10),
        Text(
          '$completed / $total Completed',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Text(
          motivationText,
          style: const TextStyle(fontSize: 14),
        ),
        const Divider(),
        Text(
          'Streak: $streak',
          style: const TextStyle(fontSize: 16),
        ),
        TextButton(
          onPressed: () {
            // Navigate to the appropriate goal setting page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => isDaily
                    ? SetGoalsPagePerDay(
                        productivityId: productivityId,
                        fetchProductivity: fetchProductivity)
                    : SetGoalsPagePerWeek(
                        productivityId: productivityId,
                        fetchProductivity: fetchProductivity),
              ),
            );
          },
          child: const Text('Edit Goals',
              style: TextStyle(
                color: Colors.blue,
              )),
        ),
      ],
    );
  }

  Widget _buildKarmaWidget({required int points, required String rank}) {
    return Column(
      children: [
        const Text(
          'Karma',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          'Points: $points',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Text(
          'Rank: $rank',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}