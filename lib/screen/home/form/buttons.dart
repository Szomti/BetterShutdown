part of './library.dart';

class HomeFormButtons extends StatefulWidget {
  final MainForm form;

  const HomeFormButtons(this.form, {super.key});

  @override
  State<StatefulWidget> createState() => _HomeFormButtonsState();
}

class _HomeFormButtonsState extends State<HomeFormButtons> {
  final AppColors _appColors = AppColors();
  final Logs _logs = Logs();

  MainForm get _form => widget.form;

  DateTime? get _shutdownDate => _form.shutdownDate;

  ScrollController get _scrollController => _form.scrollController;

  ScheduleField get _currentField => _form.currentField;

  GlobalKey<HomeScreenState> get _homeScreenKey => _form.homeScreenKey;

  int? get _seconds => _form.seconds;

  ShutdownForm get _shutdownForm => _form.shutdownForm;

  ShutdownPriority get _priority => _shutdownForm.priority;

  ShutdownAction get _action => _shutdownForm.action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _createButton(_schedule, 'Start'),
        const SizedBox(width: 8),
        _createButton(_abort, 'Abort'),
      ],
    );
  }

  Widget _createButton(void Function() onPressed, String text) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _appColors.button,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: TextStyle(
              color: _appColors.text,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _abort() async {
    final result = await Process.run(
      'shutdown',
      ['/a'],
    );
    if (result.stderr.toString().trim().isNotEmpty) {
      _logs.addLog(
        result.stderr.toString().trim(),
        type: LogType.error,
        controller: _scrollController,
      );
    } else {
      _logs.addLog(
        'Shutdown aborted - ${_shutdownDate ?? 'unknown'}',
        controller: _scrollController,
      );
    }
    _form.seconds = null;
    _form.shutdownDate = null;
    _homeScreenKey.currentState?.setState(() {});
  }

  Future<void> _schedule() async {
    try {
      _form.processing = true;
      _homeScreenKey.currentState?.setState(() {});
      final seconds = _currentField.seconds;
      if (seconds == null) {
        _logs.addLog(
          'Incorrect input',
          controller: _scrollController,
        );
        _homeScreenKey.currentState?.setState(() {});
        return;
      }
      List<String> time = ['/t', '$seconds'];
      if (!_priority.force) {
        time = [];
        _handleStart(seconds, result: null);
        await Future.delayed(Duration(seconds: seconds));
      }
      final result = await Process.run(
        'shutdown',
        [_action.command, ...time],
        runInShell: true,
      );
      if (result.stderr.toString().trim().isNotEmpty) {
        _logs.addLog(
          result.stderr.toString().trim(),
          type: LogType.error,
          controller: _scrollController,
        );
      }
      if (result.stdout.toString().trim().isNotEmpty) {
        _logs.addLog(
          result.stdout.toString().trim(),
          controller: _scrollController,
        );
      }
      if (_priority.force) _handleStart(seconds, result: result);
    } catch (error) {
      debugPrint('$error');
    } finally {
      await Future.delayed(const Duration(milliseconds: 250));
      _form.processing = false;
      _homeScreenKey.currentState?.setState(() {});
    }
  }

  void _handleStart(int seconds, {required ProcessResult? result}) {
    if (result == null ||
        result.stdout.toString().trim().isEmpty &&
            result.stderr.toString().trim().isEmpty) {
      _form.seconds = seconds;
      _form.shutdownDate = DateTime.now().add(
        Duration(seconds: seconds),
      );
      _homeScreenKey.currentState?.setState(() {});
      unawaited(_timer());
      _logs.addLog(
        'Shutdown scheduled - $_shutdownDate',
        controller: _scrollController,
      );
    }
  }

  Future<void> _timer() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    final seconds = _seconds;
    if (seconds == null || seconds <= 0) return;
    _form.seconds = seconds - 1;
    _homeScreenKey.currentState?.setState(() {});
    unawaited(_timer());
  }
}
