import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:isd_project/taskmanager/company.dart';
import "package:isd_project/taskmanager/addtaskdialog.dart";
import "package:isd_project/taskmanager/createcompany.dart";

class NavSideBar extends StatefulWidget {
  const NavSideBar({Key? key}) : super(key: key);

  @override
  State<NavSideBar> createState() => _NavSideBarState();
}

class _NavSideBarState extends State<NavSideBar> {
  bool _isExpanded = false;
  List<String> organizationNames = []; // Initialize with empty list
  List<int> organizationIds = []; // Initialize with empty list

  @override
  void initState() {
    super.initState();
    // Fetch organizations when the sidebar is initialized
    fetchOrganizations();
  }

  Future<void> fetchOrganizations() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/taskapp/get-organizations'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['organizations'];
      setState(() {
        organizationNames.clear(); // Clear previous list
        organizationIds.clear(); // Clear previous list
        for (final organization in data) {
          organizationNames.add(organization['title']);
          organizationIds.add(organization['id']);
        }
      });
    } else {
      throw Exception('Failed to load organizations');
    }
  }

  Widget _buildCompanyList(BuildContext context) {
    if (organizationNames.isEmpty) {
      return CircularProgressIndicator(); // Show loading indicator while fetching
    } else {
      return Column(
        children: List.generate(organizationNames.length, (index) {
          return ListTile(
            title: Text(organizationNames[index]),
            onTap: () {
              // Pass both the company name and ID when navigating to CompanyPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompanyPage(
                    companyName: organizationNames[index],
                    companyId: organizationIds[index],
                  ),
                ),
              );
            },
          );
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[100],
      child: ListView(
        children: [
          ListTile(
            title: Row(
              children: [
                Icon(Icons.account_circle),
                SizedBox(width: 8),
                Text('Profile'),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  child: Container(
                    width: 40,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.settings),
                        SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.hide_source),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.inbox),
            title: const Text('Inbox'),
            onTap: () {
              Navigator.pushNamed(context, '/inbox');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline_rounded),
            title: const Text('addtask'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddTaskDialog(onTaskCreated: () {  },);
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('productivity'),
            onTap: () {
              Navigator.pushNamed(context, '/productivity');
            },
          ),
          ListTile(
            leading: const Icon(Icons.today),
            title: const Text('today'),
            onTap: () {
              Navigator.pushNamed(context, '/today');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_outlined),
            title: const Text('upcoming'),
            onTap: () {
              Navigator.pushNamed(context, '/upcoming');
            },
          ),
          ListTile(
            leading: const Icon(Icons.turned_in),
            title: const Text('completed'),
            onTap: () {
              Navigator.pushNamed(context, '/completed');
            },
          ),
          ListTile(
            leading: const Icon(Icons.join_full_rounded),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            title: Row(
              children: [
                Text('Company'),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  icon:
                      Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CreateCompany();
                      },
                    );
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ),
          if (_isExpanded)
            _buildCompanyList(context), // Show company list if expanded
          const SizedBox(
            height: 180,
          ),
          ListTile(
            leading: const Icon(Icons.open_in_browser_rounded),
            title: const Text('Social App'),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
        ],
      ),
    );
  }
}
