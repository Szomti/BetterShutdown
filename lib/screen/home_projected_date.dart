import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app_colors.dart';
import '../models/schedule_type.dart';

class HomeProjectedDate extends StatefulWidget {
  final ScheduleField field;

  const HomeProjectedDate(this.field, {super.key});

  @override
  State<StatefulWidget> createState() => _HomeProjectedDateState();
}

class _HomeProjectedDateState extends State<HomeProjectedDate> {
  static final DateFormat _formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

  ScheduleField get _field => widget.field;

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int? seconds = _field.seconds;
    if (seconds == null) return const SizedBox.shrink();
    final date = DateTime.now().add(Duration(seconds: seconds));
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ThemeData.light().primaryColorLight.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Projected date:\n${_formatter.format(date.toLocal())}',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors().text),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {});
    await _refresh();
  }
}
