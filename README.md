# netPlayer Next版本

## 简介

<img src="assets/icon.png" width="100px">

**★ netPlayer Next** | [**netPlayer**](https://github.com/Zhoucheng133/net-player) | [**netPlayer Mobile**](https://github.com/Zhoucheng133/netPlayer-Mobile)

**注意，这是[netPlayer](https://github.com/Zhoucheng133/net-player)的Flutter版本**  
版本号在标准版netPlayer之后，这个版本的netPlayer版本号从`2.0.0`开始

这个版本的netPlayer (Next)不支持在Windows系统上隐藏到任务栏，如果对该功能有需求建议下载[1.5.0](https://github.com/Zhoucheng133/net-player/releases/tag/v1.5.0)版本

## 在你的设备上配置netPlayer Next

**注意，由于Flutter的macOS和Windows中有一些依赖代码有区分，详细如下**

- 窗口管理功能，在Widnows上使用的是`window_manager`依赖，在macOS系统上会出现无法聚焦到窗口的问题<sup>*</sup>，因此替换为`bitsdojo_window`，后者在Windows上有概率会出现白屏的情况
- 音频播放，在Windows上使用的是`just_audio_windows`，在macOS系统上使用的是`just_audio`，前者极大概率会出现加载完成歌曲无法播放的问题，并且很大概率出现回调函数重复重复执行的问题，在本项目中使用特定代码避免了这些问题

<sup>*</sup>该问题已向作者反馈

**不过无论你使用的是什么系统，均可直接使用`Fluter^3.7`直接在你的设备上编译运行**

另注：
> 如果你有`Flutter`开发经验，并且主力设备是**Windows系统**，允许的话可以帮测试一下`Flutter3.7`使用`audioplayers`或者`mediakit`是否可以在Windows系统上编译运行，我使用虚拟机在macOS系统上使用这两个依赖无法正确运行

## 更新日志

### 2.0.1 (2024/2/28)
- 恢复全局搜索功能
- 恢复检查更新功能
- 恢复歌词显示功能
- 修复窗口没有聚焦的问题
- 修复播放栏信息显示问题
- 修复播放栏封面图片圆角问题
- 修复定位图标是否可用没有区分的问题
- 修复Windows上窗口按钮图标错误的问题

### 2.0.0 Beta (2024/2/26)
- 使用Flutter重构了整个项目
- 添加单曲循环播放模式
- 添加记住播放模式功能
- 添加了歌曲项中右键菜单
- 改进歌曲显示的布局
- 改进滚动到播放歌曲
- 🚫全局搜索功能暂时无法使用
- 🚫检查更新功能暂时无法使用
- 🚫Windows版隐藏到状态栏暂时无法使用
- 🚫歌词功能暂时无法使用

## 一些API

[Subsonic API](http://www.subsonic.org/pages/api.jsp)

[lrclib API](https://lrclib.net/docs)