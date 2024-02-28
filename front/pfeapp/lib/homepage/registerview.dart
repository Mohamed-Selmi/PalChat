// ignore_for_file: unused_import

import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
/*Future<void> signUpUser(String username, String email, String password) async {
  // Define the endpoint URL
  final String apiUrl = 'http://192.168.1.3:8000/accounts/register';

  // Prepare the request body
  final Map<String, dynamic> data = {
    'username': username,
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
      print('Signup successful!');
      // You can perform any other actions here, such as navigating to a new screen
    } else {
      // Request failed
      print('Failed to signup. Error: ${response.statusCode}');
      // You can handle errors here, such as displaying an error message to the user
    }
  } catch (error) {
    // Handle any exceptions that occur during the API call
    print('Error while signing up: $error');
    // You can display an error message to the user or perform other error handling actions
  }
}*/
class Registerview extends StatefulWidget {
  const Registerview({super.key});
  @override
  RegisterCard createState() => RegisterCard();
}

class RegisterCard extends State<Registerview> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:Color.fromARGB(255, 221, 221, 223),
        appBar: null,
        body:Padding(
          padding: const EdgeInsets.all(20.0),
          child:Center(
            child:SingleChildScrollView(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  SizedBox(
                      width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child:Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    
                      child: SvgPicture.asset(
                       'assets/images/logo2.svg',
                        fit: BoxFit.cover,),
                    
                  ),
                  ),
                  const SizedBox(height: 10),
                const Text(
                  'Welcome To PalChat',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 25,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 40),
                      TextField(
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.text,
                      controller: usernameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter your username',
                        filled: true,
                        fillColor: const Color.fromARGB(255, 87, 86, 86).withOpacity(0.2),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                    ),
                      const SizedBox(height: 40),
                      TextField(
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        filled: true,
                        fillColor: const Color.fromARGB(255, 56, 56, 56).withOpacity(0.2),
                       
                      ),
                    ),
                   
                       const SizedBox(height: 20),
                      TextField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: passwordController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        
                      ),
                    ),  
                     SizedBox(
                            width: 182,
                            height: 20,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Don’t have an account? ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Sign up!',
                                    style: TextStyle(
                                      color: Color(0xFFFF630C),
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                          ),
                ],
              ),
            ),
          ),
        ),
          );
        
      
    
  }
}
