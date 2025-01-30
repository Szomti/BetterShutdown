import 'package:flutter/material.dart';

class Global {
  static const String version = '1.0.1';

  static Future<void> restartApp(BuildContext context) =>
      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
}
