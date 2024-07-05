class ShutdownForm {
  ShutdownPriority priority = ShutdownForce();
  ShutdownAction action = ShutdownDefault();

  ShutdownForm();
}

class ShutdownOptions {
  static final Iterable<ShutdownOption> all = {
    ShutdownForce(),
    ShutdownSoft(),
    ShutdownDefault(),
    ShutdownRestart(),
    ShutdownHibernate(),
    ShutdownLogout(),
  };

  static Iterable<ShutdownPriority> get priority =>
      all.whereType<ShutdownPriority>();

  static Iterable<ShutdownAction> get action => all.whereType<ShutdownAction>();
}

abstract class ShutdownOption {
  final int id;
  final String command;
  final String text;

  const ShutdownOption({
    required this.id,
    required this.command,
    required this.text,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShutdownOption &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

abstract class ShutdownPriority extends ShutdownOption {
  final bool force;

  ShutdownPriority({
    required this.force,
    required super.id,
    required super.command,
    required super.text,
  });
}

abstract class ShutdownAction extends ShutdownOption {
  ShutdownAction({
    required super.id,
    required super.command,
    required super.text,
  });
}

class ShutdownForce extends ShutdownPriority {
  ShutdownForce()
      : super(
          id: 0,
          command: '/f',
          text: 'Force',
          force: true,
        );
}

class ShutdownSoft extends ShutdownPriority {
  ShutdownSoft()
      : super(
          id: 1,
          command: '',
          text: 'Soft',
          force: false,
        );
}

class ShutdownDefault extends ShutdownAction {
  ShutdownDefault()
      : super(
          id: 2,
          command: '/s',
          text: 'Shutdown',
        );
}

class ShutdownRestart extends ShutdownAction {
  ShutdownRestart()
      : super(
          id: 3,
          command: '/r',
          text: 'Restart',
        );
}

class ShutdownHibernate extends ShutdownAction {
  ShutdownHibernate()
      : super(
          id: 4,
          command: '/h',
          text: 'Hibernate',
        );
}

class ShutdownLogout extends ShutdownAction {
  ShutdownLogout()
      : super(
          id: 5,
          command: '/l',
          text: 'Logout',
        );
}
