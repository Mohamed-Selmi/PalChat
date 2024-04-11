import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pfeapp/API/logoutAPI.dart';
import 'package:pfeapp/models/user.dart';
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
      backgroundColor: Color(0xffd1dff6),
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Container(       
        child: Column(children: [
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
                             radius: 105,
                                backgroundColor: const Color.fromARGB(255, 9, 124, 34),
                            child: CircleAvatar(
                              radius: 100,
                              backgroundImage: NetworkImage(snapshot.data!.pictureUrl!),
                            ),
                          ),
                          const SizedBox(height:40),
                          SizedBox(
                               width: 250,
                            height: 40,
                            child:Row(
                              children: [
                                              const Icon(Icons.email,
                                      color: Color.fromARGB(255, 6, 36, 201),),
                                Text('Email:   ${snapshot.data!.email}',
                                          style: const TextStyle(
                                            fontFamily: 'Montserrat', 
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 0, 0, 0),),)
                              ],
                            )                                                         
                          ),
                           SizedBox(
                               width: 250, 
                            height: 40,
                            child:Row(
                              children: [
                                              const Icon(Icons.person,
                                      color: Color.fromARGB(255, 6, 36, 201),),
                                Text('Name:   ${snapshot.data!.username}',
                                          style: const TextStyle(
                                            fontFamily: 'Montserrat', 
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 0, 0, 0),)
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
        
                    const SizedBox(height:20,),
                    Container(
                      child: Column(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                                SizedBox(
                                  height:50,
                                  width:300,
                                  child: Card(                                        
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
                                       Icon(Icons.logout,color: Color.fromARGB(255, 1, 21, 75),),
                                       Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text('Logout',style: TextStyle(
                                                          fontFamily: 'Roboto', 
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.bold,
                                                          color: Color.fromARGB(255, 0, 0, 0),
                                                        ),),
                                        ),
                                      
                                       Icon(Icons.arrow_forward,color: Colors.black,),
                                    ],
                                  ),
                                              )
                                            ),
                                ),
                                          const SizedBox(height:20,),
                                          SizedBox(
                                  height:50,
                                  width:300,
                                  child: Card(                                        
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
                                       Icon(Icons.settings,color: Color.fromARGB(255, 1, 21, 75),),
                                       Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text('Settings',style: TextStyle(
                                                          fontFamily: 'Roboto', 
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.bold,
                                                          color: Color.fromARGB(255, 0, 0, 0),
                                                        ),),
                                        ),
                                      
                                       Icon(Icons.arrow_forward,color: Colors.black,),
                                    ],
                                  ),
                                              )
                                            ),
                                ),
                        ],
                      )
                    ),
        ]
      ),

      ),
    );
  }
}