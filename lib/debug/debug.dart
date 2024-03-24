import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';

import '../app_colors.dart';
import '../models/log.dart';
import '../models/logs.dart';

class Debug {
  static final Debug _instance = Debug._();

  Debug._();

  factory Debug() => _instance;

  bool active = false;

  bool changeState(String text) {
    if (text == 'debug on') {
      active = true;
      Logs().add('$active', type: LogType.debug);
      return true;
    }
    if (text == 'debug off') {
      active = false;
      Logs().add('$active', type: LogType.debug);
      return true;
    }
    if (text == 'debug status') {
      Logs().add('$active', type: LogType.debug);
      return true;
    }
    return false;
  }

  Future<bool> debugCommand(
    String text,
    BuildContext context,
    TextEditingController shellController,
  ) async {
    if (text == _DebugCommands.clear.command) {
      Logs().entries.clear();
      return true;
    }
    if (!active) return false;
    final command = _DebugCommands.search(text);
    switch (command) {
      case _DebugCommands.clear:
      case _DebugCommands.debugOn:
      case _DebugCommands.debugOff:
      case _DebugCommands.debugStatus:
      case null:
        return false;
      case _DebugCommands.checkColors:
        Logs().addCustom(AppColors().checkValues());
      case _DebugCommands.light:
        if (AppColors().appTheme == AppTheme.light) return true;
        AppColors().changeTheme(AppTheme.light);
        shellController.text = '';
        await Navigator.pushNamedAndRemoveUntil(
          context,
          '/',
          (_) => false,
        );
      case _DebugCommands.dark:
        if (AppColors().appTheme == AppTheme.dark) return true;
        AppColors().changeTheme(AppTheme.dark);
        shellController.text = '';
        await Navigator.pushNamedAndRemoveUntil(
          context,
          '/',
          (_) => false,
        );
    }
    return true;
  }
}

enum _DebugCommands {
  clear._('clear'),
  debugOn._('debug on'),
  debugOff._('debug off'),
  debugStatus._('debug status'),
  checkColors._('check colors'),
  light._('light'),
  dark._('dark');

  final String command;

  const _DebugCommands._(this.command);

  static _DebugCommands? search(String text) {
    return _DebugCommands.values.firstWhereOrNull((e) => e.command == text);
  }
}
