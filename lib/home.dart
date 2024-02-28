import 'package:better_shutdown/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:process_run/shell.dart';

import 'logs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _padding = EdgeInsets.all(8.0);
  final _controller = TextEditingController(text: '0');
  final _shellController = TextEditingController(text: '');
  final _shellFocus = FocusNode();
  final _scrollController = ScrollController();
  final _shell = Shell();
  final _logs = Logs();
  int? _seconds;
  DateTime? _shutdownDate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: _padding,
          child: Row(
            children: [
              Expanded(
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
                          behavior: ScrollConfiguration.of(context)
                              .copyWith(scrollbars: false),
                          child: ListView(
                            shrinkWrap: true,
                            controller: _scrollController,
                            children: [
                              ..._logs.entries,
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
                              user: true,
                              controller: _scrollController,
                            );
                            _shell.run(text).then((result) {
                              // TODO: fix no result
                              for (final single in result) {
                                if (single.errText.isNotEmpty) {
                                  _logs.add(single.errText);
                                }
                              }
                            });
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
                            onPressed: () {
                              final seconds = int.tryParse(_controller.text);
                              if (seconds == null) {
                                _logs.add(
                                  'Incorrect input',
                                  controller: _scrollController,
                                );
                                setState(() {});
                                return;
                              }
                              _seconds = seconds;
                              _shutdownDate = DateTime.now().add(
                                Duration(seconds: seconds),
                              );
                              setState(() {});
                              _timer();
                              _shell.run('shutdown -s -t $seconds');
                              _logs.add(
                                'Shutdown scheduled - $_shutdownDate',
                                controller: _scrollController,
                              );
                            },
                            child: const Text('Start'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _shell.run('shutdown -a');
                              _logs.add(
                                'Shutdown aborted - $_shutdownDate',
                                controller: _scrollController,
                              );
                              _seconds = null;
                              _shutdownDate = null;
                              setState(() {});
                            },
                            child: const Text('Abort'),
                          ),
                        ),
                      ],
                    ),
                    if (_seconds != null) Text('Shutdown in: ${_seconds}s'),
                    if (_shutdownDate != null)
                      Text(
                        'Shutdown at: ${_shutdownDate?.toLocal()}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                  ],
                ),
              ),
            ],
          ),
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
}
