import 'package:flutter/material.dart';
import 'package:pfeapp/API/managegroupAPI.dart';
import 'package:pfeapp/models/conversation.dart';
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
      appBar: AppBar(
        title: Text('User Conversations'),
      ),
      body: Column(
        children: [
          FutureBuilder<List<Conversation>>(
            future: _conversationsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
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
                         
                          SizedBox(height:70,
                              width:320,
                            child: Container(decoration: BoxDecoration(
                                          border: Border.all(color: const Color.fromARGB(255, 23, 82, 211)),
                                          borderRadius: BorderRadius.circular(10),                              
                                        ),
                              child: ListTile(
                              title: Text(
                                'Room: ${conversation.name}',
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 0, 0),
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
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                  Text(
                                    conversation.last_message ?? 'No last message',
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 0, 0, 0),
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
                          SizedBox(height:30),
                        ],
                      );
                    },
                  ),
                );
              }
            },
          ),
          
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
                                        MaterialPageRoute(builder: (context) => const CreateGroupWidget()),
                                      );
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                       Icon(Icons.logout,color: Color.fromARGB(255, 1, 21, 75),),
                                       Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text('Create a new Group',style: TextStyle(
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
      ),
    );
  }
}
