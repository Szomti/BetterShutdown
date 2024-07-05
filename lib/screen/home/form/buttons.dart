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

  bool get _shutdownActive => _form.shutdownActive;

  ShutdownForm get _shutdownForm => _form.shutdownForm;

  ShutdownPriority get _priority => _shutdownForm.priority;

  ShutdownAction get _action => _shutdownForm.action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _createButton(_shutdownActive ? null : _schedule, 'Start'),
        const SizedBox(width: 8),
        _createButton(_abort, 'Abort'),
      ],
    );
  }

  Widget _createButton(void Function()? onPressed, String text) {
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
    _form.shutdownActive = false;
    if (_priority.force) {
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
    }
    _form.seconds = null;
    _form.shutdownDate = null;
    _form.activeShutdownPriority = null;
    _homeScreenKey.currentState?.setState(() {});
  }

  Future<bool> _checkAndShowDialog() async {
    if (_priority.force) {
      if (_action == ShutdownHibernate() || _action == ShutdownLogout()) {
        await _showDialog(
          'Option <${_action.text}> only works in <${ShutdownSoft().text}> mode.',
        );
        return false;
      }
    }
    if (!_priority.force) {
      await _showDialog(
        'Option <${_priority.text}> requires app to be constantly running.',
      );
      return true;
    }
    return true;
  }

  Future<void> _schedule() async {
    try {
      if (!(await _checkAndShowDialog())) return;
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
      _form.processing = true;
      _homeScreenKey.currentState?.setState(() {});
      ProcessResult? result;
      if (!_form.shutdownActive) {
        result = await Process.run(
          'shutdown',
          [_action.command, ...time],
          runInShell: true,
        );
      }
      if (result == null) return;
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
      _form.shutdownActive = true;
      _form.seconds = seconds;
      _form.activeShutdownPriority = _priority;
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
    if (!mounted || !_form.shutdownActive) return;
    final seconds = _seconds;
    if (seconds == null || seconds <= 0) return;
    _form.seconds = seconds - 1;
    _homeScreenKey.currentState?.setState(() {});
    unawaited(_timer());
  }

  Future<void> _showDialog(String text) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: AppColors().background,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                text,
                                style: TextStyle(
                                  color: _appColors.text,
                                  fontSize: 16.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0)
                                    .copyWith(bottom: 0),
                                child: OutlinedButton(
                                  onPressed: () {
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text(
                                    'Confirm'.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _appColors.text,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
