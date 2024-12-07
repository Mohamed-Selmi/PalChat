import 'package:flutter/material.dart';
import 'package:pfeapp/models/user.dart';
import 'package:pfeapp/API/friendListAPI.dart';
import 'package:pfeapp/API/UserAPI.dart';
import 'package:pfeapp/Messaging/user_profile.dart';
 class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({Key? key}) : super(key: key);
  @override
  _AllUsersScreenState createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  late Future<List<User>> _futureUsers;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureUsers = FriendListAPI.fetchAllUsers();
  }

  void _searchUsers() {
    setState(() {
      _futureUsers = UserAPI.searchUsers(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search users',
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: _searchUsers,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<User>>(
        future: _futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                return Column(
                  children: [
                    const SizedBox(height: 15),
                    SizedBox(height:70,
                    width:320,
                      child: Container(        
                                  decoration: BoxDecoration(
                                border: Border.all(color: const Color.fromARGB(255, 23, 82, 211)),
                                borderRadius: BorderRadius.circular(10),                              
                              ),
                        child: GestureDetector(
                          onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => FriendProfileWidget(email: user.email),
                                          ),
                                        );},
                          child: ListTile(   
                            subtitle: Text(user.email,style: const TextStyle(
                                             fontFamily: 'Montserrat', 
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),),                    
                            title: Text(user.username,style: const TextStyle(
                                             fontFamily: 'Montserrat', 
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: user.pictureUrl != null
                                ? NetworkImage(user.pictureUrl!) as ImageProvider<Object>
                                : const AssetImage('assets/default_profile_picture.png') as ImageProvider<Object>,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            return const Center(child: Text('No Users Found'));
          }
        },
      ),
    );
  }
}
