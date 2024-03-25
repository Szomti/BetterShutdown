import 'dart:io';

import 'package:flutter/material.dart';

import '../../../debug/debug.dart';
import '../../../models/log.dart';
import '../../../models/logs.dart';
import '../../../widgets/custom_text_field.dart';

class HomeLogsCommandLine extends StatefulWidget {
  final ScrollController scrollController;

  const HomeLogsCommandLine(this.scrollController, {super.key});

  @override
  State<StatefulWidget> createState() => _HomeLogsCommandLineState();
}

class _HomeLogsCommandLineState extends State<HomeLogsCommandLine> {
  final _shellController = TextEditingController(text: '');
  final _shellFocus = FocusNode();
  final Logs _logs = Logs();

  ScrollController get _scrollController => widget.scrollController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 36,
        child: CustomTextField(
          labelText: 'command prompt',
          focusNode: _shellFocus,
          onSubmitted: (text) async {
            text = text.trim();
            _logs.addLog(
              text,
              type: LogType.user,
              controller: _scrollController,
            );
            final command = text.split(' ').elementAt(0);
            final args = text.split(' ')..removeAt(0);
            ProcessResult? result;
            try {
              if (await Debug().debugCommand(
                text,
                context,
                _shellController,
              )) return;
              result = await Process.run(command, args);
              if (result.stdout.toString().trim().isNotEmpty) {
                _logs.addLog(
                  result.stdout.toString().trim(),
                  controller: _scrollController,
                );
              }
            } catch (error) {
              if (result != null &&
                  result.stderr.toString().trim().isNotEmpty) {
                _logs.addLog(
                  result.stderr,
                  type: LogType.error,
                  controller: _scrollController,
                );
              } else {
                _logs.addLog(
                  'Not a command',
                  type: LogType.info,
                  controller: _scrollController,
                );
              }
              debugPrint('$error');
            } finally {
              _shellController.text = '';
              if (mounted) setState(() {});
              _shellFocus.requestFocus();
            }
          },
          controller: _shellController,
        ),
      ),
    );
  }
}
