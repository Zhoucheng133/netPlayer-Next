// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:net_player_next/variables/song_controller.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:net_player_next/views/functions/operations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
// ignore: depend_on_referenced_packages
import 'package:web_socket_channel/web_socket_channel.dart';

class WsService {
  HttpServer? _server;
  final List<WebSocketChannel> _clients = [];
  final Controller c = Get.find();
  Operations operations=Operations();
  final SongController songController=Get.find();

  void sendMsg(String content) {
    for (var client in _clients) {
      client.sink.add(
        jsonEncode({
          'title': songController.nowPlay.value.title,
          'artist': songController.nowPlay.value.artist,
          'lyric': content,
          'cover': "${c.userInfo["url"]}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${songController.nowPlay.value.id}",
          'fullLyric': c.lyric.map((item)=>item.toJson()).toList(),
          'line': c.lyricLine.value,
          'isPlay': c.isPlay.value,
          'mode': c.playMode.value,
        })
      );
    }
  }

  void closeKit(){
    for (var client in _clients) {
      client.sink.add(
        jsonEncode({
          'command': 'close',
        })
      );
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

  Future<void> commandHandler(Map msg) async {
    if (msg.isEmpty) {
      return;
    }

    switch (msg['command']) {
      case 'pause':
        operations.pause();
        break;
      case 'play':
        operations.play();
        break;
      case 'skip':
        operations.skipNext();
        break;
      case 'forw':
        operations.skipPre();
        break;
      case 'get':
        try {
          var content = c.lyric[c.lyricLine.value - 1].lyric;
          c.ws.sendMsg(content);
        } catch (e) {
          if (c.lyric.length == 1) {
            var content = c.lyric[0].lyric;
            sendMsg(content);
          }else{
            sendMsg("");
          }
        }
        break;
      case 'mode':
        if(msg['data']=='list' || msg['data']=='repeat' || msg['data']=='random'){
          if(c.fullRandom.value){
            return;
          }else{
            c.playMode.value=msg['data'];
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('playMode', msg['data']);
          }
        }
      case 'seek':
        if(msg['data']!=null && msg['data'] is int){
          if(Duration(milliseconds: msg['data'])>Duration(seconds: songController.nowPlay.value.duration)){
            return;
          }
          operations.seek(Duration(milliseconds: msg['data']));
        }
      case 'miniClose':
        c.useLyricKit.value=false;
      default:
        break;
    }
  }

  Future<void> initService(int port) async {
    var handler = webSocketHandler((WebSocketChannel webSocket) {
      _clients.add(webSocket);
      webSocket.stream.listen(
        (message) {
          try {
            commandHandler(json.decode(message));
          } catch (_) {}

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

    try {
      _server = await io.serve(pipeline, '0.0.0.0', port);
    } catch (_) {
      c.wsOk.value=false;
    }
  }

  WsService(int port) {
    initService(port);
  }
}