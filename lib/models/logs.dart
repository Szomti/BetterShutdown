import 'package:flutter/material.dart';

import 'log.dart';

class Logs {
  static final Logs _instance = Logs._();
  final List<Log> entries = [];
  final List<LogType> showTypes = [...LogType.values];

  Logs._();

  factory Logs() => _instance;

  void addCustom(Iterable<Log> customEntries) => entries.addAll(customEntries);

  void add(
    String text, {
    LogType type = LogType.info,
    ScrollController? controller,
  }) {
    entries.add(TextLog(text, type));
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
}
