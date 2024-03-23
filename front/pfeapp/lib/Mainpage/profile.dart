import 'package:flutter/material.dart';
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
      
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Container(
        
        child: Column(children: [FutureBuilder<User?>(
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
                       if (snapshot.data!.pictureUrl != null) // Check if picture is available
                          CircleAvatar(
                            radius: 100
                          ,
                            backgroundImage: NetworkImage(snapshot.data!.pictureUrl!),
                          ),
                          SizedBox(
                            width: 200, // Specify your desired width
                            height: 40,
                              child:Text('Email: ${snapshot.data!.email}',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat', 
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 0, 0, 0),),)
                          ),
                           SizedBox(
                            width: 200, // Specify your desired width
                            height: 40,
                              child: Text('Username: ${snapshot.data!.username}',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat', 
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 14, 14, 14),),)
                          ),
                          
                   ],
    ),
  );
            } else {
              return const Text('No User Data Found');
            }

          },
        ),
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
                  LogoutAPI.LogoutUser(
                    
                    context,
                  );
                },
                child:const Text("logout",
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
                      SizedBox(height:40,),
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
                          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileWidget()),
            );
                },
                child:const Text("edit profile",
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
        ]
      ),

      )
      
    );
  }
}