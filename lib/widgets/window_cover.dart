import 'package:flutter/material.dart';

import '../app_colors.dart';

class WindowCover extends StatefulWidget {
  const WindowCover({super.key});

  @override
  State<StatefulWidget> createState() => _WindowCoverState();
}

class _WindowCoverState extends State<WindowCover> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  color: AppColors().background,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: AppColors().icon,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
