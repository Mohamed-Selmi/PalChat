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
                      keyboardType: TextInputType.text,
                      controller: usernameController,
                      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0),),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 1.0),
                        hintText: 'Enter your Username',
                        prefixIcon: Icon(Icons.person,
                        color: Colors.black,),
                        filled: true,
                        fillColor: Color.fromARGB(255, 255, 255, 255),
                        border:  OutlineInputBorder(
                         
                        ),
                      ),
                    ),
                    ),
                     const SizedBox(height:20),
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
                        prefixIcon: Icon(Icons.mail,
                        color: Colors.black,),
                        filled: true,
                        fillColor: Color.fromARGB(255, 255, 255, 255),
                        border:  OutlineInputBorder(
                         
                        ),
                      ),
                    ),
                    ),
                     const SizedBox(height: 20),
                       SizedBox(height: 40,width:300,
                      child:TextField(
                       obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: passwordController,
                      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      decoration: const InputDecoration(
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
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                ),
  ),
                    ),
                    const SizedBox(height:10),
                    
                    
                    ],
                    ),
                ),
                const SizedBox(height:20),
              Container(
                child:Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                  children: [
                  Container(
                    width: 123,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                        ),
                      ),
                    ),
                  ),
                  const Text(
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
                    decoration: const ShapeDecoration(
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
              const SizedBox(height:20,),
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
              const SizedBox(height:30,),
              FractionallySizedBox(
                  widthFactor: 1.0, // Set width to 100% of the screen
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
                const SizedBox(height:20),
                SizedBox(
                  
                  width:250,
                  child:Center(
                    child: RichText(
                      text:TextSpan(
                        text: "Already have an account? ",
                      style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                                    fontFamily: 'Roboto', 
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,),
                      children: <TextSpan>[
                        TextSpan(
                                text: 'Sign in!',
                                  style: const TextStyle(
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
          
   );
   
        
      
    
  }
}
