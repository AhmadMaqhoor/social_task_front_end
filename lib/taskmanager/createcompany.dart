import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreateCompany extends StatefulWidget {
  const CreateCompany({super.key});

  @override
  State<CreateCompany> createState() => _CreateCompanyState();
}

class _CreateCompanyState extends State<CreateCompany> {
  String _title = '';
  String _description = '';

  Uint8List? _imageBytes;
  String? _imageName;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _createOrganization() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    if (_imageBytes == null) {
      // Show an error message if the image is not selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    // Prepare the multipart request
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.0.105:8000/api/taskapp/add-organization'),
    );

    request.headers.addAll(<String, String>{
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'multipart/form-data',
    });

    // Attach the image file
    request.files.add(http.MultipartFile.fromBytes(
      'image',
      _imageBytes!,
      filename: _imageName,
    ));

    // Add other form fields
    request.fields['title'] = _title;
    request.fields['description'] = _description;

    // Debugging: Print the request details
    print('Request Headers: ${request.headers}');
    print('Request Fields: ${request.fields}');
    print('Request Files: ${request.files}');

    // Send the request
    final response = await request.send();

    if (response.statusCode == 200) {
      // Handle success response
      Navigator.of(context).pop(); // Close the dialog and show message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Company created successfully')),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create Company',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
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
            const SizedBox(height: 8.0),
            const Text(
              'Title',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Write a title...',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              onChanged: (value) {
                setState(() {
                  _title = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Description',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            TextField(
              decoration: const InputDecoration(
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
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _createOrganization,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5, // Adds a shadow for a 3D effect
              ),
              child: const Text('Create'),
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
}