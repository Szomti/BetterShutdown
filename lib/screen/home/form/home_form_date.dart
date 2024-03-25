import 'package:flutter/material.dart';

import '../../../app_colors.dart';
import '../../../models/logs.dart';
import '../../../models/main_form.dart';
import '../home.dart';

class HomeFormDate extends StatefulWidget {
  final MainForm form;

  const HomeFormDate(this.form, {super.key});

  @override
  State<StatefulWidget> createState() => _HomeFormDateState();
}

class _HomeFormDateState extends State<HomeFormDate> {
  final AppColors _appColors = AppColors();
  final Logs _logs = Logs();

  MainForm get _form => widget.form;

  ScrollController get _scrollController => _form.scrollController;

  GlobalKey<HomeScreenState> get _homeScreenKey => _form.homeScreenKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _appColors.button,
            ),
            onPressed: () async {
              final now = DateTime.now();
              final date = await showDatePicker(
                context: context,
                builder: (context, child) {
                  if (child == null) return const SizedBox.shrink();
                  final current = Theme.of(context);
                  return Theme(
                    data: current.copyWith(
                      textSelectionTheme: TextSelectionThemeData(
                        cursorColor: _appColors.opposite.withOpacity(0.55),
                        selectionColor: _appColors.opposite.withOpacity(0.25),
                      ),
                      textTheme: current.textTheme.apply(
                        displayColor: _appColors.text,
                        bodyColor: _appColors.text,
                      ),
                      inputDecorationTheme: InputDecorationTheme(
                        hintStyle: TextStyle(
                          fontSize: 13.0,
                          color: AppColors().text.withOpacity(0.8),
                          fontWeight: FontWeight.w400,
                        ),
                        labelStyle: TextStyle(
                          fontSize: 13.0,
                          color: AppColors().text.withOpacity(0.6),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      colorScheme: ColorScheme.dark(
                        brightness: AppColors.appTheme == AppTheme.dark
                            ? Brightness.dark
                            : Brightness.light,
                        primary: _appColors.opposite,
                        onPrimary: _appColors.main,
                        secondary: _appColors.background,
                        onSecondary: _appColors.text,
                        error: Colors.red,
                        onError: Colors.white70,
                        background: _appColors.background,
                        onBackground: _appColors.text,
                        surface: _appColors.background,
                        onSurface: _appColors.text,
                      ),
                    ),
                    child: child,
                  );
                },
                firstDate: now,
                lastDate: now.add(const Duration(days: 3630)),
              );
              if (date == null) return;
              if (!context.mounted) return;
              final time = await showTimePicker(
                context: context,
                builder: (context, child) {
                  if (child == null) return const SizedBox.shrink();
                  return Theme(
                    data: Theme.of(context).copyWith(
                      timePickerTheme: TimePickerThemeData(
                        helpTextStyle: TextStyle(color: _appColors.text),
                        hourMinuteTextColor: _appColors.text.withOpacity(0.9),
                        hourMinuteColor: _appColors.opposite.withOpacity(0.3),
                      ),
                      textSelectionTheme: TextSelectionThemeData(
                        cursorColor: _appColors.opposite.withOpacity(0.55),
                        selectionColor: _appColors.opposite.withOpacity(0.25),
                      ),
                      textTheme: TextTheme(
                        bodySmall: TextStyle(color: _appColors.text),
                      ),
                      colorScheme: ColorScheme(
                        brightness: AppColors.appTheme == AppTheme.dark
                            ? Brightness.dark
                            : Brightness.light,
                        primary: _appColors.opposite,
                        onPrimary: _appColors.main,
                        secondary: _appColors.background,
                        onSecondary: _appColors.text,
                        error: Colors.red,
                        onError: Colors.white70,
                        background: _appColors.background,
                        onBackground: _appColors.text,
                        surface: _appColors.background,
                        onSurface: _appColors.text,
                      ),
                    ),
                    child: child,
                  );
                },
                initialTime: TimeOfDay.now(),
              );
              if (time == null) return;
              final scheduled = date.copyWith(
                hour: time.hour,
                minute: time.minute,
              );
              _form.dateField.date = scheduled;
              _logs.addLog(
                'Selected date: ${scheduled.toLocal()}',
                controller: _scrollController,
              );
              _homeScreenKey.currentState?.setState(() {});
            },
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Select Date',
                style: TextStyle(
                  color: _appColors.text,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
