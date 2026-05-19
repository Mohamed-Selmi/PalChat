import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:pfeapp/Mainpage/profile.dart';
import 'package:pfeapp/Mainpage/groups.dart';
import 'package:pfeapp/Mainpage/friendlist.dart';
import 'package:pfeapp/Messaging/friendrequests.dart';

class MyConvexAppBar extends StatelessWidget {
  final int currentPage;
  final void Function(int) onTap;
  final Color backgroundColor;

  const MyConvexAppBar({
    Key? key,
    required this.currentPage,
    required this.onTap,
    this.backgroundColor = const Color(0xff15b097),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      items: const [
        TabItem(icon: Icons.message, title: 'Chat'),
        TabItem(icon: Icons.people, title: 'Friends'),
        TabItem(icon: Icons.group_add, title: 'Requests'),
        TabItem(icon: Icons.person, title: 'Profile'),
      ],
      backgroundColor: backgroundColor, 
      onTap: (int i) {
       if (i == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserConversations()),
          );
        }
        else if (i == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AllUsersScreen()),
          );
        } else if (i == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FriendRequests()),
          );
        } else if (i == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileWidget()),
          );
        } else {
          onTap(i);
        }
      },
      initialActiveIndex: currentPage,
    );
  }
}
