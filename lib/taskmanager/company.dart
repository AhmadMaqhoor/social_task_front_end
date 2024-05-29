import 'package:flutter/material.dart';
import 'package:isd_project/taskmanager/addtaskdiaglogasadmin.dart';
import 'package:isd_project/taskmanager/adminlistingpendingtasklist.dart';
import 'package:isd_project/taskmanager/adminlistingcompletedtask.dart';
import 'package:isd_project/taskmanager/navigationbar.dart';
import 'package:isd_project/taskmanager/memberlist.dart'; // Import MemberList
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CompanyPage extends StatefulWidget {
  final String companyName;
  final int companyId;
  const CompanyPage(
      {super.key, required this.companyName, required this.companyId});

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

final GlobalKey<AdminListingPendingTaskScreenState> _tasksScreenKey = GlobalKey();

void _refetchTasks() {
  _tasksScreenKey.currentState?.refetchTasks();
}

Widget _buildPendingTaskList(int companyId) {
  return AdminListingPendingTaskScreen(companyId: companyId, key: _tasksScreenKey);
}

Widget _buildCompletedTaskList(int companyId) {
  return AdminListingCompletedTaskScreen(companyId: companyId);
}

class _CompanyPageState extends State<CompanyPage> {
  String _selectedSection = 'Assigned';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.companyName),
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
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: [
                _buildSectionButton('Assigned'),
                _buildSectionButton('Submitted'),
                _buildSectionButton('Members'),
              ],
            ),
            SizedBox(height: 20),
            if (_selectedSection == 'Assigned')
              Expanded(
                child: _buildPendingTaskList(widget.companyId),
              ),
            if (_selectedSection == 'Submitted')
              Expanded(
                child: _buildCompletedTaskList(widget.companyId),
              ),
            if (_selectedSection == 'Members') ...[
              // Use MemberList widget and pass companyId
              Expanded(
                child: MemberList(companyId: widget.companyId),
              ),
              SizedBox(height: 20),
              Divider(
                color: Colors.black,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      _showInviteMembersDialog(context);
                    },
                    icon: Icon(Icons.add, color: Colors.blue),
                  ),
                  Text('Invite Members'),
                ],
              ),
            ],
            if (_selectedSection == 'Assigned') ...[
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
                          return AddTaskDialogAsAdmin(
                              companyId: widget.companyId, onTaskCreated: _refetchTasks);
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
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.blue,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        textStyle: TextStyle(fontSize: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5, // Adds a shadow for a 3D effect
      ),
      child: Text(section),
    );
  }

  void _showInviteMembersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InviteMembersDialog(companyId: widget.companyId);
      },
    );
  }
}

class InviteMembersDialog extends StatefulWidget {
  final int companyId;

  const InviteMembersDialog({Key? key, required this.companyId}) : super(key: key);

  @override
  _InviteMembersDialogState createState() => _InviteMembersDialogState();
}

class _InviteMembersDialogState extends State<InviteMembersDialog> {
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  Future<void> createInvite() async {
    final String email = _emailController.text.trim();
    final String message = _messageController.text.trim();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/taskapp/organizations/${widget.companyId}/send-invitation'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(<String, String>{'recipient_email': email, 'message': message}),
    );

    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invitation sent successfully'),
        ),
      );
    } else {
      // Display error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to invite member'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
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
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Invite Member'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(hintText: "Enter member's email"),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(hintText: "Enter message"),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Invite'),
          onPressed: createInvite,
        ),
      ],
    );
  }
}
