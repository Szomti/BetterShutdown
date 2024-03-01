import 'dart:io';

import 'package:flutter/material.dart';

import 'custom_text_field.dart';
import 'log.dart';
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
  State<StatefulWidget> createState() => HomeLogsState();
}

class HomeLogsState extends State<HomeLogs> {
  final _shellController = TextEditingController(text: '');
  final _shellFocus = FocusNode();
  bool _showFilters = false;

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
              flex: 2,
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: ListView(
                  shrinkWrap: true,
                  controller: _scrollController,
                  children: [
                    ..._logs.entries.map((e) {
                      if (_logs.showTypes.contains(e.type)) return e.widget;
                      return const SizedBox.shrink();
                    }),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            if (_showFilters)
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 75),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Show logs:'),
                          GestureDetector(
                            onTap: () {
                              if (_logs.showTypes.contains(LogType.user)) {
                                _logs.showTypes.remove(LogType.user);
                              } else {
                                _logs.showTypes.add(LogType.user);
                              }
                              setState(() {});
                            },
                            child: Container(
                              margin: const EdgeInsets.all(2),
                              color: Colors.black.withOpacity(0.1),
                              child: Row(
                                children: [
                                  Icon(
                                    _logs.showTypes.contains(LogType.user)
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                  ),
                                  const Text('user'),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_logs.showTypes.contains(LogType.info)) {
                                _logs.showTypes.remove(LogType.info);
                              } else {
                                _logs.showTypes.add(LogType.info);
                              }
                              setState(() {});
                            },
                            child: Container(
                              margin: const EdgeInsets.all(2),
                              color: Colors.black.withOpacity(0.1),
                              child: Row(
                                children: [
                                  Icon(
                                    _logs.showTypes.contains(LogType.info)
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                  ),
                                  const Text('info'),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_logs.showTypes.contains(LogType.error)) {
                                _logs.showTypes.remove(LogType.error);
                              } else {
                                _logs.showTypes.add(LogType.error);
                              }
                              setState(() {});
                            },
                            child: Container(
                              margin: const EdgeInsets.all(2),
                              color: Colors.black.withOpacity(0.1),
                              child: Row(
                                children: [
                                  Icon(
                                    _logs.showTypes.contains(LogType.error)
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                  ),
                                  const Text('error'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    _showFilters = !_showFilters;
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.filter_list_outlined),
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    _logs.entries.clear();
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.cleaning_services_outlined),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: CustomTextField(
                      labelText: 'command prompt',
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
                          if (result.stdout.toString().trim().isNotEmpty) {
                            _logs.add(
                              result.stdout.toString().trim(),
                              controller: _scrollController,
                            );
                          }
                        } catch (error) {
                          if (result != null &&
                              result.stderr.toString().trim().isNotEmpty) {
                            _logs.add(
                              result.stderr,
                              type: LogType.error,
                              controller: _scrollController,
                            );
                          } else {
                            _logs.add(
                              'Not a command',
                              type: LogType.error,
                              controller: _scrollController,
                            );
                          }
                          debugPrint('$error');
                        } finally {
                          _shellController.text = '';
                          setState(() {});
                          _shellFocus.requestFocus();
                        }
                      },
                      controller: _shellController,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
