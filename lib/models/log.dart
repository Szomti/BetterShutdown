import 'package:flutter/material.dart';

import '../app_colors.dart';

abstract class Log {
  final LogType type;
  final DateTime timestamp;

  Log(this.type) : timestamp = DateTime.timestamp();

  Widget createWidget();
}

class TextLog extends Log {
  final String text;

  TextLog(this.text, super.type);

  @override
  Widget createWidget() {
    TextSpan name = coloredText(type.name, type.color);
    return Container(
      margin: const EdgeInsets.only(bottom: 3.0),
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: type.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 12),
          children: [
            coloredText(
              '[${_logTime()}] ',
              AppColors().text.withOpacity(0.8),
            ),
            name,
            coloredText(': $text'),
          ],
        ),
      ),
    );
  }

  String _logTime() {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final second = timestamp.second.toString().padLeft(2, '0');
    final millisecond = timestamp.millisecond.toString().padLeft(3, '0');
    return '$hour:$minute:$second.$millisecond';
  }

  TextSpan coloredText(String text, [Color? color]) => TextSpan(
        text: text,
        style: TextStyle(color: color ?? AppColors().text),
      );
}

class WidgetLog extends Log {
  final Widget widget;

  WidgetLog(this.widget, super.type);

  @override
  Widget createWidget() => widget;
}

enum LogType {
  debug._('debug'),
  user._('user'),
  info._('info'),
  error._('error');

  final String name;

  const LogType._(this.name);

  Color get color {
    switch (this) {
      case LogType.debug:
        return Colors.green;
      case LogType.user:
        return AppColors().text;
      case LogType.info:
        return Colors.blue;
      case LogType.error:
        return Colors.red;
    }
  }
}
