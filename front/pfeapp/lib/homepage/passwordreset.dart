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

  final String encodedData = jsonEncode(data);

  try {
    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: encodedData,
    );

    if (response.statusCode == 200) {
      print('Password reset email sent successfully');
     Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ResetForm()),
      );
    } else {
      print('Failed to send reset email. Error: ${response.statusCode}');
    }
  } catch (error) {
    print('Error : $error');
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
          resizeToAvoidBottomInset: true,
          backgroundColor: const Color(0xfff2f2f2),
          
          body:SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 40.0),
              color:const Color.fromARGB(0, 255, 255, 255),
              child: Column(children: [
              SizedBox(height:MediaQuery.of(context).size.height * 0.02,),
            
                const Text('Welcome To PalChat',
                textAlign: TextAlign.center,
                style:TextStyle(
                  fontFamily: 'Aleo',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      color: Color(0xff011c27)
                )
                ),
               SizedBox(
                    height:MediaQuery.of(context).size.height * 0.45,
                      child: SvgPicture.asset(
                        'assets/images/applogo.svg',                      
                      ),
                    ), 
            
               const Row(mainAxisAlignment: MainAxisAlignment.center, 
                 children: [
                             Icon(
                   Icons.lock,
                   color: Color(0xff007cbe),
                   size: 100.0,
                 ),
                 Column(children:[
                     Text('Forgot',
                              textAlign: TextAlign.left,
                              style:TextStyle(
                 fontFamily: 'Aleo',
                     fontStyle: FontStyle.normal,
                     fontWeight: FontWeight.bold,
                     fontSize: 25.0,
                     color: Color(0xff011c27)
                              )),
                              Text('Password?',
                              textAlign: TextAlign.center,
                              style:TextStyle(
                 fontFamily: 'Aleo',
                     fontStyle: FontStyle.normal,
                     fontWeight: FontWeight.bold,
                     fontSize: 25.0,
                     color: Color(0xff007cbe)
                              )),
                 ])
                 ]
               ),
                  SizedBox(height:MediaQuery.of(context).size.height * 0.02,),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05,width:MediaQuery.of(context).size.width * 0.8,
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
                          color: Color(0xff011c27),),
                          filled: true,
                          fillColor: Color(0xfff5e1da),
                          border:  OutlineInputBorder(
                           
                          ),
                        ),
                      ),
                      ),
                      
                       SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                      SizedBox(
                      height: MediaQuery.of(context).size.height * 0.045,
                      width:MediaQuery.of(context).size.width * 0.5,
                       child:ElevatedButton(
                        style:ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffe28413)),
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
                    color: Color(0xff011c27),
                  ),
                  ),
              ),
                      ),
                      SizedBox(height:MediaQuery.of(context).size.height * 0.05,),
                FractionallySizedBox(
                    widthFactor: 1.0, 
                    child: Container(
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignCenter,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height:MediaQuery.of(context).size.height * 0.03,),
                      SizedBox(
                    width:MediaQuery.of(context).size.width * 0.8,
                    child:Center(
                      child: RichText(
                        text:TextSpan(
                          text: "Remember your password? ",
                        style: const TextStyle(
                                    color: Color(0xff011c27),
                                                      fontFamily: 'Roboto', 
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,),
                        children: <TextSpan>[
                          TextSpan(
                                  text: 'Sign in!',
                                    style: const TextStyle(
                                     decoration: TextDecoration.underline,
                                    color: Color(0xff0e79b2),
                                                      fontFamily: 'Roboto', 
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                          ),
                                          recognizer: TapGestureRecognizer()
                        ..onTap = () {
                           Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginView()),
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
          ),
            
    );
  }
}