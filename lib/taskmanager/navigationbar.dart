import "package:flutter/material.dart";
import "package:isd_project/taskmanager/addcompanytask.dart";
import "package:isd_project/taskmanager/addtaskdialog.dart";
import "package:isd_project/taskmanager/createcompany.dart";

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
                Icon(Icons.account_circle),
                SizedBox(width: 8),
                Text('Profile'),
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
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddTaskDialog();
                },
              );
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
            onTap: () {
              Navigator.pushNamed(context, '/company');
            },
            title: Row(
              children: [
                Text('Company'),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CreateCompany();
                      },
                    );
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 180,
          ),
          ListTile(
            leading: const Icon(Icons.open_in_browser_rounded),
            title: const Text('Social App'),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
        ],
      ),
    );
  }
}
