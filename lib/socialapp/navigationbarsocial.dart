import "package:flutter/material.dart";

class NavSideBar extends StatefulWidget {
  const NavSideBar({super.key});

  @override
  State<NavSideBar> createState() => _NavSideBarState();
}

class _NavSideBarState extends State<NavSideBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[100],
      child: ListView(
        children: [
          ListTile(
            title: Row(
              children: [
                Text(
                  'Social',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Search'),
            onTap: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
          ListTile(
            leading: const Icon(Icons.explore),
            title: const Text('Explore'),
            onTap: () {
              Navigator.pushNamed(context, '/explore');
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_rounded),
            title: const Text('Create Post'),
            onTap: () {
              Navigator.pushNamed(context, '/createpost');
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, '/socialprofile');
            },
          ),
          SizedBox(
            height: 230,
          ),
          ListTile(
            leading: const Icon(Icons.settings_applications),
            title: const Text('Task Manager'),
            onTap: () {
              Navigator.pushNamed(context, '/today');
            },
          ),
        ],
      ),
    );
  }
}
