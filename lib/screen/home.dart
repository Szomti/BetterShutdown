import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../models/log.dart';
import '../models/logs.dart';
import '../models/main_form.dart';
import '../models/schedule_type.dart';
import 'home_form.dart';
import 'home_logs.dart';
import 'home_projected_date.dart';

class HomeScreen extends StatefulWidget {
  final MainForm form;

  HomeScreen(this.form) : super(key: form.homeScreenKey);

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  static const _padding = EdgeInsets.all(8.0);
  int? _seconds;
  DateTime? _shutdownDate;

  MainForm get _form => widget.form;

  Logs get _logs => _form.logs;

  GlobalKey<HomeLogsState> get _homeLogsKey => _form.homeLogsKey;

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
        body: Stack(
          children: [
            AbsorbPointer(
              absorbing: _processing,
              child: Padding(
                padding: _padding,
                child: Row(
                  children: [
                    HomeLogs(
                      scrollController: _scrollController,
                      logs: _logs,
                      key: _homeLogsKey,
                    ),
                    const SizedBox(width: 8),
                    _createShutdownInfo(),
                  ],
                ),
              ),
            ),
            _createWindowCover(),
          ],
        ),
      ),
    );
  }

  Widget _createShutdownInfo() {
    return Expanded(
      child: Column(
        children: [
          HomeForm(_form),
          const SizedBox(height: 8),
          HomeProjectedDate(_currentField),
          const Spacer(),
          if (_seconds != null || _shutdownDate != null)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  if (_seconds != null)
                    Row(
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Shutdown in: ${_seconds}s',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (_shutdownDate != null)
                    Row(
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Shutdown at: ${_shutdownDate?.toLocal()}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _createWindowCover() {
    if (!_processing) return const SizedBox.shrink();
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.black54,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
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

  Future<void> _check() async {
    final stopwatch = Stopwatch()..start();
    ProcessResult? result;
    ProcessResult? abortResult;
    try {
      // TODO: Check if app scheduled one itself (to create timer)
      _form.processing = true;
      _logs.add(
        'Initializing',
        controller: _scrollController,
      );
      _homeLogsKey.currentState?.setState(() {});
      _logs.add(
        'Scheduling shutdown - testing if any existing scheduled shutdown',
        controller: _scrollController,
      );
      _homeLogsKey.currentState?.setState(() {});
      result = await Process.run(
        'shutdown',
        ['/s', '/t', '315000000'],
      );
      if (result.stderr.toString().trim().isEmpty &&
          result.stdout.toString().trim().isEmpty) {
        _logs.add(
          'Shutdown not scheduled',
          controller: _scrollController,
        );
        _homeLogsKey.currentState?.setState(() {});
        _logs.add(
          'Canceling shutdown - aborting test scheduled shutdown',
          controller: _scrollController,
        );
        _homeLogsKey.currentState?.setState(() {});
        abortResult = await Process.run(
          'shutdown',
          ['/a'],
        );
      } else {
        throw result;
      }
      stopwatch.stop();
      _logs.add(
        'Finished without problems [${stopwatch.elapsedMilliseconds}ms]',
        controller: _scrollController,
      );
      _homeLogsKey.currentState?.setState(() {});
    } catch (error) {
      if (result != null && result.stderr.toString().trim().isNotEmpty) {
        _logs.add(
          'Shutdown already scheduled!',
          type: LogType.error,
          controller: _scrollController,
        );
      }
      if (abortResult != null &&
          abortResult.stderr.toString().trim().isNotEmpty) {
        _logs.add(
          abortResult.stderr.toString().trim(),
          type: LogType.error,
          controller: _scrollController,
        );
      }
      debugPrint('$error');
    } finally {
      stopwatch.stop();
      _form.processing = false;
      setState(() {});
    }
  }
}
