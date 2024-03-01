import 'package:better_shutdown/log.dart';
import 'package:flutter/material.dart';

class Logs {
  final List<Log> entries;

  Logs({Iterable<Log>? entries}) : entries = entries?.toList() ?? [];

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
            color: Colors.black12,
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
    controller?.animateTo(
      controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeIn,
    );
  }

  String _logTime() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');
    final millisecond = now.millisecond.toString().padLeft(3, '0');
    return '$hour:$minute:$second:$millisecond';
  }

  TextSpan coloredText(String text, [Color color = Colors.black]) => TextSpan(
        text: text,
        style: TextStyle(color: color),
      );
}
