import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../app_colors.dart';
import '../../../debug/debug.dart';
import '../../../models/logs.dart';
import 'command_line.dart';
import 'filters.dart';

class HomeLogs extends StatefulWidget {
  final ScrollController scrollController;

  const HomeLogs({
    required this.scrollController,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => HomeLogsState();
}

class HomeLogsState extends State<HomeLogs> {
  static const _verticalMargin = SizedBox(height: 4);
  static const _horizontalMargin = SizedBox(width: 4);
  final Logs _logs = Logs();
  final AppColors _appColors = AppColors();
  bool _showFilters = false;

  ScrollController get _scrollController => widget.scrollController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: _appColors.border,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  _createLogs(),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: HomeLogsFilters(_showFilters),
                  ),
                ],
              ),
            ),
            _verticalMargin,
            Row(
              children: [
                _createBtn(
                  () {
                    _showFilters = !_showFilters;
                    if (mounted) setState(() {});
                  },
                  Icons.filter_list_outlined,
                ),
                _horizontalMargin,
                _createBtn(
                  () => _logs.clearLogs(),
                  Symbols.cleaning_services,
                ),
                _horizontalMargin,
                HomeLogsCommandLine(_scrollController),
                _horizontalMargin,
                _createBtn(
                  () {
                    AppColors.switchTheme();
                    Debug.restartApp(context);
                  },
                  AppColors.appTheme == AppTheme.dark
                      ? Icons.light_mode
                      : Icons.dark_mode_outlined,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _createBtn(void Function() onTap, IconData icon) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: _appColors.border),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, color: _appColors.icon),
      ),
    );
  }

  Widget _createLogs() {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: ListenableBuilder(
        listenable: _logs,
        builder: (context, _) {
          return SelectionArea(
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
          );
        },
      ),
    );
  }
}
