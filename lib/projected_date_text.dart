import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProjectedDateText extends StatefulWidget {
  final String seconds;

  const ProjectedDateText(this.seconds, {super.key});

  @override
  State<StatefulWidget> createState() => _ProjectedDateTextState();
}

class _ProjectedDateTextState extends State<ProjectedDateText> {
  static final DateFormat _formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

  String get _seconds => widget.seconds;

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int? seconds = int.tryParse(_seconds);
    if (seconds == null) return const SizedBox.shrink();
    final date = DateTime.now().add(Duration(seconds: seconds));
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        'Projected date:\n${_formatter.format(date.toLocal())}',
        textAlign: TextAlign.center,
      ),
    );
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {});
    _refresh();
  }
}
