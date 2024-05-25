import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

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
  Uint8List? _imageBytes;
  String? _imageName;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.get(
      Uri.parse('http://192.168.0.105:8000/api/taskapp/profile?_method=GET'),
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

  Future<void> _updateUserProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.0.105:8000/api/taskapp/update-profile?_method=PUT'),
    );
    request.headers['Authorization'] = 'Bearer $accessToken';

    if (_username != null) {
      request.fields['name'] = _username!;
    }
    if (_email != null) {
      request.fields['email'] = _email!;
    }
    if (_imageBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        _imageBytes!,
        filename: _imageName,
      ));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      print('User profile updated successfully');
      fetchUserData();  // Refresh user data
    } else {
      print('Failed to update user profile');
    }
  }

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _imageBytes = result.files.single.bytes;
          _imageName = result.files.single.name;
          _imageUrl = null;  // Clear the URL to show the new image
        });
      }
    } catch (e) {
      print('Error picking image: $e');
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
                _updateUserProfile();  // Update user profile on server
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
    String newEmail = _email ?? '';

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
                _updateUserProfile();  // Update user profile on server
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
            GestureDetector(
              onTap: _pickImage,
              child: _imageBytes != null
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: MemoryImage(_imageBytes!),
                    )
                  : _imageUrl != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(_imageUrl!),
                        )
                      : Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey,
                          child: Icon(Icons.image, color: Colors.white),
                        ),
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
                    _changeEmail(context);
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateUserProfile,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
