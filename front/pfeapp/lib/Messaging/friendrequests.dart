import 'package:flutter/material.dart';
import 'package:pfeapp/API/friendrequestAPI.dart';
import 'package:pfeapp/models/friendrequest.dart';
import 'package:pfeapp/Mainpage/convex_app_bar.dart';

import 'package:intl/intl.dart';
class FriendRequests extends StatefulWidget {
  const FriendRequests({Key? key}) : super(key: key);

  @override
  State<FriendRequests> createState() => _FriendRequestsState();
}

class _FriendRequestsState extends State<FriendRequests> {
  late Future<List<FriendRequest>> _futureRequests;
  bool _showReceivedRequests = true;

  @override
  void initState() {
    super.initState();
    _futureRequests = FriendRequestAPI.fetchFriendRequests();
  }

  void _loadReceivedRequests() {
    setState(() {
      _showReceivedRequests = true;
      _futureRequests = FriendRequestAPI.fetchFriendRequests();
    });
  }

  void _loadSentRequests() {
    setState(() {
      _showReceivedRequests = false;
      _futureRequests = FriendRequestAPI.fetchSentFriendRequests();
    });
  }
 void acceptFriendRequest(BuildContext context, int requestId, String senderUsername) async {
  try {
    await FriendRequestAPI.acceptFriendRequest(requestId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text('You and $senderUsername are now friends'),
      ),
    );
    setState(() {
      _futureRequests=FriendRequestAPI.fetchFriendRequests();
    });
  } catch (e) {
  }
}
 void declineFriendRequest(BuildContext context, int requestId, String senderUsername) async {
  try {
    await FriendRequestAPI.declineFriendRequest(requestId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text('Declined $senderUsername ''s request'),
      ),
    );
    setState(() {
      _futureRequests=FriendRequestAPI.fetchFriendRequests();
    });
  } catch (e) {
  }
}
 void cancelFriendRequest(BuildContext context, int requestId, String receiverUsername) async {
  try {
    await FriendRequestAPI.cancelFriendRequest(requestId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text('Canceled request to $receiverUsername '),
      ),
    );
    setState(() {
      _futureRequests=FriendRequestAPI.fetchFriendRequests();
    });
  } catch (e) {
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f2f2),
        title: const Text('Friend Requests'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
                Column(
                      children: [
                        IconButton(
                          onPressed: _loadReceivedRequests,
                          icon: const Icon(Icons.move_to_inbox),
                          iconSize: 40,
                          color: const Color(0xff011c27),
                        ),
                        const SizedBox(height: 5), 
                        const Text('Received Requests'),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: _loadSentRequests,
                          icon: const Icon(Icons.forward_to_inbox),
                          iconSize: 40,
                          color: const Color(0xff011c27),
                        ),
                        const SizedBox(height: 5),
                        const Text('Sent Requests'),
                      ],
                    )
           
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Expanded(
            child: FutureBuilder<List<FriendRequest>>(
              future: _futureRequests,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data != null) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final request = snapshot.data![index];
                      return Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xfff5e1da),
                                border: Border.all(color: const Color(0xff011c27)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                subtitle: Text(
                                  DateFormat('yyyy-MM-dd – kk:mm').format(request.timestamp),
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 7,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff011c27),
                                  ),
                                ),
                                title: Text(
                                  _showReceivedRequests ? request.sender_username : request.receiver_username,
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff011c27),
                                  ),
                                ),
                               leading: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: _showReceivedRequests
                                            ? (request.sender_picture_url != null
                                                ? NetworkImage(request.sender_picture_url!)
                                                : const AssetImage('assets/images/default_profile_picture.png') as ImageProvider<Object>)
                                            : (request.receiver_picture_url != null
                                                ? NetworkImage(request.receiver_picture_url!)
                                                : const AssetImage('assets/images/default_profile_picture.png') as ImageProvider<Object>),
                                      ),
                                trailing: _showReceivedRequests
                                              ? Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(Icons.check),
                                                      color: Colors.green,
                                                      iconSize: 40,
                                                      onPressed: () {
                                                        acceptFriendRequest(context, request.id, request.sender_username);
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(Icons.close),
                                                      color: Colors.red,
                                                      iconSize: 40,
                                                      onPressed: () {
                                                        declineFriendRequest(context, request.id, request.sender_username);
                                                      },
                                                    ),
                                                  ],
                                                )
                                              : IconButton(
                                                  icon: const Icon(Icons.cancel),
                                                  color: Colors.red,
                                                  iconSize: 40,
                                                  onPressed: () {
                                                  cancelFriendRequest(context, request.id, request.receiver_username);
                                                  },
                                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No data'));
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyConvexAppBar(
        currentPage: 2,
        onTap: (int index) {
         
        },
      ),
    );
  }
}
