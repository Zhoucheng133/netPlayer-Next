import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

// 显示悬浮歌词
// [lyric] 歌词
// [opacity] 透明度(double 0~100)
// [fontsize] 字体大小
// [r] 红色分量
// [g] 绿色分量
// [b] 蓝色分量
typedef ShowFloatLyricDart = void Function(Pointer<Utf8> lyric, double opacity, int fontsize, int r, int g, int b);
typedef ShowFloatLyric = Void Function(Pointer<Utf8> lyric, Double opacity, Int fontsize, Int r, Int g, Int b);

// 隐藏悬浮歌词
typedef HideFloatLyricDart = void Function();
typedef HideFloatLyric = Void Function();

// 更新歌词
// [lyric] 歌词
typedef UpdateLyricDart = void Function(Pointer<Utf8> lyric);
typedef UpdateLyric = Void Function(Pointer<Utf8> lyric);

// 更新透明度
// [opacity] 透明度
typedef UpdateOpacityDart = void Function(double opacity);
typedef UpdateOpacity = Void Function(Double opacity);

// 更新字体大小
// [fontsize] 字体大小
typedef UpdateFontSizeDart = void Function(int fontsize);
typedef UpdateFontSize = Void Function(Int fontsize);

// 更新描边颜色
typedef UpdateStrokeColorDart = void Function(int r, int g, int b);
typedef UpdateStrokeColor = Void Function(Int r, Int g, Int b);

// 注册关闭回调
typedef CloseCallbackDart = void Function();
typedef CloseCallbackFFI = Void Function();

typedef RegisterCloseCallbackDart = void Function(Pointer<NativeFunction<CloseCallbackFFI>> callback);
typedef RegisterCloseCallback = Void Function(Pointer<NativeFunction<CloseCallbackFFI>> callback);

class FFIBridge {
  static final DynamicLibrary _dylib = _openDylib();

  static DynamicLibrary _openDylib() {
    if (Platform.isMacOS) {
      return DynamicLibrary.open('libFloatLyric.dylib');
    } else if (Platform.isWindows) {
      return DynamicLibrary.open('libFloatLyric.dll');
    }
    throw UnsupportedError('Platform not supported');
  }

  static final ShowFloatLyricDart showFloatLyric = _dylib
      .lookup<NativeFunction<ShowFloatLyric>>('ShowFloatLyric')
      .asFunction<ShowFloatLyricDart>();

  static final HideFloatLyricDart hideFloatLyric = _dylib
      .lookup<NativeFunction<HideFloatLyric>>('HideFloatLyric')
      .asFunction<HideFloatLyricDart>();

  static final UpdateLyricDart updateLyric = _dylib
      .lookup<NativeFunction<UpdateLyric>>('UpdateLyric')
      .asFunction<UpdateLyricDart>();

  static final UpdateOpacityDart updateOpacity = _dylib
      .lookup<NativeFunction<UpdateOpacity>>('UpdateOpacity')
      .asFunction<UpdateOpacityDart>();

  static final UpdateFontSizeDart updateFontSize = _dylib
      .lookup<NativeFunction<UpdateFontSize>>('UpdateFontSize')
      .asFunction<UpdateFontSizeDart>();

  static final UpdateStrokeColorDart updateStrokeColor = _dylib
      .lookup<NativeFunction<UpdateStrokeColor>>('UpdateStrokeColor')
      .asFunction<UpdateStrokeColorDart>();

  static final RegisterCloseCallbackDart registerCloseCallback = _dylib
      .lookup<NativeFunction<RegisterCloseCallback>>('RegisterCloseCallback')
      .asFunction<RegisterCloseCallbackDart>();
}
