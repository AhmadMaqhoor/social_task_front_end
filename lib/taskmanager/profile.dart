import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _username;
  String? _email;
  String? _imageUrl;
  int? _score;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/taskapp/profile?_method=GET'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = json.decode(response.body);
      setState(() {
        _username = userData['user_profile']['name'];
        _email = userData['user_profile']['email'];
        _imageUrl = userData['user_profile']['image'];
        _score = userData['user_profile']['score'];
      });
    } else {
      print('Failed to load user data');
    }
  }

  // Function for changing the username
  void _changeUsername(BuildContext context) {
    String newUsername = _username ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Username'),
          content: TextField(
            onChanged: (value) {
              newUsername = value;
            },
            decoration: InputDecoration(hintText: 'Enter new username'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _username = newUsername;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Function for changing the email
  void _changeEmail(BuildContext context) {
    String newEmail = _email ?? ''; // Initialize with current email

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Email'),
          content: TextField(
            onChanged: (value) {
              newEmail = value;
            },
            decoration: InputDecoration(hintText: 'Enter new email'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _email = newEmail;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Your Rank: ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              '$_score',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _imageUrl != null
                    ? CircleAvatar(
                        radius: 50,
                        child: ClipOval(
                          child: Image(
                            image: NetworkImage(_imageUrl!),
                            fit: BoxFit
                                .cover, // Adjust according to your preference
                          ),
                        ),
                      )
                    : Container(
                        // Placeholder widget if image URL is null or invalid
                        width: 100,
                        height: 100,
                        color: Colors.grey, // Placeholder color
                        child: Icon(Icons.image,
                            color: Colors.white), // Placeholder icon or text
                      ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Username: ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '$_username',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Logic to change username
                    _changeUsername(context);
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'User Email:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '$_email',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Logic to change email
                    _changeEmail(context);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
