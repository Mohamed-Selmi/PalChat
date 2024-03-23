// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfeapp/Mainpage/chatroom.dart';
import 'package:pfeapp/Mainpage/friendlist.dart';
import 'dart:convert';
import 'package:pfeapp/homepage/loginview.dart';
import 'package:pfeapp/homepage/registerview.dart';
import 'package:pfeapp/homepage/resetform.dart';
import "package:pfeapp/Mainpage/homeview.dart";

import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo',
       debugShowCheckedModeBanner: false,
      theme: ThemeData(
      
        primarySwatch: Colors.blue,
      ),
      home:  const LoginView(),
    ),
    );
}

