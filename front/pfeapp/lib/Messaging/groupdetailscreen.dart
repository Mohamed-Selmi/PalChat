import 'package:flutter/material.dart';
import 'package:pfeapp/forms/adduserform.dart';
import 'package:pfeapp/models/user.dart';
import 'package:pfeapp/API/managegroupAPI.dart';
class GroupDetailWidget extends StatefulWidget {
  final int groupId;

  GroupDetailWidget({required this.groupId});

  @override
  _GroupDetailWidgetState createState() => _GroupDetailWidgetState();
}

class _GroupDetailWidgetState extends State<GroupDetailWidget> {
  late Future<Map<String, dynamic>> groupDetailFuture;

  @override
  void initState() {
    super.initState();
    groupDetailFuture = ManageGroupAPI.getGroupDetail(widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member list'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: groupDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<User> members = (snapshot.data!['members'] as List)
                .map((member) => User(
                      email: member['email'],
                      username: member['username'],
                      pictureUrl: member['picture_url'],
                    ))
                .toList();

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(members[index].pictureUrl ?? ''),
                          ),
                          title: Text(
                            members[index].email,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          subtitle: Text(
                            members[index].username,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 300,
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => AddUserWidget(groupId: widget.groupId)),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Color.fromARGB(255, 1, 21, 75)),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Add a new Group Member',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
