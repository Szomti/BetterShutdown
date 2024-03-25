import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'screen/loading/loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(480, 270),
    size: Size(960, 540),
    center: true,
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Better Shutdown',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoadingScreen(),
    );
  }
}
