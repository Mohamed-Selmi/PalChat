// ignore_for_file: unused_import


import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:pfeapp/homepage/registerview.dart';
import 'package:pfeapp/homepage/passwordreset.dart';
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
          resizeToAvoidBottomInset: false,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          
          body:Container(
            margin: const EdgeInsets.only(top: 40.0),
            color:Color.fromARGB(0, 255, 255, 255),
            child: Column(children: [
              SizedBox(height:10,),
              Container(
                child:Text('Welcome To PalChat',
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
                      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0),),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 1.0),
                        hintText: 'Enter your Email Address',
                        prefixIcon: Icon(Icons.email,
                        color: Colors.black,),
                        filled: true,
                        fillColor: Color.fromARGB(255, 255, 255, 255),
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
                      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 1.0),
                        hintText: 'Enter your password',
                        prefixIcon: Icon(Icons.key,
                        color: Colors.black,),
                        filled: true,
                        fillColor: Color.fromARGB(255, 255, 255, 255),
                        border:  OutlineInputBorder(
                         
                        ),
                      ),
                    ),
                    ),
                    SizedBox(height:20),
                    SizedBox(
                      height:30,
                      width:200,
                     child:ElevatedButton(
                      style:ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 68, 68, 68)),
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
                textAlign: TextAlign.center,
                style: TextStyle(
                   fontFamily: 'Montserrat', 
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                ),
  ),
                    ),
                    SizedBox(height:10),
                    Container(height:40,
                    width:150,
                    child:Center(
                      child: RichText(text:
                            TextSpan(
                                text: 'Forgot Password ?',
                                  style: TextStyle(
                                   decoration: TextDecoration.underline,
                                  color: Color.fromARGB(255, 13, 138, 255),
                                                    fontFamily: 'Roboto', 
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                        ),
                                        recognizer: TapGestureRecognizer()
                      ..onTap = () {
                         Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => PasswordReset()),
                      );
                      }),
                      ),
                    ),
                    ),
                    
                    ],
                    ),
                ),
                SizedBox(height:20),
              Container(
                child:Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                  children: [
                  Container(
                    width: 123,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Or sign-in with!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.normal,
                      height: 0,
                    ),
                  ),
                  Container(
                    width: 123,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                        ),
                      ),
                    ),
                  ),
        
                ],
                ),
              ),
              SizedBox(height:20,),
              Container(
                child:Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                  
                  IconButton(
                      iconSize: 50,
                      icon: const FaIcon(FontAwesomeIcons.google,
                      color:Color.fromARGB(255, 0, 0, 0)),
                      onPressed: () {
                            print("google icon pressed");
                      },
                    ),
                    
                     IconButton(
                      iconSize: 50,
                      icon: const FaIcon(FontAwesomeIcons.facebook,
                      color:Color.fromARGB(255, 0, 0, 0)),
                      onPressed: () {
                            print("whatsapp icon pressed");
                                },
                              ),

                ],),
              ),
              SizedBox(height:30,),
              FractionallySizedBox(
                  widthFactor: 1.0, // Set width to 100% of the screen
                  child: Container(
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height:35),
                Container(
                  
                  width:250,
                  child:Center(
                    child: RichText(
                      text:TextSpan(
                        text: "Don't have an account? ",
                      style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                                    fontFamily: 'Roboto', 
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,),
                      children: <TextSpan>[
                        TextSpan(
                                text: 'Sign up!',
                                  style: TextStyle(
                                   decoration: TextDecoration.underline,
                                  color: Color.fromARGB(255, 13, 138, 255),
                                                    fontFamily: 'Roboto', 
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                        ),
                                        recognizer: TapGestureRecognizer()
                      ..onTap = () {
                         Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Registerview()),
                      );
                      }),
                      ],
                      ),
                    ),
                  ),
                ),
            ],
            ),
          ),
          
   );
   
  }
  
}
