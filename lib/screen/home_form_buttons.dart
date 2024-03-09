import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../models/log.dart';
import '../models/logs.dart';
import '../models/main_form.dart';
import '../models/schedule_type.dart';
import 'home.dart';

class HomeFormButtons extends StatefulWidget {
  final MainForm form;

  const HomeFormButtons(this.form, {super.key});

  @override
  State<StatefulWidget> createState() => _HomeFormButtonsState();
}

class _HomeFormButtonsState extends State<HomeFormButtons> {
  MainForm get _form => widget.form;

  DateTime? get _shutdownDate => _form.shutdownDate;

  Logs get _logs => _form.logs;

  ScrollController get _scrollController => _form.scrollController;

  ScheduleField get _currentField => _form.currentField;

  GlobalKey<HomeScreenState> get _homeScreenKey => _form.homeScreenKey;

  int? get _seconds => _form.seconds;

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
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
        'Shutdown aborted - ${_shutdownDate ?? 'unknown'}',
        controller: _scrollController,
      );
    }
    _form.seconds = null;
    _form.shutdownDate = null;
    _homeScreenKey.currentState?.setState(() {});
  }

  Future<void> _schedule() async {
    try {
      _form.processing = true;
      _homeScreenKey.currentState?.setState(() {});
      final seconds = _currentField.seconds;
      if (seconds == null) {
        _logs.add(
          'Incorrect input',
          controller: _scrollController,
        );
        _homeScreenKey.currentState?.setState(() {});
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
        _form.seconds = seconds;
        _form.shutdownDate = DateTime.now().add(
          Duration(seconds: seconds),
        );
        _homeScreenKey.currentState?.setState(() {});
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
      _form.processing = false;
      _homeScreenKey.currentState?.setState(() {});
    }
  }

  Future<void> _timer() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    final seconds = _seconds;
    if (seconds == null || seconds <= 0) return;
    _form.seconds = seconds - 1;
    _homeScreenKey.currentState?.setState(() {});
    unawaited(_timer());
  }
}
