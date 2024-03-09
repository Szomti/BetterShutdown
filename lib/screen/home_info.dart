import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/main_form.dart';

class HomeInfo extends StatefulWidget {
  final MainForm form;

  const HomeInfo(this.form, {super.key});

  @override
  State<StatefulWidget> createState() => HomeInfoState();
}

class HomeInfoState extends State<HomeInfo> {
  static final DateFormat _formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

  MainForm get _form => widget.form;

  DateTime? get _shutdownDate => _form.shutdownDate;

  @override
  Widget build(BuildContext context) {
    final shutdownDate = _shutdownDate;
    if (shutdownDate == null) return const SizedBox.shrink();
    final diff = shutdownDate.difference(DateTime.now()).inSeconds;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Shutdown in: ${diff}s',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Shutdown at: ${_formatter.format(shutdownDate)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
