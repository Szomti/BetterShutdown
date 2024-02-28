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
                    ElevatedButton(
                      onPressed: () {
                        final seconds = int.tryParse(_controller.text);
                        if (seconds == null) {
                          _logs.add(
                            'incorrect input',
                            controller: _scrollController,
                          );
                          setState(() {});
                          return;
                        }
                        _shell.run('shutdown -s -t $seconds');
                      },
                      child: const Text('Start'),
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
}
