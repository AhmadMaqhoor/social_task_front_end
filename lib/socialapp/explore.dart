import 'package:flutter/material.dart';
import 'package:isd_project/socialapp/navigationbarsocial.dart';
import 'package:isd_project/socialapp/postcard.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExploreState();
}

class _ExploreState extends State<ExplorePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // body: Column(
      //   children: [
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       children: [
      //         IconButton(
      //           icon: const Icon(Icons.hide_source),
      //           onPressed: () {
      //             _scaffoldKey.currentState?.openDrawer();
      //           },
      //         ),
      //       ],
      //     ),
      //     Row(
      //       children: [
      //         Icon(Icons.explore),
      //         Text(
      //           'Explore',
      //           style: TextStyle(
      //             fontWeight: FontWeight.bold,
      //             fontSize: 30,
      //           ),
      //         )
      //       ],
      //     ),
      //     SizedBox(
      //       height: 10,
      //     ),
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Text('all posts can be viewed here'),
      //       ],
      //     ),
      //     SizedBox(
      //       height: 20,
      //     ),
      //     Row(
      //       children: [
      //         Icon(Icons.account_circle),
      //         Text('username1'),
      //       ],
      //     ),
      //     Row(
      //       children: [
      //         Text('image here'),
      //       ],
      //     ),
      //     Row(
      //       children: [
      //         Icon(Icons.heart_broken),
      //         Text('123'),
      //         Icon(Icons.comment),
      //         Text('21'),
      //       ],
      //     ),
      //     Row(
      //       children: [
      //         Text('Caption description here'),
      //       ],
      //     ),
      //     SizedBox(
      //       height: 30,
      //     ),
      //     Row(
      //       children: [
      //         Icon(Icons.account_circle),
      //         Text('username167'),
      //       ],
      //     ),
      //     SizedBox(
      //       height: 30,
      //     ),
      //     Row(
      //       children: [
      //         Icon(Icons.account_circle),
      //         Text('username367'),
      //       ],
      //     ),
      //   ],
      // ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: Icon(Icons.hide_source),
        ),
        title: Text('Explore'),
      ),
      drawer: const NavSideBar(),
      body: Builder(
        builder: (context) => PostCard(),
      ),
    );
  }
}
