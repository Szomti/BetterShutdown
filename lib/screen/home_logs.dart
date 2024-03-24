import 'dart:io';

import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../debug/debug.dart';
import '../models/log.dart';
import '../models/logs.dart';
import '../widgets/custom_text_field.dart';

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
            color: AppColors().border,
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
                      if (_logs.showTypes.contains(e.type)) {
                        return e.createWidget();
                      }
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
                    border: Border.all(color: AppColors().border),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Show logs:',
                            style: TextStyle(color: AppColors().text),
                          ),
                          _buildOption(LogType.user),
                          _buildOption(LogType.info),
                          _buildOption(LogType.error),
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
                    if (mounted) setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors().border),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.filter_list_outlined,
                      color: AppColors().icon,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    _logs.entries.clear();
                    if (mounted) setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors().border),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.cleaning_services_outlined,
                      color: AppColors().icon,
                    ),
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
                        text = text.trim();
                        _logs.add(
                          text,
                          type: LogType.user,
                          controller: _scrollController,
                        );
                        final command = text.split(' ').elementAt(0);
                        final args = text.split(' ')..removeAt(0);
                        ProcessResult? result;
                        try {
                          if (Debug().changeState(text)) return;
                          if (await Debug().debugCommand(
                            text,
                            context,
                            _shellController,
                          )) return;
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
                          if (mounted) setState(() {});
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

  Widget _buildOption(LogType logType) {
    return GestureDetector(
      onTap: () {
        if (_logs.showTypes.contains(logType)) {
          _logs.showTypes.remove(logType);
        } else {
          _logs.showTypes.add(logType);
        }
        if (mounted) setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.all(2),
        color: AppColors().opposite.withOpacity(0.1),
        child: Row(
          children: [
            Icon(
              _logs.showTypes.contains(logType)
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: AppColors().icon,
            ),
            Text(
              logType.name,
              style: TextStyle(color: AppColors().text),
            ),
          ],
        ),
      ),
    );
  }
}
