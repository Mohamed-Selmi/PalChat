import 'package:flutter/material.dart';
import 'package:pfeapp/API/managegroupAPI.dart';
import 'package:pfeapp/models/conversation.dart';
import 'package:pfeapp/Mainpage/convex_app_bar.dart';

import 'package:pfeapp/forms/creategroupform.dart';
import 'package:pfeapp/Messaging/chatscreen.dart';
class UserConversations extends StatefulWidget {
  @override
  _UserConversationsState createState() => _UserConversationsState();
}

class _UserConversationsState extends State<UserConversations> {
  late Future<List<Conversation>> _conversationsFuture;

  @override
  void initState() {
    super.initState();
    _fetchConversations();
  }

  Future<void> _fetchConversations() async {
    setState(() {
      _conversationsFuture = ManageGroupAPI.fetchUserConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f2f2),
        title: const Text('User Conversations'),
        actions: [
    IconButton(
      icon: const Icon(Icons.add), 
      iconSize: 32.0,
      onPressed: () {
  Navigator.pushReplacement(
                   context,
                   MaterialPageRoute(builder: (context) => const CreateGroupWidget()),
                  );
      },
    ),
  ],
      ),
      body: Column(
        children: [
          FutureBuilder<List<Conversation>>(
            future: _conversationsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erroaar: ${snapshot.error}'));
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final conversation = snapshot.data![index];
                      return Column(
                        children: [
                         
                          SizedBox(height: MediaQuery.of(context).size.height * 0.09, width:MediaQuery.of(context).size.width * 0.9,
                            child: Container(decoration: BoxDecoration(
                                          color: const Color(0xfff5e1da),
                                          border: Border.all(color: const Color(0xff011c27)),
                                          borderRadius: BorderRadius.circular(10),                              
                                        ),
                              child: ListTile(
                              title: Text(
                                'Room: ${conversation.name}',
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff011c27),
                                ),
                              ),
                              subtitle: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${conversation.last_sent_user ?? 'No last sent user'}:  ',
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff011c27),
                                    ),
                                  ),
                                 Text(
                                  conversation.last_message != null
                                      ? conversation.last_message!.length > 35
                                          ? conversation.last_message!.substring(0, 35) + '...'
                                          : conversation.last_message!
                                      : 'No last message',
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 10, // Increase the font size for better visibility
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff011c27),
                                  ),
                                ),
                                  
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => chatscreen(
                                      groupId: conversation.id,
                                    ),
                                  ),
                                );
                              },
                            )

                            ),
                          ),
                          SizedBox(height:MediaQuery.of(context).size.height * 0.025,),
                        ],
                      );
                    },
                  ),
                );
              }
            },
          ),
          
          
          
        ],
      ),
       bottomNavigationBar: MyConvexAppBar(
        currentPage:0,
        onTap: (int index) {
          
        },
      ),
    );
  }
}
