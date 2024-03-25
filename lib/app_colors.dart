import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'models/log.dart';

enum AppTheme { dark, light }

class AppColors {
  static final AppColors _instance = AppColors._();
  static AppTheme appTheme = AppTheme.dark;
  AppTheme? _temp;

  AppColors._() {
    final mode =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    switch (mode) {
      case Brightness.dark:
        appTheme = AppTheme.dark;
      case Brightness.light:
        appTheme = AppTheme.light;
    }
  }

  Log _createCheckLog(String name, Color color, [bool hideColor = false]) {
    final colorInfo = hideColor
        ? ''
        : 'color: #${color.value.toRadixString(16).toUpperCase()} | ';
    final widget = Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: border)),
        child: Row(
          children: [
            const SizedBox(width: 4),
            if (!hideColor)
              ColoredBox(
                color: color,
                child: const SizedBox.square(dimension: 10),
              ),
            if (!hideColor) const SizedBox(width: 5),
            Text(
              '$colorInfo$name',
              style: TextStyle(color: text),
            ),
          ],
        ),
      ),
    );
    return WidgetLog(widget, LogType.debug);
  }

  Iterable<Log> checkValues() {
    return [
      _createCheckLog('appTheme: $appTheme', text, true),
      _createCheckLog('temp: $_temp', text, true),
      _createCheckLog('main', main),
      _createCheckLog('opposite', opposite),
      _createCheckLog('icon', icon),
      _createCheckLog('background', background),
      _createCheckLog('border', border),
      _createCheckLog('text', text),
    ];
  }

  factory AppColors() {
    _instance._temp = null;
    return _instance;
  }

  factory AppColors.light() {
    _instance._temp = AppTheme.light;
    return _instance;
  }

  factory AppColors.dark() {
    _instance._temp = AppTheme.dark;
    return _instance;
  }

  static void changeTheme(AppTheme appTheme) => AppColors.appTheme = appTheme;

  static void switchTheme() {
    switch (AppColors.appTheme) {
      case AppTheme.dark:
        AppColors.appTheme = AppTheme.light;
      case AppTheme.light:
        AppColors.appTheme = AppTheme.dark;
    }
  }

  Color get main => _byTheme(
        dark: _DarkColors.main,
        light: _LightColors.main,
      );

  Color get opposite => _byTheme(
        dark: _DarkColors.opposite,
        light: _LightColors.opposite,
      );

  Color get button => _byTheme(
        dark: _DarkColors.button,
        light: _LightColors.button,
      );

  Color get icon => _byTheme(
        dark: _DarkColors.icon,
        light: _LightColors.icon,
      );

  Color get background => _byTheme(
        dark: _DarkColors.background,
        light: _LightColors.background,
      );

  Color get border => _byTheme(
        dark: _DarkColors.border,
        light: _LightColors.border,
      );

  Color get text => _byTheme(
        dark: _DarkColors.text,
        light: _LightColors.text,
      );

  Color _byTheme({required Color dark, required Color light}) {
    final temp = _temp;
    if (temp == null) {
      switch (appTheme) {
        case AppTheme.dark:
          return dark;
        case AppTheme.light:
          return light;
      }
    } else {
      switch (temp) {
        case AppTheme.dark:
          return dark;
        case AppTheme.light:
          return light;
      }
    }
  }
}

class _DarkColors {
  static const main = Colors.black;
  static const opposite = Colors.white;
  static const button = Color(0xFF525252);
  static const icon = Color(0xFFCECECE);
  static const background = Color(0xFF343434);
  static const border = Colors.white38;
  static const text = Color(0xFFCFCFCF);
}

class _LightColors {
  static const main = Colors.white;
  static const opposite = Colors.black;
  static const button = Colors.white;
  static const icon = Colors.black;
  static const background = Colors.white;
  static const border = Colors.black54;
  static const text = Colors.black;
}
