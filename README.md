# netPlayer Next版本

Also available  in English. Click [HERE](/documents/en.md) to see document of English version

## 简介

<img src="assets/icon.png" width="100px">

![Flutter](https://img.shields.io/badge/Flutter-3.19-blue?logo=Flutter)
![media_kit](https://img.shields.io/badge/media_kit-1.1.10-yellow)
![audioservice](https://img.shields.io/badge/audio_service-0.18.12-green)
![crypto](https://img.shields.io/badge/crypto-3.0.3-lightblue)
![flash](https://img.shields.io/badge/flash-3.1.0-lightyellow)
![flutter_launcher_icons](https://img.shields.io/badge/flutter_launcher_icons-0.13.1-purple)
![get](https://img.shields.io/badge/get-4.6.6-red)
![hotkey_manager](https://img.shields.io/badge/hotkey_manager-0.2.0-white)
![http](https://img.shields.io/badge/http-1.2.1-orange)
![package_info_plus](https://img.shields.io/badge/package_info_plus-4.2.0-pink)
![scroll_to_index](https://img.shields.io/badge/scroll_to_index-3.0.1-green)
![shared_preferences](https://img.shields.io/badge/shared_preferences-2.2.2-lightgreen)
![url_launcher](https://img.shields.io/badge/url_launcher-6.2.5-lightblue)
![window_manager](https://img.shields.io/badge/window_manager-0.3.8-darkgreen)
![path_provider](https://img.shields.io/badge/path_provider-2.1.2-orange)
![google_fonts](https://img.shields.io/badge/google_fonts-6.2.1-blue)
![font_awesome_flutter](https://img.shields.io/badge/font_awesome_flutter-10.7.0-green)
![flutter_popup](https://img.shields.io/badge/flutter_popup-3.3.0-lightblue)
![shelf](https://img.shields.io/badge/shelf-1.4.1-lightyellow)
![shelf_web_socket](https://img.shields.io/badge/shelf_web_socket-1.0.2-purple)
![flutter_rust_bridge](https://img.shields.io/badge/flutter_rust_bridge-1.72.1-red)
![smtc_windows](https://img.shields.io/badge/smtc_windows-0.1.2-white)
![dropdown_button2](https://img.shields.io/badge/dropdown_button2-2.3.9-orange)
![loading_animation_widget](https://img.shields.io/badge/loading_animation_widget-1.2.1-pink)
![auto_size_text](https://img.shields.io/badge/auto_size_text-3.0.0-green)

![License](https://img.shields.io/badge/License-MIT-dark_green)

**★ netPlayer Next** | [**netPlayer**](https://github.com/Zhoucheng133/net-player) | [**netPlayer Mobile**](https://github.com/Zhoucheng133/netPlayer-Mobile)

**注意，这是[netPlayer](https://github.com/Zhoucheng133/net-player)的Flutter版本**  
本仓库发布的netPlayer版本号从`2.0.0`开始

**这个版本的netPlayer不兼容Windows 7系统，如果你要查找支持Windows 7版本的netPlayer，转至[netPlayer](https://github.com/Zhoucheng133/net-player)查找v1版本的netPlayer**

||v1|v2|v3|
|-|-|-|-|
|支持Windows版本|Windows7~|Windows10~|Windows10~|
|框架|Electron|Flutter|Flutter
|支持macOS|✅|✅|✅*|
|单曲循环|❌|✅|✅|
|定位歌曲|❌|✅|✅|
|全局快捷键|仅macOS|✅|✅|
|WebSocket服务|❌|❌|✅|
|多语言支持|❌|❌|✅**|

\* 由于本人换电脑，macOS没法打包，如果你有需要可以在自己的设备上打包v3版本(所以也不清楚macOS版本的运行情况，欢迎给予反馈!)

\*\* 从 **v3.2.0** 版本开始支持多语言，你[**点击这里**](#多语言支持)查看详细的语言支持

## 快捷键

### App内快捷键
- `空格`：播放/暂停
- `command →`(macOS)或`Ctrl →`(Windows)：下一首
- `command ←`(macOS)或`Ctrl ←`(Windows)：上一首
- `command L`(macOS)或`Ctrl L`(Windows)：显示/隐藏歌词

### 全局快捷键
- ⏯️(macOS & Windows)或`Ctrl Alt 空格`(Windows)：播放/暂停
- ⏩(macOS & Windows)或`Ctrl Alt →`(Windows)：下一首
- ⏪(macOS & Windows)或`Ctrl Alt ←`(Windows)：上一首

## 截图

![截图1](demo/demo1.png)

![截图2](demo/demo2.png)

## 多语言支持

- 简体中文
- 繁体中文 (由ChatGPT翻译)
- 英语

你可以通过pull&request添加你所需要的语言。语言目录位于`lib/lang`

如果有一些翻译不那么准确，你可以添加一个Issue

## WebSocket服务

**这个功能至少需要v3.0.0**

在**设置**中启用ws服务之后，netPlayer将会作为一个本地的WebSocket服务器，在播放歌曲更新/歌词更新的时候向客户端发送消息，消息的内容格式为
```json
{
  "title": <标题>,
  "artist": <艺人>,
  "lyric": <歌词>
}
```

WebSocket服务器默认地址为: `localhost:9098`

这个功能可以二次开发，用于直播背景音乐信息显示，详细步骤如下：
1. 设计一个Web页面用于直播（边框）
2. 在你觉得合适的地方设计一个背景音乐信息显示，内容为WebSocket服务获取的信息

## 常见问题
1. 无法连接到音乐服务器:
   ```
   你需要先检查你的客户端设备是否可以直接打开音乐库网页，很大概率是服务器防火墙或者设置问题
   另外务必检查地址，http和https
   ```
2. 所有歌曲显示不全: 
   ```
   Subsonic音乐库的API并不支持查看所有的歌曲，因此至多只能显示500首歌曲
   但是你可以通过完全随机播放来随机播放所有的歌曲，不受歌曲数量显示，v2版本在左边栏，v3版本在所有歌曲页标题右侧
   ```
3. 打开页面灰色方块或者崩溃不显示内容:
   ```
   有两种
   【第一种】可能因为Subsonic(Navidrome)需要通过你的音乐文件来获取音乐信息
   因此如果你的音乐文件不包含下面的信息(之一)，可能会导致本软件无法正常使用
   1. 歌曲的标题
   2. 歌曲的艺术家(艺人)
   3. 歌曲长度
   4. 所属专辑(唱片集)
   音乐文件是否附带专辑封面不会影响程序运行
   【第二种】老版本的netPlayer Next和新版本冲突
   解决办法为删除这两个目录:
   C:\Users\<你的用户名>\AppData\Roaming\zhouc\net_player_next
   C:\Users\<你的用户名>\AppData\Roaming\zhouc\netPlayer
   ```
4. 没有找到歌词:
   ```
   歌词API见文末，没有找到歌词就是字面意思
   歌词的内容取决于歌曲标题、所属专辑、艺人和歌曲长度
   ```
   

## 其它链接

- [spotify-downloader](https://github.com/spotDL/spotify-downloader)用于下载歌曲，通过这种方式下载的歌曲一般会包含一些信息
- [Live-BG](https://github.com/Zhoucheng133/Live-BG)本人开发的用于直播的配合netPlayer显示当前播放歌曲信息和歌词的背景

## 在你的设备上配置netPlayer Next

本项目使用Flutter^3.22开发，你可以直接使用这个版本的Flutter在你的设备上Debug  
建议直接使用Visual Studio Code，在安装完Flutter扩展和Dart扩展之后就可以Debug/Profile/Release了，我已经在.vscode文件夹中添加了launch类型

不要使用Flutter3.7或更低版本的Flutter，确保Dart版本至少有3.0.0

如果你在**Windows**上Debug或者Release，注意不要在国内的网络环境下操作，可能会等非常长的时间，Mac上没有这个问题

在Windows上的打包：
```bash
flutter build windows
```

在macOS上打包：
```bash
flutter build macos
```

Linux没有测试过，各位可以自行尝试

## 更新日志

### 3.2.5
- 添加ws服务控制播放的功能
- 修复停止播放时候播放状态错误的问题
- 修复一些没有销毁的监听器

<details>
<summary>过去的版本</summary>

### 3.2.4 (2024/9/19)
- 添加重命名hint
- 添加自动识别语言
- 添加从歌词页获取艺人/专辑信息
- 修复ws服务关闭异常的问题

### 3.2.3 (2024/8/30)
- 添加从网易云音乐获取歌词
- 修复歌单名称过长的显示问题
- 修复获取歌词可能出现崩溃的问题

### 3.2.2 (2024/8/29)
- 修复翻译缺失
- 修复进度条闪烁的问题
- 提高了一些性能
- 改进一些英文翻译

### 3.2.1 (2024/8/6)
- 修复一个弹窗问题
- 修复注销出错的问题

### 3.2.0 (2024/8/4)
- 添加多语言支持
- 修复一些提示的错误文本
- 改进一些动画

### 3.1.5 (2024/7/30)
- 解决Windows下图标模糊的问题

### 3.1.4 (2024/7/29)
- 添加刷新音乐库的功能

### 3.1.3 (2024/7/25)
- 添加一些鼠标移动到图标的提示
- 添加歌曲超出API范围的提示
- 添加本地化支持
- 修复当没有喜欢的歌曲时加载错误

### 3.1.2 (2024/7/21)
- 添加了可以自定义ws服务端口的功能
- 添加了ws服务端口冲突的提示
- 解决了在连接服务器失败卡住的问题
- 解决了ws服务端口冲突崩溃的问题

### 3.1.1 (2024/7/2)
- 解决错误的用户名或者密码登录崩溃的问题

### 3.1.0 (2024/6/28)
- 添加从歌曲跳转到艺人和专辑的菜单
- 添加了Windows的音频控制模块，现在你可以使用Windows上的音频控制了

原有的全局快捷键也可以一样使用

### 3.0.2 (2024/6/25)
- 修复在输入框输入空格触发快捷键的问题

### 3.0.1 (2024/6/21)
- 隐藏了一些无效按钮
- 搜索框自动清空结果

### 3.0.0 (2024/6/20)
- 重构了整个软件，现在看起来更加美观
- 大幅提高了运行效率
- 添加了ws服务功能
- 添加了音量调节功能
- 添加了歌曲界面艺人显示
- 现在搜索不区分大小写了
- 改进了搜索逻辑
- 修复软件信息在Windows下的显示问题
- 修复歌单为0时添加歌单崩溃的问题
- 修复歌单发生变化时的定位问题

### 2.0.7 (2024/5/12) 【仅对Windows版本的更新】
- 添加全局快捷键
- 添加是否添加全局快捷键的开关

### 2.0.6 (2024/3/28)
- 添加显示/隐藏歌词的快捷键
- 添加Windows上切换歌曲的快捷键
- 修复macOS系统上点击菜单无效的问题

### 2.0.5 (2024/3/18)
- 添加了托盘功能和Windows上的关闭隐藏窗口的功能
- 修复没有登录时歌曲操作的问题

### 2.0.4 (补充更新) (2024/3/10)
- 添加清理封面图片缓存的功能(macOS系统)
- 添加在Windows上Debug的配置开发条件

### 2.0.4 (2024/3/9)
- ~~现在可以复制一些文本~~
- 修复没有进入歌词第一句时的滚动状态问题
- 修复无法在文本框输入空格的问题
- 本地化一些系统控件语言

### 2.0.3 (2024/3/7)
- 修复歌词滚动问题
- 修复macOS语言问题
- 修复macOS从菜单切换页面的问题

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
</details>

## 一些API

[Subsonic API](http://www.subsonic.org/pages/api.jsp)

[lrclib API](https://lrclib.net/docs)

网易云音乐