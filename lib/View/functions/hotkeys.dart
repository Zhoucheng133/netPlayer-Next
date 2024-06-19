import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:net_player_next/View/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';

class HotkeyHandler{

  final Controller c = Get.put(Controller());

  Future<void> globalToggle() async {
    HotKey gToggleKey = HotKey(
      KeyCode.space,
      modifiers: [KeyModifier.control, KeyModifier.alt],
      scope: HotKeyScope.system,
    );
    await hotKeyManager.register(
      gToggleKey,
      keyDownHandler: (hotkey){
        Operations().toggleSong();
      }
    );
  }

  Future<void> globalSkipPre() async {
    HotKey gSkipNextKey = HotKey(
      KeyCode.arrowLeft,
      modifiers: [KeyModifier.control, KeyModifier.alt],
      scope: HotKeyScope.system,
    );
    await hotKeyManager.register(
      gSkipNextKey,
      keyDownHandler: (hotkey){
        Operations().skipPre();
      }
    );
  }

  Future<void> globalSkipNext() async {
    HotKey gSkipNextKey = HotKey(
      KeyCode.arrowRight,
      modifiers: [KeyModifier.control, KeyModifier.alt],
      scope: HotKeyScope.system,
    );
    await hotKeyManager.register(
      gSkipNextKey,
      keyDownHandler: (hotkey){
        Operations().skipNext();
      }
    );
  }

  Future<void> toggleHandler() async {
    HotKey toggleKey = HotKey(
      KeyCode.space,
      scope: HotKeyScope.inapp,
    );
    await hotKeyManager.register(
      toggleKey,
      keyDownHandler: (hotkey){
        if(!c.onInput.value){
          Operations().toggleSong();
        }
      }
    );
  }
  
  Future<void> skipNextHandler() async {
    HotKey skipNextKey = HotKey(
      KeyCode.arrowRight,
      modifiers: Platform.isMacOS ? [KeyModifier.meta] : [KeyModifier.control],
      scope: HotKeyScope.inapp,
    );
    await hotKeyManager.register(
      skipNextKey,
      keyDownHandler: (hotkey){
        Operations().skipNext();
      }
    );
  }

  Future<void> skipPreHandler() async {
    HotKey skipNextKey = HotKey(
      KeyCode.arrowLeft,
      modifiers: Platform.isMacOS ? [KeyModifier.meta] : [KeyModifier.control],
      scope: HotKeyScope.inapp,
    );
    await hotKeyManager.register(
      skipNextKey,
      keyDownHandler: (hotkey){
        Operations().skipPre();
      }
    );
  }

  Future<void> toggleLyric(BuildContext context) async {
    HotKey skipNextKey = HotKey(
      KeyCode.keyL,
      modifiers: Platform.isMacOS ? [KeyModifier.meta] : [KeyModifier.control],
      scope: HotKeyScope.inapp,
    );
    await hotKeyManager.register(
      skipNextKey,
      keyDownHandler: (hotkey){
        Operations().toggleLyric(context);
      }
    );
  }
}