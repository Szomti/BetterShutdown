import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _padding = EdgeInsets.all(8.0);
  final _controller = TextEditingController();
  final _shell = Shell();
  String info = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: _padding,
          child: Column(
            children: [
              TextField(
                controller: _controller,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  final seconds = int.tryParse(_controller.text);
                  if(seconds == null) {
                    info = 'incorrect input';
                    setState(() {});
                    return;
                  }
                  _shell.run('shutdown -s -t $seconds');
                  },
                child: const Text('Start'),
              ),
              Text(info),
            ],
          ),
        ),
      ),
    );
  }
}
