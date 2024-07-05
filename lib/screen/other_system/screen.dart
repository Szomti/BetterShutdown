import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../app_colors.dart';
import '../../models/main_form.dart';
import '../../models/no_animation_route.dart';
import '../home/home.dart';

class OtherSystemScreen extends StatelessWidget {
  static const _outerPadding = EdgeInsets.all(16.0);
  static const _buttonPadding = EdgeInsets.all(16.0);
  static const _iconSize = 64.0;
  static final _titleTextStyle = TextStyle(
    color: AppColors().text,
    fontSize: 32,
  );
  static final _descriptionTextStyle = TextStyle(
    color: AppColors().text,
    fontSize: 24,
  );
  static final _buttonTextStyle = TextStyle(
    color: AppColors().text,
    fontSize: 16,
  );

  const OtherSystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors().background,
        body: SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: _outerPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Symbols.warning,
                    color: AppColors().warning,
                    size: _iconSize,
                  ),
                  Text(
                    'You are not using Windows!',
                    textAlign: TextAlign.center,
                    style: _titleTextStyle,
                  ),
                  Text(
                    'This app uses system\'s commands to operate.'
                    '\nOther devices are not supported.',
                    textAlign: TextAlign.center,
                    style: _descriptionTextStyle,
                  ),
                  _createButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _createButton(BuildContext context) {
    return Padding(
      padding: _buttonPadding,
      child: OutlinedButton(
        onPressed: () => _goToHomeScreen(context),
        child: Text(
          'Open anyway'.toUpperCase(),
          textAlign: TextAlign.center,
          style: _buttonTextStyle,
        ),
      ),
    );
  }

  void _goToHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      NoAnimationRoute(
        builder: (BuildContext context) => HomeScreen(MainForm()),
      ),
    );
  }
}
