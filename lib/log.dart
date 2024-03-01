import 'package:flutter/material.dart';

class Log {
  final LogType type;
  final Widget widget;

  Log(this.type, this.widget);
}

enum LogType {
  user._('user', Colors.brown),
  info._('info', Colors.blue),
  error._('error', Colors.red);

  final String name;
  final Color color;

  const LogType._(this.name, this.color);
}
