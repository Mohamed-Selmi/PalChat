import 'package:flutter/material.dart';
import 'package:pfeapp/models/user.dart';
import 'package:pfeapp/API/friendListAPI.dart';

class FriendProfileWidget extends StatefulWidget {
  final String email;

  const FriendProfileWidget({required this.email, Key? key}) : super(key: key);

  @override
  _FriendProfileWidgetState createState() => _FriendProfileWidgetState();
}

class _FriendProfileWidgetState extends State<FriendProfileWidget> {
  late Future<User?> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = FriendListAPI.friendProfile(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffd1dff6),
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Container(
        child: Column(
          children: [
            FutureBuilder<User?>(
              future: futureUser,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data != null) {
                  return Center(
                    child: Column(
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
                        const SizedBox(height: 40),
                        SizedBox(
                          width: 275,
                          height: 40,
                          child: Row(
                            children: [
                              const Icon(Icons.email, color: Color.fromARGB(255, 6, 36, 201)),
                              Text(
                                'Email:   ${snapshot.data!.email}',
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 275,
                          height: 40,
                          child: Row(
                            children: [
                              const Icon(Icons.person, color: Color.fromARGB(255, 6, 36, 201)),
                              Text(
                                'Name:   ${snapshot.data!.username}',
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Text('No User Data Found');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
