// ignore_for_file: unused_import


import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pfeapp/Mainpage/chatroom.dart';
import 'package:pfeapp/Mainpage/friendlist.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:pfeapp/Mainpage/profile.dart';
import 'package:pfeapp/Mainpage/groups.dart';

import 'package:pfeapp/homepage/loginview.dart';
import 'package:pfeapp/homepage/registerview.dart';
import 'package:pfeapp/homepage/passwordreset.dart';

class HomeView extends StatefulWidget {


  const HomeView({
    super.key,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentPage=0;
 
late List<Widget> pages;

@override
void initState() {

  super.initState();
  pages = [
    HomeView(),
    const AllUsersScreen(),
    const ProfileWidget()
  
  ];
}
  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              
      bottomNavigationBar: ConvexAppBar(
    items: const [
      TabItem(icon: Icons.home, title: 'Home'),
      TabItem(icon: Icons.people, title: 'Friends'),
      TabItem(icon: Icons.message, title: 'Message'),
      TabItem(icon: Icons.person, title: 'Profile'),
    ],
      onTap: (int i) {
          if (i == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  AllUsersScreen()),
            );
          }
          else if (i == 2 ) {
             Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserConversations()), // Navigate to ConversationsWidget
    );
          }  
                    else if (i == 3 ) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileWidget()),
            );
          }  
          else {
            setState(() {
              currentPage = i;
            });}
      }
  )
    );
  }
}