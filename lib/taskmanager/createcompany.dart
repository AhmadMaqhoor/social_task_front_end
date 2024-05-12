import 'package:flutter/material.dart';

class CreateCompany extends StatefulWidget {
  const CreateCompany({super.key});

  @override
  State<CreateCompany> createState() => _CreateCompanyState();
}

class _CreateCompanyState extends State<CreateCompany> {

final TextEditingController _companyNameController = TextEditingController();
final TextEditingController _inviteEmailController = TextEditingController();


   void _createCompany() {
    // Get the entered values from the text fields
    final companyName = _companyNameController.text;
    final inviteEmail = _inviteEmailController.text;

    // Process the form data, e.g., create the company and invite members
    // Here, we simply print the entered values
    print('Company Name: $companyName');
    print('Invite Members by Email: $inviteEmail');

    // Clear the text fields after processing
    _companyNameController.clear();
    _inviteEmailController.clear();
  }

@override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _companyNameController.dispose();
    _inviteEmailController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
          title: Text('Create Company'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _companyNameController,
                decoration: InputDecoration(
                  labelText: 'Company Name',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _inviteEmailController,
                decoration: InputDecoration(
                  labelText: 'Invite Members by Email',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Process form data, e.g., create the company and invite members
                _createCompany();
                Navigator.pop(context);
              },
              child: Text('Create'),
            ),
          ],
        );
      }
  }


 

  