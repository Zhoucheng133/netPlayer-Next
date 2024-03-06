# netPlayer Next版本

## 简介

<img src="assets/icon.png" width="100px">

**★ netPlayer Next** | [**netPlayer**](https://github.com/Zhoucheng133/net-player) | [**netPlayer Mobile**](https://github.com/Zhoucheng133/netPlayer-Mobile)

**注意，这是[netPlayer](https://github.com/Zhoucheng133/net-player)的Flutter版本**  
版本号在标准版netPlayer之后，这个版本的netPlayer版本号从`2.0.0`开始

这个版本的netPlayer (Next)不支持在Windows系统上隐藏到任务栏，如果对该功能有需求建议下载[1.5.0](https://github.com/Zhoucheng133/net-player/releases/tag/v1.5.0)版本

## 截图
<img src="./demo/demo1.png" height="400px"/>

**点击歌曲封面可以查看歌词**

<img src="./demo/demo2.png" height="400px"/>


## 在你的设备上配置netPlayer Next

本项目使用lutter^3.19开发，你可以直接使用这个版本的Flutter在你的设备上Debug  
建议直接使用Visual Studio Code，在安装完Flutter扩展和Dart扩展之后就可以Debug/Profile/Release了，我已经在.vscode文件夹中添加了launch类型

不要使用Flutter3.7或更低版本的Flutter，确保Dart版本至少有3.0.0

## 更新日志

### 2.0.3
- 修复歌词滚动问题
- 修复macOS语言问题

### 2.0.2 (2024/3/6)
- 统一Windows和macOS一些组件
- 修复运行在Windows系统上稳定性的问题
- 修复进度条崩溃的问题
- 提高了程序运行效率

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