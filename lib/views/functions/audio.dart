import 'dart:io';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:net_player_next/variables/song_controller.dart';
import 'package:net_player_next/views/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:smtc_windows/smtc_windows.dart';

class MainAudioHanlder extends BaseAudioHandler with QueueHandler, SeekHandler {

  final Controller c = Get.find();
  final SongController songController=Get.find();
  final player = Player();
  var playURL="";
  bool skipHandler=false;
  MediaItem item=const MediaItem(id: "", title: "");
  final operations=Operations();

  bool isSettingUrl = false;

  MainAudioHanlder(){
    player.stream.position.listen((position) {
      var data=position.inMilliseconds;
      if(!c.onslide.value){
        c.playProgress.value=data;
      }
      if(c.lyric.isNotEmpty && c.lyric.length!=1){
        for (var i = 0; i < c.lyric.length; i++) {
          if(i==c.lyric.length-1){
            c.lyricLine.value=c.lyric.length;
            break;
          }else if(i==0 && data<c.lyric[i].time){
            c.lyricLine.value=0;
            break;
          }else if(data>=c.lyric[i].time && data<c.lyric[i+1].time){
            c.lyricLine.value=i+1;
            break;
          }
        }
      }else if(c.lyric.length==1){
        // updateLyricLine(0);
        c.lyricLine.value=0;
      }
    });
    player.stream.completed.listen((state) {
      if(state){
        skipToNext();
      }
    });
    player.stream.error.listen((error) {
      skipToNext();
    });
  }

  void setMedia(bool isPlay){
    if(Platform.isWindows && c.smtc!=null){
      c.smtc?.updateMetadata(
        MusicMetadata(
          title: songController.nowPlay.value.title,
          album: songController.nowPlay.value.album,
          albumArtist: songController.nowPlay.value.artist,
          artist: songController.nowPlay.value.artist,
          thumbnail: "${c.userInfo.value.url}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo.value.username}&t=${c.userInfo.value.token}&s=${c.userInfo.value.salt}&id=${songController.nowPlay.value.id}"
        ),
      );
      c.smtc?.setPlaybackStatus(isPlay ? PlaybackStatus.Playing : PlaybackStatus.Paused);
    }
    item=MediaItem(
      id: songController.nowPlay.value.id,
      title: songController.nowPlay.value.title,
      artist: songController.nowPlay.value.artist,
      artUri: Uri.parse("${c.userInfo.value.url}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo.value.username}&t=${c.userInfo.value.token}&s=${c.userInfo.value.salt}&id=${songController.nowPlay.value.id}"),
      album: songController.nowPlay.value.album,
      duration: Duration(seconds: songController.nowPlay.value.duration),
    );
    mediaItem.add(item);

    playbackState.add(PlaybackState(
      playing: isPlay,
      controls: [
        MediaControl.skipToPrevious,
        isPlay ? MediaControl.pause : MediaControl.play,
        MediaControl.skipToNext,
      ],
      updatePosition: Duration(milliseconds: c.playProgress.value),
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
    ));
  }

  // 播放
  @override
  Future<void> play() async {
    var url="${c.userInfo.value.url}/rest/stream?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo.value.username}&t=${c.userInfo.value.token}&s=${c.userInfo.value.salt}&id=${songController.nowPlay.value.id}";
    if(url!=playURL || skipHandler){
      final media=Media(url);
      await player.open(media);
    }
    await player.play();
    c.isPlay.value=true;
    if(skipHandler){
      skipHandler=false;
    }
    playURL=url;
    setMedia(true);
  }

  // 暂停
  @override
  Future<void> pause() async {
    await player.pause();
    setMedia(false);
    c.isPlay.value=false;
  }

  // 停止播放
  @override
  Future<void> stop() async {
    c.isPlay.value=false;
    await player.stop();
  }

  // 跳转
  @override
  Future<void> seek(Duration position) async {
    c.onslide.value=true;
    await player.pause();
    await player.seek(position);
    setMedia(true);
    c.onslide.value=false;
    play();
  }

  int preHandler(int index, int length){
    if(index==0){
      return length-1;
    }
    return index-1;
  }

  // 上一首
  @override
  Future<void> skipToPrevious() async {

    if (isSettingUrl) return;
    isSettingUrl = true;

    if(c.fullRandom.value){
      operations.fullRandomPlay();
      return;
    }
    var tmpList=songController.nowPlay.value;
    tmpList.index=preHandler(songController.nowPlay.value.index, songController.nowPlay.value.list.length);
    tmpList.id=tmpList.list[tmpList.index].id;
    tmpList.title=tmpList.list[tmpList.index].title;
    tmpList.artist=tmpList.list[tmpList.index].artist;
    tmpList.duration=tmpList.list[tmpList.index].duration;
    tmpList.album=tmpList.list[tmpList.index].album;
    // c.nowPlay.value=tmpList;
    // c.updateNowPlay(tmpList);
    songController.nowPlay.value=tmpList;
    songController.nowPlay.refresh();
    skipHandler=true;
    await play();
    setMedia(true);

    isSettingUrl = false;
  }

  int nextHandler(int index, int length){
    if(c.playMode.value=='list'){
      if(index==length-1){
        return 0;
      }
      return index+1;
    }else if(c.playMode.value=='random'){
      if(length==1){
        return 0;
      }
      Random random =Random();
      return random.nextInt(length-1);
    }else{
      return index;
    }
    
  }

  // 下一首
  @override
  Future<void> skipToNext() async {

    if (isSettingUrl) return;
    isSettingUrl = true;

    if(c.fullRandom.value){
      operations.fullRandomPlay();
      return;
    }
    NowPlay tmpList=songController.nowPlay.value;
    tmpList.index=nextHandler(songController.nowPlay.value.index, songController.nowPlay.value.list.length);
    tmpList.id=tmpList.list[tmpList.index].id;
    tmpList.title=tmpList.list[tmpList.index].title;
    tmpList.artist=tmpList.list[tmpList.index].artist;
    tmpList.duration=tmpList.list[tmpList.index].duration;
    tmpList.album=tmpList.list[tmpList.index].album;
    // c.updateNowPlay(tmpList);
    songController.nowPlay.value=tmpList;
    songController.nowPlay.refresh();
    skipHandler=true;
    await play();
    setMedia(true);

    isSettingUrl = false;
  }

  Future<void> volumeSet(val) async {
    await player.setVolume(val.toDouble());
  }
}