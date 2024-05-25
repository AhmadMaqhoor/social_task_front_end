import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class InvitesList extends StatefulWidget {
  const InvitesList({super.key});

  @override
  State<InvitesList> createState() => _InvitesListState();
}

class _InvitesListState extends State<InvitesList> {
  List<dynamic> invites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchInvitations();
  }

  Future<void> fetchInvitations() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.get(
      Uri.parse('http://192.168.0.105:8000/api/taskapp/recieve-invitation-by-organization'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        invites = data['invitations'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load invitations');
    }
  }

  Future<void> respondToInvitation(int invitationId, String userResponse) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.post(
      Uri.parse('http://192.168.0.105:8000/api/taskapp/invitation/$invitationId/respond'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({'response': userResponse}),
    );

    if (response.statusCode == 200) {
      // Refresh the invitations list after responding
      fetchInvitations();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(json.decode(response.body)['message']),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(json.decode(response.body)['error']),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: invites.length,
      itemBuilder: (context, index) {
        final invite = invites[index];
        return Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(invite['organization_image']),
              radius: 20,
            ),
            title: Text(invite['organization_title']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(invite['message']),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.check, color: Colors.green),
                  onPressed: () {
                    respondToInvitation(invite['id'], 'accept');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    respondToInvitation(invite['id'], 'decline');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
