// ignore_for_file: unused_import

import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
Future<void> LoginUser(String email, String password) async {
  // Define the endpoint URL
  final String apiUrl = 'http://192.168.1.3:8000/accounts/login';

  // Prepare the request body
  final Map<String, dynamic> data = {
    'email': email,
    'password': password,
  };

  // Encode the request body to JSON
  final String encodedData = jsonEncode(data);

  try {
    // Make the POST request
    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: encodedData,
    );

    // Check the response status
    if (response.statusCode == 200) {
      // Request was successful
      print('Sign-in successful!');
      // You can perform any other actions here, such as navigating to a new screen
    } else {
      // Request failed
      print('Failed to sign-in. Error: ${response.statusCode}');
      // You can handle errors here, such as displaying an error message to the user
    }
  } catch (error) {
    // Handle any exceptions that occur during the API call
    print('Error while signing in: $error');
    // You can display an error message to the user or perform other error handling actions
  }
}
class LoginView extends StatefulWidget{
  const LoginView({super.key});

  @override
  State<LoginView> createState() => LoginCard();
}
class LoginCard extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {

   return Scaffold(
          body:Container(
            margin: const EdgeInsets.only(top: 40.0),
            color:Color.fromARGB(0, 255, 255, 255),
            child: Column(children: [
              Container(
                
                child:Text('Welcome To Pal Chat',
                textAlign: TextAlign.center,
                style:TextStyle(
                  fontFamily: 'Aleo',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      color: Colors.black
                )),
                  
              ),
                Container(
                  child:SizedBox(
                      width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child:Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    
                      child: SvgPicture.asset(
                       'assets/images/logo2.svg',
                        fit: BoxFit.cover,),
                    
                  ),
                  ),
                ),
                Container(
                  child:Column(children: [
                     SizedBox(height: 40, width:300,
                      child:TextField(
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      style: const TextStyle(color: Colors.white,),
                      decoration: InputDecoration(
                        hintText: 'Enter your Email Adress',
                        prefixIcon: Icon(Icons.email,
                        color: Colors.black,),
                        filled: true,
                        fillColor: const Color(0xFF616161),
                        border:  OutlineInputBorder(
                         
                        ),
                      ),
                    ),
                    ),
                     SizedBox(height: 20),
                       SizedBox(height: 40,width:300,
                      child:TextField(
                       obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: passwordController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        prefixIcon: Icon(Icons.key,
                        color: Colors.black,),
                        filled: true,
                        fillColor: Color(0xFF616161),
                       
                      ),
                    ),
                    ),
                    SizedBox(height:20),
                    SizedBox(
                      height:30,
                      width:200,
                     child:ElevatedButton(
                      style:ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                        shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,)
                            ),
                      ),
                      onPressed: () {
                  LoginUser(
                    emailController.text,
                    passwordController.text,
                  );
                },
                child:Text("Login",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Color(0xFFFFF000),
                ),
                ),
  ),
                    ),
                    ],
                    ),
                ),

            ],
            ),
          ),
          
   );
   
  }
  
}
