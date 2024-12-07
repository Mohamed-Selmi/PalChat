// ignore_for_file: unused_import
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:pfeapp/homepage/loginview.dart';
class ResetForm extends StatefulWidget {
  const ResetForm({super.key});
  @override
  ResetCard createState() => ResetCard();
}
class ResetCard extends State<ResetForm> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
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
                      
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: newPasswordController,
                      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0),),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 1.0),
                        hintText: 'Enter your new password',
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
                    SizedBox(height: 40, width:300,
                      child:TextField(
                      
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: confirmNewPasswordController,
                      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0),),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 1.0),
                        hintText: 'Confirm your new Password',
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
  