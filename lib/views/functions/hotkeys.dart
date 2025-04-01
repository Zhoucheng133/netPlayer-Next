import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:net_player_next/views/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';

class HotkeyHandler{

  final Controller c = Get.find();
  final operations=Operations();

  Future<void> globalToggle() async {
    HotKey gToggleKey = HotKey(
      KeyCode.space,
      modifiers: [KeyModifier.control, KeyModifier.alt],
      scope: HotKeyScope.system,
    );
    await hotKeyManager.register(
      gToggleKey,
      keyDownHandler: (hotkey){
        operations.toggleSong();
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
        operations.skipPre();
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
        operations.skipNext();
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
          operations.toggleSong();
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
        operations.skipNext();
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
        operations.skipPre();
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
        operations.toggleLyric(context);
      }
    );
  }
}