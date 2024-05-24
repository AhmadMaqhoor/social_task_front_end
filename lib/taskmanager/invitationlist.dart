import 'package:flutter/material.dart';

class InvitesList extends StatefulWidget {
  const InvitesList({super.key});

  @override
  State<InvitesList> createState() => _InvitesListState();
}

class _InvitesListState extends State<InvitesList> {
  List<Map<String, String>> invites = [
    {'title': 'Invitation 1'},
    {'title': 'Invitation 2'},
    {'title': 'Invitation 3'},
  ]; // u know i like dummy data for testing

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: invites.length,
      itemBuilder: (context, index) {
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
            title: Text(invites[index]['title']!),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.check, color: Colors.green),
                  onPressed: () {
                    // function for  accept invitation here u do it cizo
                  },
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    // same here for refuse
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
