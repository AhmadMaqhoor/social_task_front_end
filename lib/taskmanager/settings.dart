import 'package:flutter/material.dart';
import 'package:isd_project/main.dart';
import 'package:isd_project/taskmanager/navigationbar.dart';
import 'package:isd_project/taskmanager/profile.dart';
import 'package:isd_project/taskmanager/theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  Widget _currentPage = ProfilePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Settings page'),
        leading: IconButton(
          icon: Icon(Icons.hide_source),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentPage = ProfilePage();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor:
                        _currentPage is ProfilePage ? Colors.blue : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Profile'),
                ),
                SizedBox(height: 8), // Reduced space between buttons
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentPage = ThemePage();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor:
                        _currentPage is ThemePage ? Colors.blue : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Theme'),
                ),
                SizedBox(height: 8), // Reduced space between buttons
                ElevatedButton(
                  onPressed: () {
                    // Perform logout action
                    // You can add your logout logic here
                    // For simplicity, let's just navigate back to the login page
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Logout'),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: _currentPage,
            ),
          ),
        ],
      ),
      drawer: const NavSideBar(),
    );
  }
}
