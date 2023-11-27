import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class LockerKey {
  final String value;
  LockerKey(this.value);

  factory LockerKey.unique() => LockerKey(const Uuid().v4());

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LockerKey &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return 'LockerKey{value: $value}';
  }
}

class Locker extends ChangeNotifier {
  Map<LockerKey, bool> state = {};

  Future<T?> lock<T>({
    required Future<T> Function() func,
    required LockerKey key,
  }) async {
    if (state[key] == true) {
      return null;
    }

    state = {...state, key: true};
    T? value;
    notifyListeners();

    try {
      value = await func();
    } finally {
      state = {...state}..remove(key);
      notifyListeners();
    }

    return value;
  }

  static bool isLocked(Map<LockerKey, bool> state, LockerKey key) {
    return state[key] == true;
  }
}

class LockerScope extends StatelessWidget {
  final Widget child;
  const LockerScope({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Locker(),
      child: child,
    );
  }
}

extension LockerX on BuildContext {
  bool watchLocked(LockerKey key) {
    return select<Locker, bool>((value) => Locker.isLocked(value.state, key));
  }

  bool isLocked(LockerKey key) {
    return read<Locker>().state[key] == true;
  }

  LockerWithKey locker<T>(LockerKey key) {
    return LockerWithKey(
      key: key,
      locker: read<Locker>(),
    );
  }

  @Deprecated("use locker<T>(key)")
  LockerWithKey ofLocker<T>(LockerKey key) {
    return LockerWithKey(
      key: key,
      locker: read<Locker>(),
    );
  }
}

class LockerWithKey {
  final LockerKey key;
  final Locker locker;

  LockerWithKey({
    required this.key,
    required this.locker,
  });

  Future<T?> lock<T>(Future<T> Function() func) async {
    return locker.lock(
      func: func,
      key: key,
    );
  }
}
