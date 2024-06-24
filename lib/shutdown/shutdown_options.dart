enum ShutdownType { priority, action }

class ShutdownForm {
  ShutdownOption _priority = const ShutdownForce();
  ShutdownOption _action = const ShutdownDefault();

  ShutdownForm();

  ShutdownOption get priority => _priority;

  set priority(ShutdownOption option) {
    if (option.type != ShutdownType.priority) return;
    _priority = option;
  }

  ShutdownOption get action => _action;

  set action(ShutdownOption option) {
    if (option.type != ShutdownType.action) return;
    _action = option;
  }
}

class ShutdownOptions {
  static final Iterable<ShutdownOption> all = [
    const ShutdownForce(),
    const ShutdownSoft(),
    const ShutdownRestart(),
    const ShutdownDefault(),
    const ShutdownHibernate(),
    const ShutdownLogout(),
  ];

  static Iterable<ShutdownOption> get priority =>
      all.where((option) => option.type == ShutdownType.priority);

  static Iterable<ShutdownOption> get action =>
      all.where((option) => option.type == ShutdownType.action);
}

abstract class ShutdownOption {
  final int id;
  final String command;
  final ShutdownType type;

  const ShutdownOption({
    required this.id,
    required this.command,
    required this.type,
  });
}

class ShutdownForce extends ShutdownOption {
  const ShutdownForce()
      : super(
          id: 0,
          command: '/f',
          type: ShutdownType.priority,
        );
}

class ShutdownSoft extends ShutdownOption {
  const ShutdownSoft()
      : super(
          id: 1,
          command: '',
          type: ShutdownType.priority,
        );
}

class ShutdownRestart extends ShutdownOption {
  const ShutdownRestart()
      : super(
          id: 2,
          command: '/r',
          type: ShutdownType.action,
        );
}

class ShutdownDefault extends ShutdownOption {
  const ShutdownDefault()
      : super(
          id: 3,
          command: '/s',
          type: ShutdownType.action,
        );
}

class ShutdownHibernate extends ShutdownOption {
  const ShutdownHibernate()
      : super(
          id: 4,
          command: '/h',
          type: ShutdownType.action,
        );
}

class ShutdownLogout extends ShutdownOption {
  const ShutdownLogout()
      : super(
          id: 5,
          command: '/l',
          type: ShutdownType.action,
        );
}
