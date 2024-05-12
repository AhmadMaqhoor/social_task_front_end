import 'package:flutter/material.dart';
import 'package:isd_project/taskmanager/addcompanytask.dart';
import 'package:isd_project/taskmanager/navigationbar.dart';

class CompanyPage extends StatefulWidget {
  const CompanyPage({super.key});

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  String _selectedSection = 'Tasks';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Company'),
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: Icon(Icons.hide_source),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSectionButton('Tasks'),
                _buildSectionButton('Inbox'),
                _buildSectionButton('Members'),
              ],
            ),
            SizedBox(height: 20),
            if (_selectedSection == 'Tasks')
              Expanded(
                child: ListView.builder(
                  itemCount: 10, // Replace with actual number of tasks
                  itemBuilder: (context, index) {
                    // Replace with task widget
                    return ListTile(
                      title: Text('Task ${index + 1}'),
                    );
                  },
                ),
              ),
            if (_selectedSection == 'Inbox') ...[
              // Replace with inbox widget
              Text('Inbox Page'),
            ],
            if (_selectedSection == 'Members') ...[
              // Replace with members widget
              Text('Members Page'),
            ],
            if (_selectedSection == 'Tasks') ...[
              SizedBox(height: 5),
              Divider(
                color: Colors.black,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddCompanyTaskPage();
                        },
                      );
                    },
                    icon: Icon(Icons.add),
                    color: Colors.black,
                    iconSize: 30,
                  ),
                  Text(
                    'Add Task',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
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
}
