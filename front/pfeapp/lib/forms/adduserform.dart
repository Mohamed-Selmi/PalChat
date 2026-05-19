import 'package:flutter/material.dart';
import 'package:pfeapp/API/managegroupAPI.dart';
import 'package:pfeapp/models/user.dart';
import 'package:pfeapp/API/friendListAPI.dart';
class AddUserWidget extends StatefulWidget {
    final int groupId;
  const AddUserWidget({required this.groupId, Key? key}) : super(key: key);
  @override
  State<AddUserWidget> createState() => _AddUserWidgetState();
}

class _AddUserWidgetState extends State<AddUserWidget> {
   late Future<List<User>> _futureUsers;
  void initState() {
    super.initState();
    _futureUsers = FriendListAPI.fetchAllUsers();
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f2f2),
        title: const Text('Add your friends'),
      ),
      body: Column(
        children: [
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
                               trailing:                                                                                        
                                                    IconButton(
                                                      icon: const Icon(Icons.person_add),
                                                      color: Colors.green,
                                                      iconSize: 40,
                                                      onPressed: () {
                                                        ManageGroupAPI.addMemberToGroup(widget.groupId,user.email);
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
        ]
              ),
            );
  }
}
