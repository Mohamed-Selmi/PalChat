import 'package:flutter/material.dart';
import 'package:pfeapp/models/user.dart';
import 'package:pfeapp/API/friendListAPI.dart';
import 'package:pfeapp/API/UserAPI.dart';
import 'package:pfeapp/Messaging/user_profile.dart';
import 'package:pfeapp/Mainpage/convex_app_bar.dart';
import 'package:pfeapp/API/friendrequestAPI.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({Key? key}) : super(key: key);

  @override
  _AllUsersScreenState createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  late Future<List<User>> _futureUsers;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _futureUsers = FriendListAPI.fetchAllUsers();
  }

  void _searchUsers() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
      if (_isSearching) {
        _futureUsers = UserAPI.searchUsers(_searchController.text);
      } else {
        _futureUsers = FriendListAPI.fetchAllUsers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f2f2),
        title: TextField(
          controller: _searchController,
          onChanged: (value) => _searchUsers(),
          decoration: InputDecoration(
            hintText: 'Search users',
            suffixIcon: IconButton(
              color: const Color(0xff011c27),
              icon: const Icon(Icons.search),
              onPressed: _searchUsers,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (!_isSearching) 
            Expanded(
              child: FutureBuilder<List<User>>(
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
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Card(
                            color: const Color(0xfff5e1da),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FriendProfileWidget(userId: user.id),
                                  ),
                                );
                              },
                              subtitle: Text(
                                user.email,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff011c27),
                                ),
                              ),
                              title: Text(
                                user.username,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff011c27),
                                ),
                              ),
                              leading: CircleAvatar(
                                radius: 23,
                                backgroundImage: user.pictureUrl != null
                                    ? NetworkImage(user.pictureUrl!)
                                    : const AssetImage('assets/images/default_profile_picture.png')
                                        as ImageProvider<Object>,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No Users Found'));
                  }
                },
              ),
            ),
          if (_isSearching) 
            Expanded(
              child: FutureBuilder<List<User>>(
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
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Card(
                           color: const Color(0xfff5e1da),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                             onTap: null,
                              subtitle: Text(
                                user.email,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff011c27),
                                ),
                              ),
                              title: Text(
                                user.username,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color:Color(0xff011c27),
                                ),
                              ),
                              leading: CircleAvatar(
                                radius: 23,
                                backgroundImage: user.pictureUrl != null
                                    ? NetworkImage(user.pictureUrl!)
                                    : const AssetImage('assets/images/default_profile_picture.png')
                                        as ImageProvider<Object>,
                              ),
                              trailing: IconButton(
                                      icon: const Icon(Icons.person_add_alt_rounded), 
                                      color: const Color(0xff15b097),
                                      iconSize: 40,
                                      onPressed: () async {
                                        try {
                                          await FriendRequestAPI.sendFriendRequest(user.id);
                                          // If friend request is sent successfully, show a success snackbar
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text('Friend request sent successfully'),
                                            backgroundColor: Colors.green,
                                          ));
                                        } catch (e) {
                                          // Handle errors by showing an error snackbar
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                             content: Text('$e'),
                                            backgroundColor: Colors.red,
                                          ));
                                        }
                                      },
                                    ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No Users Found'));
                  }
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: MyConvexAppBar(
        currentPage: 1,
        onTap: (int index) {},
      ),
    );
  }
}
