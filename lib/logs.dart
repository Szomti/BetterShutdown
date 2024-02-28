import 'package:flutter/material.dart';

class Logs {
  final List<Widget> entries;

  Logs({Iterable<Widget>? entries}) : entries = entries?.toList() ?? [];

  void add(
    String text, {
    bool user = false,
    ScrollController? controller,
  }) {
    TextSpan name = coloredText('info', Colors.blue);
    if (user) name = coloredText('user', Colors.brown);
    entries.add(
      RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 12),
          children: [
            coloredText('[${_logTime()}] ', Colors.black87),
            name,
            coloredText(': $text'),
          ],
        ),
      ),
    );
    controller?.jumpTo(controller.position.maxScrollExtent);
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
