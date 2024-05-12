import 'package:flutter/material.dart';
import 'package:isd_project/socialapp/navigationbarsocial.dart';

class SocialProfilePage extends StatefulWidget {
  const SocialProfilePage({super.key});

  @override
  State<SocialProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<SocialProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  String _username = 'Username';
  String _bio = 'Bio of the user goes here.';
  AssetImage _profileImage = AssetImage('assets/profile_image.jpg');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: Icon(Icons.hide_source)),
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editProfile,
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Implement logout functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileInfo(),
            Divider(),
            _buildPosts(),
          ],
        ),
      ),
      drawer: NavSideBar(),
    );
  }

  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 40.0,
            backgroundImage: _profileImage,
          ),
          SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _username,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                _bio,
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPosts() {
    // Replace this with your posts widget
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Posts',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          // Your posts widgets go here
          Placeholder(),
        ],
      ),
    );
  }

  void _editProfile() {
    TextEditingController usernameController =
        TextEditingController(text: _username);
    TextEditingController bioController = TextEditingController(text: _bio);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Text('Edit Profile'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: bioController,
                    decoration: InputDecoration(labelText: 'Bio'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Cancel editing
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Accept changes
                      _username = usernameController.text;
                      _bio = bioController.text;
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
