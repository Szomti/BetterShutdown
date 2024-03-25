import 'package:flutter/material.dart';

import '../../../models/logs.dart';
import '../../../models/main_form.dart';
import '../home.dart';

class HomeFormDate extends StatefulWidget {
  final MainForm form;

  const HomeFormDate(this.form, {super.key});

  @override
  State<StatefulWidget> createState() => _HomeFormDateState();
}

class _HomeFormDateState extends State<HomeFormDate> {
  final Logs _logs = Logs();

  MainForm get _form => widget.form;

  ScrollController get _scrollController => _form.scrollController;

  GlobalKey<HomeScreenState> get _homeScreenKey => _form.homeScreenKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              final now = DateTime.now();
              final date = await showDatePicker(
                context: context,
                firstDate: now,
                lastDate: now.add(const Duration(days: 3630)),
              );
              if (date == null) return;
              if (!context.mounted) return;
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time == null) return;
              final scheduled = date.copyWith(
                hour: time.hour,
                minute: time.minute,
              );
              _form.dateField.date = scheduled;
              _logs.addLog(
                'Selected date: ${scheduled.toLocal()}',
                controller: _scrollController,
              );
              _homeScreenKey.currentState?.setState(() {});
            },
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('Select Date'),
            ),
          ),
        ),
      ],
    );
  }
}
