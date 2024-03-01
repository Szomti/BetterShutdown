import 'dart:io';

import 'package:better_shutdown/log.dart';
import 'package:flutter/material.dart';

import 'custom_text_field.dart';
import 'logs.dart';

class HomeLogs extends StatefulWidget {
  final ScrollController scrollController;
  final Logs logs;

  const HomeLogs({
    required this.scrollController,
    required this.logs,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _HomeLogsState();
}

class _HomeLogsState extends State<HomeLogs> {
  final _shellController = TextEditingController(text: '');
  final _shellFocus = FocusNode();

  ScrollController get _scrollController => widget.scrollController;

  Logs get _logs => widget.logs;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black45,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: ListView(
                  shrinkWrap: true,
                  controller: _scrollController,
                  children: [
                    ..._logs.entries.map((e) => e.widget),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 36,
              child: CustomTextField(
                focusNode: _shellFocus,
                onSubmitted: (text) async {
                  _logs.add(
                    text,
                    type: LogType.user,
                    controller: _scrollController,
                  );
                  final command = text.split(' ').elementAt(0);
                  final args = text.split(' ')..removeAt(0);
                  ProcessResult? result;
                  try {
                    result = await Process.run(command, args);
                  } catch (error) {
                    if (result != null &&
                        result.stderr.toString().trim().isNotEmpty) {
                      _logs.add(
                        result.stderr,
                        type: LogType.error,
                        controller: _scrollController,
                      );
                    }
                    debugPrint('$error');
                  }
                  _shellController.text = '';
                  setState(() {});
                  _shellFocus.requestFocus();
                },
                controller: _shellController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
