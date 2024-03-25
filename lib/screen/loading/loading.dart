import 'package:flutter/material.dart';

import '../../app_colors.dart';
import '../../models/main_form.dart';
import '../../models/no_animation_route.dart';
import '../../widgets/window_cover.dart';
import '../home/home.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Future.delayed(
        const Duration(milliseconds: 400),
        () {
          Navigator.push(
            context,
            NoAnimationRoute(
              builder: (BuildContext context) => HomeScreen(MainForm()),
            ),
          );
        },
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: const WindowCover(),
        backgroundColor: AppColors().background,
      ),
    );
  }
}
