import 'package:flutter/material.dart';

import 'log.dart';

class Logs {
  final List<Log> entries;
  final List<LogType> showTypes;

  Logs({
    Iterable<Log>? entries,
    Iterable<LogType>? showTypes,
  })  : entries = entries?.toList() ?? [],
        showTypes = showTypes?.toList() ?? [...LogType.values];

  void add(
    String text, {
    LogType type = LogType.info,
    ScrollController? controller,
  }) {
    TextSpan name = coloredText(type.name, type.color);
    entries.add(
      Log(
        type,
        Container(
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
                coloredText('[${_logTime()}] ', Colors.black87),
                name,
                coloredText(': $text'),
              ],
            ),
          ),
        ),
      ),
    );
    try {
      if (controller != null && controller.hasClients) {
        controller.animateTo(
          controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeIn,
        );
      }
    } catch (error) {
      debugPrint('$error');
    }
  }

  String _logTime() {
    final now = DateTime.now().toLocal();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');
    final millisecond = now.millisecond.toString().padLeft(3, '0');
    return '$hour:$minute:$second.$millisecond';
  }

  TextSpan coloredText(String text, [Color color = Colors.black]) => TextSpan(
        text: text,
        style: TextStyle(color: color),
      );
}
