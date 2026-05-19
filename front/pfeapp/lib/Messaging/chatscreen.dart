// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:pfeapp/API/UserAPI.dart';
import 'package:pfeapp/Messaging/groupdetailscreen.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pfeapp/models/user.dart';
import 'package:pfeapp/models/message.dart';
import 'package:pfeapp/API/chatAPI.dart';
 class chatscreen extends StatefulWidget {
  final int groupId;

  chatscreen({required this.groupId});

  @override
  _chatscreenState createState() => _chatscreenState();
}
class _chatscreenState extends State<chatscreen> {
  final ScrollController _scrollController = ScrollController();
  late WebSocketChannel channel;
  final TextEditingController _controller = TextEditingController();
  List<Message> messages = [];
  File? _image;
  
 
  final ImagePicker _picker = ImagePicker();
  
  @override
  void initState() {
    super.initState();
    _initializeWebSocket();
    _fetchMessages();
  }
  void _initializeWebSocket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken != null) {
      channel = IOWebSocketChannel.connect(
        'ws://192.168.1.3:8000/ws/chat/${widget.groupId}/',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      channel.stream.listen((message) {
        _handleMessage(message);
      });
    } else {
      throw Exception('Access token not found');
    }
  }
  void _handleMessage(dynamic message) {
  if (message is String) {
    Map<String, dynamic> messageData = jsonDecode(message);
    if (messageData.containsKey('picture_url')) {
      _handleImageMessage(messageData);
    } else {
      _handleTextMessage(message);
    }
  } else {
    print("Received unsupported message type: $message");
  }
}
  
  void _handleTextMessage(String message) async {
  try {
    User? currentUser = await UserAPI.fetchUser();
    if (currentUser != null) {
      Map<String, dynamic> messageData = jsonDecode(message);
      setState(() {
        messages.add(Message(
          fromUserId: messageData['message_sender']['user_id'],
          fromUser: messageData['message_sender']['username'],
          message: messageData['message_content'],
          timestamp: DateTime.parse(messageData['message_timestamp']),
        ));
      });
    } else {
      print('Current user not found');
    }
  } catch (e) {
    print('Error handling text message: $e');
  }
}

void _handleImageMessage(Map<String, dynamic> message) {
  if (message.containsKey('picture_url') && message['picture_url']?.isNotEmpty == true) {
    setState(() {
      messages.add(Message(
        fromUserId: message['sender']['user_id'],
        fromUser: message['sender']['username'],
        message: message['content'],
        timestamp: DateTime.parse(message['timestamp']),
        imageUrl: message['picture_url'],
      ));
    });
  } else {
    print("Received image message with missing or empty image URL");
  }
}
 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xfff2f2f2),
    appBar: AppBar(
      backgroundColor: const Color(0xfff2f2f2),
      title: const Text('Chat Screen'),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroupDetailWidget(groupId: widget.groupId),
              ),
            );
          },
        ),
      ],
    ),
    body: FutureBuilder<User?>(
      future: UserAPI.fetchUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          User? currentUser = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      children: [
                        ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: messages[index].fromUser == currentUser?.username
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: messages[index].fromUser == currentUser?.username
                                        ? const Color(0xff007cbe)
                                        : const Color(0xffbebebe),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      if (messages[index].imageUrl != null && messages[index].imageUrl!.isNotEmpty)
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.6,
                                        
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                '${messages[index].fromUser}:',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: messages[index].fromUser == currentUser?.username
                                                      ? const Color.fromARGB(255, 255, 255, 255)
                                                      : const Color(0xff011c27),
                                                ),
                                              ),
                                              Image.network(
                                                messages[index].imageUrl!,
                                                fit: BoxFit.cover,
                                              ),
                                              Text(
                                                DateFormat('yyyy-MM-dd – kk:mm').format(messages[index].timestamp),
                                                style: const TextStyle(fontSize: 10.0, color: Color.fromARGB(255, 0, 0, 0)),
                                              ),
                                            ],
                                          ),
                                        )
                                      else
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.6,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                '${messages[index].fromUser}:',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: messages[index].fromUser == currentUser?.username
                                                      ? const Color.fromARGB(255, 255, 255, 255)
                                                      : const Color(0xff011c27),
                                                ),
                                              ),
                                              Text(
                                                 
                                                messages[index].message,
                                                style: TextStyle(
                                                  color: messages[index].fromUser == currentUser?.username
                                                      ? const Color.fromARGB(255, 255, 255, 255)
                                                      : const Color(0xff011c27),
                                                ),
                                              ),
                                              Text(
                                                DateFormat('yyyy-MM-dd – kk:mm').format(messages[index].timestamp),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: messages[index].fromUser == currentUser?.username
                                                      ? const Color.fromARGB(255, 255, 255, 255)
                                                      : const Color(0xff011c27),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image),
                      iconSize: 32.0,
                      onPressed: _getImage,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.68,
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 1.0),
                          hintText: ' Enter a message',
                          filled: true,
                          fillColor: Color(0xfff5e1da),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.forward),
                      color: const Color(0xff007cbe),
                      iconSize: 32.0,
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    ),
  );
}

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _sendImage();
      } else {
        print('No image selected.');
      }
    
  }
Future<void> _sendImage() async {
  print("sent image");
  int conversation = widget.groupId;
  String content = "user sent attachment";

  try {
    ChatAPI api = ChatAPI();
    await api.sendMessage(conversation, content, _image);
    
    print("Message sent successfully");
    
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to send message: $e');
  }
}
void _sendMessage() {
    final message = _controller.text;
    channel.sink.add(message);
     _controller.clear();
  print("Max Scroll Extent: ${_scrollController.position.maxScrollExtent}");
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent, 
      duration: const Duration(milliseconds: 1000 ),
      curve: Curves.easeOut,
    );
  } 


  void _fetchMessages() async {
    
    try {
      List<Message> fetchedMessages = await ChatAPI.fetchRoomMessages(widget.groupId);
    
      setState(() {
        messages = fetchedMessages;
      });
      
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}