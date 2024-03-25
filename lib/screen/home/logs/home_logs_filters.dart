import 'package:flutter/material.dart';

import '../../../app_colors.dart';
import '../../../models/log.dart';
import '../../../models/logs.dart';

class HomeLogsFilters extends StatefulWidget {
  final bool showFilters;

  const HomeLogsFilters(this.showFilters, {super.key});

  @override
  State<StatefulWidget> createState() => _HomeLogsFiltersState();
}

class _HomeLogsFiltersState extends State<HomeLogsFilters> {
  final AppColors _appColors = AppColors();
  final Logs _logs = Logs();

  bool get _showFilters => widget.showFilters;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 75),
      child: _showFilters ? _buildMenu() : const SizedBox.shrink(),
    );
  }

  Widget _buildMenu() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Expanded(
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: _appColors.background,
            border: Border.all(color: _appColors.border),
            borderRadius: BorderRadius.circular(4),
          ),
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Show logs:',
                    style: TextStyle(color: _appColors.text),
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
    );
  }

  Widget _buildOption(LogType logType) {
    return GestureDetector(
      onTap: () {
        _logs.handleGivenType(logType);
        if (mounted) setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(1),
        color: _appColors.opposite.withOpacity(0.1),
        child: Row(
          children: [
            Icon(
              _logs.showTypes.contains(logType)
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: _appColors.icon,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Text(
                logType.name,
                style: TextStyle(color: _appColors.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
