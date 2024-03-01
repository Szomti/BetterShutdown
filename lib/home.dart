import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'custom_text_field.dart';
import 'home_logs.dart';
import 'log.dart';
import 'logs.dart';
import 'projected_date_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _padding = EdgeInsets.all(8.0);
  static final _homeLogsKey = GlobalKey<HomeLogsState>();
  final _textFieldController = TextEditingController(text: '300');
  final _scrollController = ScrollController();
  final _logs = Logs();
  int? _seconds;
  DateTime? _shutdownDate;
  bool processing = false;

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
              absorbing: processing,
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
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 36,
                                  child: CustomTextField(
                                    labelText: 'Seconds',
                                    controller: _textFieldController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final now = DateTime.now();
                                    final date = await showDatePicker(
                                      context: context,
                                      firstDate: now,
                                      lastDate:
                                          now.add(const Duration(days: 3630)),
                                    );
                                    if (date == null) return;
                                    if (!context.mounted) return;
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    if (time == null) return;
                                    final scheduled = date.copyWith(
                                      hour: time.hour,
                                      minute: time.minute,
                                    );
                                    _textFieldController.text = scheduled
                                        .difference(now)
                                        .inSeconds
                                        .toString();
                                    _logs.add(
                                      'Set time to: ${scheduled.toLocal()}',
                                      controller: _scrollController,
                                    );
                                    setState(() {});
                                  },
                                  child: const FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text('Select Date'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _schedule,
                                  child: const FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text('Start'),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _abort,
                                  child: const FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text('Abort'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: ThemeData.light()
                                  .primaryColorLight
                                  .withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ProjectedDateText(
                                    _textFieldController.text,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                    ),
                  ],
                ),
              ),
            ),
            if (processing)
              Column(
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
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _timer() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    final seconds = _seconds;
    if (seconds == null || seconds <= 0) return;
    _seconds = seconds - 1;
    setState(() {});
    await _timer();
  }

  Future<void> _check() async {
    ProcessResult? result;
    ProcessResult? abortResult;
    try {
      // TODO: Check if app scheduled one itself (to create timer)
      processing = true;
      _logs.add(
        'Initializing',
        controller: _scrollController,
      );
      _homeLogsKey.currentState?.setState(() {});
      _logs.add(
        'Testing if already scheduled',
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
        abortResult = await Process.run(
          'shutdown',
          ['/a'],
        );
      }
      _logs.add(
        'Finished without problems',
        controller: _scrollController,
      );
      _homeLogsKey.currentState?.setState(() {});
    } catch (error) {
      if (result != null && result.stderr.toString().trim().isNotEmpty) {
        _logs.add(
          'Shutdown already scheduled',
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
      processing = false;
      setState(() {});
    }
  }

  Future<void> _abort() async {
    final result = await Process.run(
      'shutdown',
      ['/a'],
    );
    if (result.stderr.toString().trim().isNotEmpty) {
      _logs.add(
        result.stderr.toString().trim(),
        type: LogType.error,
        controller: _scrollController,
      );
    } else {
      _logs.add(
        'Shutdown aborted - $_shutdownDate',
        controller: _scrollController,
      );
    }
    _seconds = null;
    _shutdownDate = null;
    setState(() {});
  }

  Future<void> _schedule() async {
    try {
      processing = true;
      setState(() {});
      final seconds = int.tryParse(_textFieldController.text);
      if (seconds == null) {
        _logs.add(
          'Incorrect input',
          controller: _scrollController,
        );
        setState(() {});
        return;
      }
      final result = await Process.run(
        'shutdown',
        ['/s', '/t', '$seconds'],
      );
      if (result.stderr.toString().trim().isNotEmpty) {
        _logs.add(
          result.stderr.toString().trim(),
          type: LogType.error,
          controller: _scrollController,
        );
      }
      if (result.stdout.toString().trim().isNotEmpty) {
        _logs.add(
          result.stdout.toString().trim(),
          controller: _scrollController,
        );
      }
      if (result.stdout.toString().trim().isEmpty &&
          result.stderr.toString().trim().isEmpty) {
        _seconds = seconds;
        _shutdownDate = DateTime.now().add(
          Duration(seconds: seconds),
        );
        setState(() {});
        unawaited(_timer());
        _logs.add(
          'Shutdown scheduled - $_shutdownDate',
          controller: _scrollController,
        );
      }
    } catch (error) {
      debugPrint('$error');
    } finally {
      await Future.delayed(const Duration(milliseconds: 50));
      processing = false;
      setState(() {});
    }
  }
}
