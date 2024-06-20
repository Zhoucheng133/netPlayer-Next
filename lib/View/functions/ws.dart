// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:get/get.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
// ignore: depend_on_referenced_packages
import 'package:web_socket_channel/web_socket_channel.dart';

class WsService {
  HttpServer? _server;
  final List<WebSocketChannel> _clients = [];
  final Controller c = Get.put(Controller());

  void sendMsg(String content) {
    for (var client in _clients) {
      client.sink.add('${c.nowPlay['title']}\n${c.nowPlay['artist']}\n$content');
    }
  }

  Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
    for (var client in _clients) {
      await client.sink.close();
    }
    _clients.clear();
  }

  Future<void> initService() async {
    var handler = webSocketHandler((WebSocketChannel webSocket) {
      _clients.add(webSocket);
      webSocket.stream.listen(
        (message) {
          // 接受消息
        },
        onDone: () {
          _clients.remove(webSocket);
        },
        onError: (error) {
          _clients.remove(webSocket);
        },
      );
    });

    var pipeline = const Pipeline()
        .addMiddleware(logRequests())
        .addHandler(handler);

    _server = await io.serve(pipeline, '0.0.0.0', 9098);
    // print('Server running');
  }

  WsService() {
    initService();
  }
}