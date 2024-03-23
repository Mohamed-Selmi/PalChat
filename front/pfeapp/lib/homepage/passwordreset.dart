// ignore_for_file: unused_import

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:pfeapp/homepage/loginview.dart';
import 'package:pfeapp/homepage/passwordreset.dart';
import 'package:pfeapp/homepage/resetform.dart';
Future<void> ResetPassword(BuildContext context,String email) async{
  const String apiUrl = 'http://192.168.1.3:8000/accounts/password-reset';

  // Prepare the request body
  final Map<String, dynamic> data = {
    'email': email,
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
      print('Password reset email sent successfully');
     Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ResetForm()),
      );
    } else {
      // Request failed
      print('Failed to send reset email. Error: ${response.statusCode}');
      // You can handle errors here, such as displaying an error message to the user
    }
  } catch (error) {
    // Handle any exceptions that occur during the API call
    print('Error : $error');
    // You can display an error message to the user or perform other error handling actions
  }
}
class PasswordReset extends StatefulWidget{
  const PasswordReset({super.key});

  @override
  State<PasswordReset> createState() => PasswordCard();
}
class PasswordCard extends State<PasswordReset> {
TextEditingController emailController = TextEditingController();
@override
  Widget build(BuildContext context) {
    return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          
          body:Container(
            margin: const EdgeInsets.only(top: 40.0),
            color:const Color.fromARGB(0, 255, 255, 255),
            child: Column(children: [
              const SizedBox(height:10,),
              Container(
                child:const Text('Welcome To PalChat',
                textAlign: TextAlign.center,
                style:TextStyle(
                  fontFamily: 'Aleo',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      color: Colors.black
                )
                ), 
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
              const SizedBox(height:40),
             Container(
                child:Row(mainAxisAlignment: MainAxisAlignment.center, 
                  children: [
              const Icon(
                    Icons.lock,
                    color: Colors.blue,
                    size: 100.0,
                  ),
                  Container(child:const Column(children:[
                      Text('Forgot',
                textAlign: TextAlign.left,
                style:TextStyle(
                  fontFamily: 'Aleo',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      color: Colors.black
                )),
                Text('Password?',
                textAlign: TextAlign.center,
                style:TextStyle(
                  fontFamily: 'Aleo',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      color: Colors.blue
                )),
                  ]))
                  ]
                ),
             ),
             const SizedBox(height:20,),
              SizedBox(height: 40, width:300,
                      child:TextField(
                      
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0),),
                      decoration: const InputDecoration(
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
                    
                    const SizedBox(height:20),
                    SizedBox(
                      height:30,
                      width:200,
                     child:ElevatedButton(
                      style:ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 68, 68, 68)),
                        shape: MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,)
                            ),
                      ),
                      onPressed: () {
                  ResetPassword(
                    context,
                    emailController.text,
                  );
                },
                child:const Text("Reset Password ",
                textAlign: TextAlign.center,
                style: TextStyle(
                   fontFamily: 'Montserrat', 
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
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