import 'package:flutter/widgets.dart';

import 'locker.dart';

typedef BuildLockerButton<T> = Widget Function(
  BuildContext context,
  bool isLocked,
  Future<T?> Function() onPressed,
);

class LockerButtonBuilder<T> extends StatelessWidget {
  final LockerKey lockerKey;
  final Future<T?> Function() onPressed;
  final BuildLockerButton builder;

  const LockerButtonBuilder({
    super.key,
    required this.lockerKey,
    required this.onPressed,
    required this.builder,
  });

  factory LockerButtonBuilder.auto({
    required Future<T?> Function() onPressed,
    required BuildLockerButton builder,
  }) {
    return LockerButtonBuilder(
      lockerKey: LockerKey.unique(),
      onPressed: onPressed,
      builder: builder,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLocked = context.watchLocked(lockerKey);
    return builder(
      context,
      isLocked,
      () async {
        await context.locker(lockerKey).lock(() => onPressed());
      },
    );
  }
}
