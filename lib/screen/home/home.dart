import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../app_colors.dart';
import '../../models/log.dart';
import '../../models/logs.dart';
import '../../models/main_form.dart';
import '../../models/schedule_type.dart';
import '../../widgets/window_cover.dart';
import 'form/home_form.dart';
import 'home_info.dart';
import 'home_projected_date.dart';
import 'logs/home_logs.dart';

class HomeScreen extends StatefulWidget {
  final MainForm form;

  HomeScreen(this.form) : super(key: form.homeScreenKey);

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  static const _padding = EdgeInsets.all(8.0);
  static bool initCheck = true;
  final Logs _logs = Logs();

  MainForm get _form => widget.form;

  ScrollController get _scrollController => _form.scrollController;

  ScheduleField get _currentField => _form.currentField;

  bool get _processing => _form.processing;

  @override
  void initState() {
    _check();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors().background,
        body: Stack(
          children: [
            AbsorbPointer(
              absorbing: _processing,
              child: Padding(
                padding: _padding,
                child: Row(
                  children: [
                    HomeLogs(scrollController: _scrollController),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        children: [
                          HomeForm(_form),
                          const SizedBox(height: 8),
                          HomeProjectedDate(_currentField),
                          const Spacer(),
                          HomeInfo(_form),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_processing) const WindowCover(),
          ],
        ),
      ),
    );
  }

  Future<void> _check() async {
    if (!initCheck) return;
    final stopwatch = Stopwatch()..start();
    ProcessResult? result;
    ProcessResult? abortResult;
    try {
      // TODO: Check if app scheduled one itself (to create timer)
      _form.processing = true;
      _logs.addLog(
        'Initializing',
        controller: _scrollController,
      );
      _logs.addLog(
        'Scheduling shutdown - testing if any existing scheduled shutdown',
        controller: _scrollController,
      );
      result = await Process.run(
        'shutdown',
        ['/s', '/t', '315000000'],
      );
      if (result.stderr.toString().trim().isEmpty &&
          result.stdout.toString().trim().isEmpty) {
        _logs.addLog(
          'Shutdown not scheduled',
          controller: _scrollController,
        );
        _logs.addLog(
          'Canceling shutdown - aborting test scheduled shutdown',
          controller: _scrollController,
        );
        abortResult = await Process.run(
          'shutdown',
          ['/a'],
        );
      } else {
        throw result;
      }
      stopwatch.stop();
      _logs.addLog(
        'Finished without problems [${stopwatch.elapsedMilliseconds}ms]',
        controller: _scrollController,
      );
    } catch (error) {
      if (result != null && result.stderr.toString().trim().isNotEmpty) {
        _logs.addLog(
          'Shutdown already scheduled!',
          type: LogType.error,
          controller: _scrollController,
        );
      }
      if (abortResult != null &&
          abortResult.stderr.toString().trim().isNotEmpty) {
        _logs.addLog(
          abortResult.stderr.toString().trim(),
          type: LogType.error,
          controller: _scrollController,
        );
      }
      debugPrint('$error');
    } finally {
      stopwatch.stop();
      initCheck = false;
      _form.processing = false;
      if (mounted) setState(() {});
    }
  }
}
