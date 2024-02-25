# netPlayer Next版本

## 简介

<img src="assets/icon.png" width="100px">

**注意，这是[netPlayer](https://github.com/Zhoucheng133/net-player)的Flutter版本**  
版本号在标准版netPlayer之后，这个版本的netPlayer版本号从`2.0.0`开始

这个版本的netPlayer (Next)不支持在Windows系统上隐藏到任务栏，如果对该功能有需求建议下载[1.5.0](https://github.com/Zhoucheng133/net-player/releases/tag/v1.5.0)版本

## 在你的设备上配置netPlayer Next

**注意，由于Flutter的macOS和Windows中有一些依赖代码有区分，本项目默认使用的是macOS的代码**  
一些存在代码无法双向兼容的依赖:
- **`bitsdojo_window`**，在Windows上使用的是`window_manager`，前者在Windows上有概率白屏或者黑屏，后者在macOS系统上窗口会黑屏闪烁（可能是`Flutter`的问题）
- **`just_audio`**，在Windows上使用`just_audio_windows`（非官方的just_audio Windows支持版本）前者没有问题，后者极大概率会出现加载完成歌曲无法播放的问题，并且很大概率出现回调函数重复重复执行的问题

另：**`Flutter^3.9`** 或者更新的版本 **`Flutter`** 在 macOS系统会出现黑屏闪烁的问题，`Windows`版本未知

对于需要在Windows设备上配置运行，可以参考下面的修改操作：

```dart
// lib/main.dart

```

```dart
// lib/functions/audio.dart

final Controller c = Get.put(Controller());
final player = AudioPlayer();
var playUrl="";

+ Timer? _debounce;

audioHandler(){
  // ...
  player.playerStateStream.listen((state) {
    - skipToNext();
    + if(state.processingState == ProcessingState.completed) {
    +    if (_debounce?.isActive ?? false) {
    +     _debounce?.cancel();
    +   }
    +   _debounce = Timer(const Duration(milliseconds: 50), () {
    +     skipToNext();
    +   });
    + }
  });
}

// ...

// 播放
@override
Future<void> play() async {
  // ...
  player.play();
  playUrl=url;
  c.updateIsPlay(true);
  setInfo(true);
  + if(!player.playing){
  +   play();
  + }
}

// ...

// 上一首
@override
Future<void> skipToPrevious() async {
  + await pause();
  // ...
}

@override
Future<void> skipToNext() async {
  + await pause();
  // ...
}
```

## 更新日志

## 一些API

[Subsonic API](http://www.subsonic.org/pages/api.jsp)

[lrclib API](https://lrclib.net/docs)