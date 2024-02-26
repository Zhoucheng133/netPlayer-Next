# netPlayer Next版本

## 简介

<img src="assets/icon.png" width="100px">

**★ netPlayer Next** | [**netPlayer**](https://github.com/Zhoucheng133/net-player) | [**netPlayer Mobile**](https://github.com/Zhoucheng133/netPlayer-Mobile)

**注意，这是[netPlayer](https://github.com/Zhoucheng133/net-player)的Flutter版本**  
版本号在标准版netPlayer之后，这个版本的netPlayer版本号从`2.0.0`开始

这个版本的netPlayer (Next)不支持在Windows系统上隐藏到任务栏，如果对该功能有需求建议下载[1.5.0](https://github.com/Zhoucheng133/net-player/releases/tag/v1.5.0)版本

## 在你的设备上配置netPlayer Next

**注意，由于Flutter的macOS和Windows中有一些依赖代码有区分，本项目默认使用的是macOS的代码**  
一些存在代码无法双向兼容的依赖:

- **`just_audio`**，在Windows上使用`just_audio_windows`（非官方的just_audio Windows支持版本）前者没有问题，后者极大概率会出现加载完成歌曲无法播放的问题，并且很大概率出现回调函数重复重复执行的问题

- **`Flutter^3.9`** 以后版本的 **`Flutter`** ，在 macOS系统可能出现黑屏闪烁的问题，`Windows`版本未知

对于需要在Windows设备上配置运行，将`lib/functions/audio_windows.dart`文件替换`lib/functions/audio.dart`文件（也就是说将前者文件内容覆盖后者文件内容）

## 更新日志

### 2.0.0 Beta (2024/2/26)
- 使用Flutter重构了整个项目
- 添加单曲循环播放模式
- 添加记住播放模式功能
- 添加了歌曲项中右键菜单
- 改进歌曲显示的布局
- 改进滚动到播放歌曲
- 🚫全局功能暂时无法使用
- 🚫检查更新功能暂时无法使用
- 🚫Windows版隐藏到状态栏暂时无法使用

## 一些API

[Subsonic API](http://www.subsonic.org/pages/api.jsp)

[lrclib API](https://lrclib.net/docs)