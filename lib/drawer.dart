import 'package:flutter/material.dart';
import 'package:incog/user.dart';
import 'profile_screen.dart';

class AppDrawer extends StatelessWidget {
  final String username;
  final Function(User) onProfileUpdated;

  const AppDrawer({
    Key? key,
    required this.username,
    required this.onProfileUpdated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text('Menu'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    
                  ),
                ),
              );
            },
          ),
          // Add more drawer items as needed
        ],
      ),
    );
  }
}
