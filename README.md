# netPlayer Next版本

## 简介

<img src="assets/icon.png" width="100px">

**★ netPlayer Next** | [**netPlayer**](https://github.com/Zhoucheng133/net-player) | [**netPlayer Mobile**](https://github.com/Zhoucheng133/netPlayer-Mobile)

**注意，这是[netPlayer](https://github.com/Zhoucheng133/net-player)的Flutter版本，正在测试中 【搁置状态，Windows电脑出了点问题( ´•︵•\` )  】**  
版本号在标准版netPlayer之后，这个版本的netPlayer版本号从`2.0.0`开始

这个版本的netPlayer (Next)不支持在Windows系统上隐藏到任务栏，如果对该功能有需求建议下载[1.5.0](https://github.com/Zhoucheng133/net-player/releases/tag/v1.5.0)版本

## 在你的设备上配置netPlayer Next

**注意，由于Flutter的macOS和Windows中有一些依赖代码有区分，本项目默认使用的是macOS的代码**  
一些存在代码无法双向兼容的依赖:
- **`window_manager`**，在macOS上会出现打开App无法聚焦窗口的问题<sup>\*</sup>，因此在macOS上使用 **`bitsdojo_window`**，另外新版本的`Flutter`使用`bitsdojo_window`在macOS系统上会出现无法显示窗口的问题<sup>\*</sup>，因此本项目使用旧版的`Flutter`
- **`just_audio`**，在Windows上使用 **`just_audio_windows`**（非官方的just_audio Windows支持版本）前者没有问题，后者极大概率会出现加载完成歌曲无法播放的问题，并且很大概率出现回调函数重复重复执行的问题
- **`audioplayers`**，理论上支持macOS和Windows，但是不知道为什么在我的Windows设备上无法添加该依赖
- **`Flutter^3.9`** 以后版本的 **`Flutter`** ，在 macOS系统可能出现黑屏闪烁的问题，Windows版本不存在这样的问题

<sup>*</sup>该问题已向作者反馈

## 更新日志

### 2.0.1 (开发中)
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