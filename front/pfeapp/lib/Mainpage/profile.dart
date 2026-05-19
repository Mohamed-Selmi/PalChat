import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pfeapp/API/logoutAPI.dart';
import 'package:pfeapp/models/user.dart';
import 'package:pfeapp/Mainpage/convex_app_bar.dart';

import 'package:pfeapp/API/UserAPI.dart';
import 'package:pfeapp/forms/editprofileForm.dart';
class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late Future<User?> futureUser;
  @override
  void initState() {
    super.initState();
    futureUser = UserAPI.fetchUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f2f2),
        title: const Text('Profile'),
      ),
      body: Column(children: [
        FutureBuilder<User?>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData && snapshot.data != null) {
            return Center(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [           
                     if (snapshot.data!.pictureUrl != null) 
                        CircleAvatar(
                           radius: MediaQuery.of(context).size.height * 0.17,
                              backgroundColor: const Color.fromARGB(255, 9, 124, 34),
                          child: CircleAvatar(
                            radius: MediaQuery.of(context).size.height * 0.16,
                            backgroundImage: NetworkImage(snapshot.data!.pictureUrl!),
                          ),
                        ),
                       SizedBox(height:MediaQuery.of(context).size.height * 0.02,),
                        SizedBox(
                         height:MediaQuery.of(context).size.height * 0.05, width:MediaQuery.of(context).size.width * 0.8,
                          child:Row(
                            children: [
                                            const Icon(Icons.email,
                                    color: Color(0xff007cbe),),
                              Text('Email:   ${snapshot.data!.email}',
                                        style: const TextStyle(
                                          fontFamily: 'Montserrat', 
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          color: Color(0xff011c27),),)
                            ],
                          )                                                         
                        ),
                         SizedBox(
                         height:MediaQuery.of(context).size.height * 0.05, width:MediaQuery.of(context).size.width * 0.8,
                          child:Row(
                            children: [
                                            const Icon(Icons.person,
                                    color: Color(0xff007cbe),),
                              Text('Name:   ${snapshot.data!.username}',
                                        style: const TextStyle(
                                          fontFamily: 'Montserrat', 
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          color: Color(0xff011c27),)
                                          ,)
                            ],
                          )                                                        
                        ),
       
                 ],
          ),
        );
          } else {
            return const Text('No User Data Found');
          }
        },
      ),
      
                  SizedBox(height:MediaQuery.of(context).size.height * 0.02,),
                  Column(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                           
                                  SizedBox(height:MediaQuery.of(context).size.height * 0.02,),
                                      SizedBox(
                           height: MediaQuery.of(context).size.height * 0.05, width:MediaQuery.of(context).size.width * 0.8,
                              child: Card(    
                                color:const Color(0xffe28413) ,                                     
                                            clipBehavior: Clip.hardEdge,
                                                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) =>  EditProfileWidget()),
                                      );
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                   Icon(Icons.settings,color: Color(0xff011c27),),
                                   Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Settings',style: TextStyle(
                                                      fontFamily: 'Roboto', 
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                      color: Color(0xff011c27),
                                                    ),),
                                    ),
                                  
                                   Icon(Icons.arrow_forward,color: Color(0xff011c27),),
                                ],
                              ),
                                          )
                                        ),
                            ),
                                                   SizedBox(height:MediaQuery.of(context).size.height * 0.02,),
                        
                             SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05, width:MediaQuery.of(context).size.width * 0.8,
                              child: Card(   
                                color:const Color(0xffe28413) ,                                      
                                            clipBehavior: Clip.hardEdge,
                                                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                LogoutAPI.LogoutUser(                                              
                                              context,
                                            );
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                   Icon(Icons.logout,color: Color(0xff011c27),),
                                   Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Logout',style: TextStyle(
                                                      fontFamily: 'Roboto', 
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                      color: Color(0xff011c27),
                                                    ),),
                                    ),
                                  
                                   Icon(Icons.arrow_forward,color: Color(0xff011c27),),
                                ],
                              ),
                                          )
                                        ),
                            ),
                    ],
                  ),
      ]
            ),
      bottomNavigationBar: MyConvexAppBar( 
        currentPage:3,
        onTap: (int index) {
          
        },
      ),
    );
  }
}