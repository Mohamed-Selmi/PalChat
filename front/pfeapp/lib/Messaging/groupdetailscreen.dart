import 'package:flutter/material.dart';
import 'package:pfeapp/forms/adduserform.dart';
import 'package:pfeapp/Mainpage/groups.dart';

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
        title: const Text('Group Details'),
         actions: [
    IconButton(
      icon: const Icon(Icons.add), 
      color: Colors.green,
      iconSize: 32.0,
      onPressed: () {
  Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => AddUserWidget(groupId: widget.groupId)),
                        );
      },
    ),
    IconButton(
      icon: const Icon(Icons.delete), 
      color: Colors.red,
      iconSize: 32.0,
      onPressed: () {
        ManageGroupAPI.deleteGroup(
                 widget.groupId
                );
Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserConversations()),
          );
      },
    ),
  ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: groupDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<User> members = (snapshot.data!['members'] as List)
                .map((member) => User(
                      id:member['user_id'],
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
                            color: const Color(0xfff5e1da),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: members[index].pictureUrl != null
                                    ? NetworkImage(members[index].pictureUrl!)
                                    : const AssetImage('assets/images/default_profile_picture.png')
                                        as ImageProvider<Object>, 
                          ),
                          title: Text(
                            members[index].email,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff011c27),
                            ),
                          ),
                          subtitle: Text(
                            members[index].username,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff011c27),
                            ),
                          ),
                           trailing:                                                                                        
                                                    IconButton(
                                                      icon: const Icon(Icons.person_remove),
                                                      color: Colors.red,
                                                      iconSize: 40,
                                                      onPressed: () {
                                                        ManageGroupAPI.removeMember(widget.groupId,members[index].id);
                                                      },
                                                    ),
                        ),
                      );
                    },
                  ),
                ),  
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.045,
                      width:MediaQuery.of(context).size.width * 0.5,
                     child:ElevatedButton(
                      style:ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffe28413)),
                        shape: MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,)
                            ),
                      ),
                     onPressed: () {
                      ManageGroupAPI.leaveGroup(widget.groupId);
                     Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  UserConversations()),
            );
                  },
                                  child:const Text("leave group",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                   fontFamily: 'Montserrat', 
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  color:  Color(0xff011c27)
                                  ),
                                  ),
                    ),
                    ),    
                    SizedBox(height:MediaQuery.of(context).size.height * 0.02,),         
              ],
            );
          }
        },
      ),
    );
  }
}
