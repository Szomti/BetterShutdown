import 'dart:io';

import 'package:better_shutdown/custom_text_field.dart';
import 'package:better_shutdown/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home_logs.dart';
import 'logs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _padding = EdgeInsets.all(8.0);
  final _controller = TextEditingController(text: '120');
  final _scrollController = ScrollController();
  final _logs = Logs();
  int? _seconds;
  DateTime? _shutdownDate;
  bool processing = false;

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
                      // shell: _shell,
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
                                    controller: _controller,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
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
                                  onPressed: () {
                                    showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 3630)),
                                    );
                                  },
                                  child: const Text('Select Date'),
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
                                  child: const Text('Start'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _abort,
                                  child: const Text('Abort'),
                                ),
                              ),
                            ],
                          ),
                          if (_seconds != null)
                            Text('Shutdown in: ${_seconds}s'),
                          if (_shutdownDate != null)
                            Text(
                              'Shutdown at: ${_shutdownDate?.toLocal()}',
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
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

  void _timer() async {
    await Future.delayed(const Duration(seconds: 1));
    final seconds = _seconds;
    if (seconds == null || seconds <= 0) return;
    _seconds = seconds - 1;
    setState(() {});
    _timer();
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
      final seconds = int.tryParse(_controller.text);
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
        _timer();
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
