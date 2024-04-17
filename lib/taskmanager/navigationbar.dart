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
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: Container(
                    width: 100,
                    child: const Row(
                      children: [
                        Icon(Icons.account_circle),
                        SizedBox(width: 8),
                        Text('Profile'),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  child: Container(
                    width: 40,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.settings),
                        SizedBox(width: 8),
                      ],
                    ),
                  ),
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
            leading: const Icon(Icons.inbox),
            title: const Text('Inbox'),
            onTap: () {
              Navigator.pushNamed(context, '/inbox');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline_rounded),
            title: const Text('addtask'),
            onTap: () {
              Navigator.pushNamed(context, '/addtask');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('productivity'),
            onTap: () {
              Navigator.pushNamed(context, '/productivity');
            },
          ),
          ListTile(
            leading: const Icon(Icons.today),
            title: const Text('today'),
            onTap: () {
              Navigator.pushNamed(context, '/today');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_outlined),
            title: const Text('upcoming'),
            onTap: () {
              Navigator.pushNamed(context, '/upcoming');
            },
          ),
          ListTile(
            leading: const Icon(Icons.turned_in),
            title: const Text('completed'),
            onTap: () {
              Navigator.pushNamed(context, '/completed');
            },
          ),
          ListTile(
            leading: const Icon(Icons.join_full_rounded),
            title: const Text('company'),
            onTap: () {
              Navigator.pushNamed(context, '/company');
            },
          ),
        ],
      ),
    );
  }
}
