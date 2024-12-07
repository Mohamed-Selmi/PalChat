import 'package:flutter/material.dart';
import 'package:pfeapp/models/websocket_connect.Dart';

class ChatRoomView extends StatefulWidget {
  const ChatRoomView({super.key});

  @override
  _ChatRoomViewState createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  late WebSocketManager _webSocketManager;
  final TextEditingController _messageController = TextEditingController();
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _webSocketManager = WebSocketManager('ws://192.168.1.3:8000/chat/ws/chat/lobby/');
    _webSocketManager.connect();
    _webSocketManager.onDataReceived((data) {
      // Handle incoming data here, such as updating the UI with new messages
      print('Received: $data');
    });
    _isConnected = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Room'),
      ),
      body: Column(
        children: [
          const Expanded(
            child: Center(
              // Widget to display chat messages
              child: Text('Chat Messages Here'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final message = _messageController.text;
                    if (message.isNotEmpty) {
                      _webSocketManager.sendData(message);
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _isConnected ? null : _connectWebSocket,
                child: const Text('Connect'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _isConnected ? _disconnectWebSocket : null,
                child: const Text('Disconnect'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _connectWebSocket() {
    _webSocketManager.connect();
    setState(() {
      _isConnected = true;
    });
  }

  void _disconnectWebSocket() {
    _webSocketManager.close();
    setState(() {
      _isConnected = false;
    });
  }

  @override
  void dispose() {
    _webSocketManager.close();
    super.dispose();
  }
}
