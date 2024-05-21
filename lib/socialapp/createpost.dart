import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreatePostDialog extends StatefulWidget {
  @override
  _CreatePostDialogState createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog> {
  List<Map<String, dynamic>> _organizations = [];
  List<String> _selectedAudience = [];
  String _description = '';
  Uint8List? _imageBytes;
  String? _imageName;
  bool _showCompanies = false;

  @override
  void initState() {
    super.initState();
    _fetchOrganizations();
  }

  Future<void> _fetchOrganizations() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/taskapp/get-organizations'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      setState(() {
        _organizations = List<Map<String, dynamic>>.from(data['organizations']);
      });
    } else {
      // Handle error response
      print('Failed to load organizations: ${response.statusCode}');
    }
  }

  Future<void> _createPost() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    if (_imageBytes == null) {
      // Show an error message if the image is not selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    // Prepare the multipart request
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1:8000/api/socialapp/create-post'),
    );

    request.headers.addAll(<String, String>{
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'multipart/form-data',
    });

    // Attach the image file
    request.files.add(http.MultipartFile.fromBytes(
      'image_path',
      _imageBytes!,
      filename: _imageName,
    ));

    // Add other form fields
    request.fields['caption'] = _description;
    request.fields['audience'] = _showCompanies ? "1" : "0";

    // Add organization_ids as separate fields with indexed keys
    if (_showCompanies) {
      for (int i = 0; i < _selectedAudience.length; i++) {
        request.fields['organization_ids[$i]'] = _selectedAudience[i];
      }
    }

    // Debugging: Print the request details
    print('Request Headers: ${request.headers}');
    print('Request Fields: ${request.fields}');
    print('Request Files: ${request.files}');

    // Send the request
    final response = await request.send();

    if (response.statusCode == 201) {
      // Handle success response
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post created successfully')),
      );
      Navigator.pop(context);
    } else {
      // Handle error response
      final responseBody = await response.stream.bytesToString();
      print('Failed to create post: ${response.statusCode}');
      print('Response Body: $responseBody');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create post: $responseBody')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Post',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                _showImagePicker(context);
              },
              child: Container(
                width: 150,
                height: 150.0,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                  image: _imageBytes != null
                      ? DecorationImage(
                          image: MemoryImage(_imageBytes!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child:
                    _imageBytes == null ? Icon(Icons.upload, size: 30.0) : null,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Description',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            TextField(
              decoration: InputDecoration(
                hintText: 'Write a description...',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              onChanged: (value) {
                setState(() {
                  _description = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Checkbox(
                  value: _showCompanies,
                  onChanged: (bool? value) {
                    setState(() {
                      _showCompanies = value ?? false;
                      if (!_showCompanies) {
                        _selectedAudience.clear();
                      }
                    });
                  },
                ),
                Text(
                  'Audience',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            if (_showCompanies) ...[
              Column(
                children: _buildCompanyOptions(),
              ),
              SizedBox(height: 16.0),
            ],
            ElevatedButton(
              onPressed: _createPost,
              child: Text('Post'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showImagePicker(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _imageBytes = result.files.single.bytes;
          _imageName = result.files.single.name;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  List<Widget> _buildCompanyOptions() {
    return _organizations.map((org) {
      return CheckboxListTile(
        title: Text(org['title']),
        value: _selectedAudience.contains(org['id'].toString()),
        onChanged: (bool? value) {
          setState(() {
            if (value ?? false) {
              _selectedAudience.add(org['id'].toString());
            } else {
              _selectedAudience.remove(org['id'].toString());
            }
          });
        },
      );
    }).toList();
  }
}
