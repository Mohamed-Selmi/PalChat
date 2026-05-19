// ignore_for_file: unused_import
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:pfeapp/homepage/loginview.dart';
import 'package:pfeapp/API/RegisterAPI.dart';

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
          resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xfff2f2f2),
          
          body:SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 40.0),
              color:const Color.fromARGB(0, 255, 255, 255),
              child: Column(children: [
                const SizedBox(height:10,),
                const Text('Welcome To PalChat',
                textAlign: TextAlign.center,
                style:TextStyle(
                  fontFamily: 'Aleo',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      color: Color(0xff011c27)
                )),
              SizedBox(
                    height:MediaQuery.of(context).size.height * 0.45,
                      child: SvgPicture.asset(
                        'assets/images/applogo.svg',                      
                      ),
                    ), 
            
                  Column(children: [
                    SizedBox(height:MediaQuery.of(context).size.height * 0.05, width:MediaQuery.of(context).size.width * 0.8,
                     
                      child:TextField(
                      
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.text,
                      controller: usernameController,
                      style: const TextStyle(color: Color(0xff011c27),),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 1.0),
                        hintText: 'Enter your Username',
                        prefixIcon: Icon(Icons.person,
                        color: Color((0xff011c27)),),
                        filled: true,
                        fillColor: Color(0xfff5e1da),
                        border:  OutlineInputBorder(
                         
                        ),
                      ),
                    ),
                    ),
                     SizedBox(height:MediaQuery.of(context).size.height * 0.02,),
                     SizedBox(height:MediaQuery.of(context).size.height * 0.05, width:MediaQuery.of(context).size.width * 0.8,
                     
                      child:TextField(
                      
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      style: const TextStyle(color: Color(0xff011c27),),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 1.0),
                        hintText: 'Enter your Email Address',
                        prefixIcon: Icon(Icons.mail,
                        color: Color((0xff011c27)),),
                        filled: true,
                        fillColor: Color(0xfff5e1da),
                        border:  OutlineInputBorder(                      
                        ),
                      ),
                    ),
                    ),
                     SizedBox(height:MediaQuery.of(context).size.height * 0.02,),
                       SizedBox(height: MediaQuery.of(context).size.height * 0.05,width:MediaQuery.of(context).size.width * 0.8,
                      child:TextField(
                       obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: passwordController,
                      style: const TextStyle(color: Color(0xff011c27)),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 1.0),
                        hintText: 'Enter your password',
                        prefixIcon: Icon(Icons.key,
                        color: Color((0xff011c27)),),
                        filled: true,
                        fillColor: Color(0xfff5e1da),
                        border:  OutlineInputBorder(
                         
                        ),
                      ),
                    ),
                    ),
                    SizedBox(height:MediaQuery.of(context).size.height * 0.02,),
                    SizedBox(
                     height:MediaQuery.of(context).size.height * 0.045,
                      width:MediaQuery.of(context).size.width * 0.45,
                     child:ElevatedButton(
                      style:ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffe28413)),
                        shape: MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,)
                            ),
                      ),
                      onPressed: () {
                  RegisterAPI.signUpUser(
                    context,
                    usernameController.text,
                    emailController.text,
                    passwordController.text,
                  );
                                  },
                                  child:const Text("Register",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                   fontFamily: 'Montserrat', 
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  color: Color(0xff011c27),
                                  ),
                                  ),
                    ),
                    ),
                    SizedBox(height:MediaQuery.of(context).size.height * 0.02,),
                    
                    
                    ],
                    ),
                 SizedBox(height:MediaQuery.of(context).size.width * 0.08,),
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
                   SizedBox(height:MediaQuery.of(context).size.height * 0.045,),
                  SizedBox(
                    
                    width:MediaQuery.of(context).size.width * 0.8,
                    child:Center(
                      child: RichText(
                        text:TextSpan(
                          text: "Already have an account? ",
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
