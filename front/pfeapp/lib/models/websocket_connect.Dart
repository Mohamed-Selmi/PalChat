import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManager {
  final String _webSocketUrl;
  late WebSocketChannel _channel;
  late Stream<dynamic> _stream;
  Function(dynamic)? _onDataReceived;

  WebSocketManager(this._webSocketUrl);

  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse(_webSocketUrl));
    _stream = _channel.stream;
    _stream.listen((data) {
      if (_onDataReceived != null) {
        _onDataReceived!(data);
      }
    });
  }

  void sendData(dynamic data) {
    _channel.sink.add(data);
  }

  void onDataReceived(Function(dynamic) onData) {
    _onDataReceived = onData;
  }

  void close() {
    _channel.sink.close();
  }
}
